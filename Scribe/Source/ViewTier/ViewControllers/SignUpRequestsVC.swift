//
//  SignUpRequestsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/31/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth


class SignUpRequestsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SignUpRequestCellDelegate {
    
    @IBOutlet var noRequestsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var signUpRequestDataSource = [SignUpRequestVOM]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.fetchRequestDataSource()
    }
    
    // MARK: UITableView Related Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkForAvailableRequests()
        return self.signUpRequestDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let requestModel = self.signUpRequestDataSource[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "adminSettingCell", for: indexPath) as? SignUpRequestCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        self.populate(cell: cell, model: requestModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Helper Function
    
    private func fetchRequestDataSource() {
        self.showLoadingIndicator()
        let cmd = FetchSignUpRequestsCommand()
        cmd.onCompletion { result in
            self.hideLoadingIndicator()
            switch result {
            case .success(let array):
                self.signUpRequestDataSource = array
//                self.tableView.reloadData()
            case .failure(let error):
                NSLog("Error occurred: \(error)")
            }
            self.tableView.reloadData()
            
        }
        cmd.execute()
    }
    
    private func commonInit() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 2.5))
        emptyHeaderView.backgroundColor = UIColor.rgb(red: 250, green: 252, blue: 255)
        self.tableView.tableHeaderView = emptyHeaderView
        self.tableView.tableFooterView = emptyHeaderView
        
        // Add activity indicator to the view
        self.activityIndicatorView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        self.tableView.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.isHidden = true
        
        // Add no requests view to tableView
        self.noRequestsView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        self.tableView.addSubview(self.noRequestsView)
        self.noRequestsView.isHidden = true
    }
    
//    private func provisionUserEmail(model: SignUpRequestVOM, callback: @escaping (AsyncResult<Bool>) -> Void) {
    private func provisionUserEmail(model: SignUpRequestVOM) {
        let recomposedEmail = self.recomposeEmailForFirebase(model.email)
        
        let baseRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let emailPath = "users/emails"
        let emailRef = baseRef.child(emailPath)
        
        var emailJSON: JSONObject = [:]
        emailJSON["email"] = model.email
        emailJSON["name"] = "\(model.firstName) \(model.lastName)"
        emailJSON["church"] = model.church
        emailJSON["status"] = "provisioned"
        
        emailRef.child(recomposedEmail).setValue(emailJSON) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func registerUser(model: SignUpRequestVOM, callback: @escaping (AsyncResult<Bool>) -> Void) {
        Auth.auth().createUser(withEmail: model.email, password: model.password) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error occurred: \(error)")
                callback(.failure(error))
                return
            }
            
            if let user = user {
                DispatchQueue.main.async {
                    print("async addUserProfile")
                    strongSelf.addUserProfile(user: user, model: model) { result in
                        switch result {
                        case .success(let success):
                            if success {
                                print("User \(model.firstName) \(model.lastName) created successfully")
                                strongSelf.removeHandledSignUpRequest(model: model, callback: callback)
                            }
                        case .failure(let error):
                            callback(.failure(error))
                            print("Error occurred: \(error)")
                        }
                    }
                }
                DispatchQueue.main.async {
                    print("async provisionUserEmail")
                    strongSelf.provisionUserEmail(model: model)
                }
            }
        }
    }
    
    private func addUserProfile(user: User, model: SignUpRequestVOM, callback: @escaping ((AsyncResult<Bool>) -> Void)) {
        let uid = user.uid
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let storeRef = rootRef.child("users/profiles").child(uid)
        let data = model.asJSON()
        storeRef.updateChildValues(data) { (error, ref) in
            if let error = error {
                print("Error occurred while adding User Profile: \(error)")
                callback(.failure(error))
                return
            }
            callback(.success(true))
        }
    }
    
    private func clearEmailFromPool(model: SignUpRequestVOM, callback: @escaping (AsyncResult<Bool>) -> Void) {
        
        let recomposedEmail = self.recomposeEmailForFirebase(model.email)
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "users/emails/" + recomposedEmail
        let usersEmailRef = rootRef.child(path)
        usersEmailRef.removeValue { (error, ref) in
            if let error = error {
                print("Error occurred removeHandledSignUpRequest: \(error)")
                return
            }
            print(ref)
            callback(.success(true))
        }
    }
    
    private func removeHandledSignUpRequest(model: SignUpRequestVOM, callback: @escaping (AsyncResult<Bool>) -> Void) {
        let recomposedEmail = self.recomposeEmailForFirebase(model.email)
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "users/requests/signup/" + recomposedEmail
        let usersEmailRef = rootRef.child(path)
        usersEmailRef.removeValue { (error, ref) in
            if let error = error {
                print("Error occurred removeHandledSignUpRequest: \(error)")
                callback(.failure(error))
                return
            }
            callback(.success(true))
        }
    }
    
    private func isUniqueEmail(_ email: String, callback: @escaping (AsyncResult<Bool>) -> Void) {
        let recomposedEmail = self.recomposeEmailForFirebase(email)
        
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "users/emails/" + recomposedEmail
        let usersEmailRef = rootRef.child(path)
        
        usersEmailRef.observeSingleEvent(of: .value, with: { snap in
            if let snapArray = snap.children.allObjects as? [DataSnapshot] {
                for json in snapArray {
                    if json.key == "status" {
                        if json.value as? String == "pending" {
                            callback(.success(true))
                        } else {
                            callback(.success(false))
                        }
                    }
                }
            }
        })
    }
    
    private func showLoadingIndicator() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func checkForAvailableRequests() {
        if !self.activityIndicator.isAnimating {
            if self.signUpRequestDataSource.count == 0 {
                self.noRequestsView.isHidden = false
            } else if self.signUpRequestDataSource.count > 0 {
                self.noRequestsView.isHidden = true
            }
        }
    }
    
    private func recomposeEmailForFirebase(_ email: String) -> String {
        let parts = email.components(separatedBy: ".")
        var recomposed = ""
        for part in parts {
            recomposed.append(part)
            if parts.last != part {
                recomposed.append("_")
            }
        }
        
        return recomposed
    }
    
    private func populate(cell: SignUpRequestCell, model: SignUpRequestVOM) {
        cell.requestModel = model
        
        let fullName = "\(model.firstName) \(model.lastName)"
        cell.nameLabel.text = fullName
        cell.emailLabel.text = model.email
    }
    
    private func handleAcceptSignUp(model: SignUpRequestVOM, indexPath: IndexPath) {
        self.isUniqueEmail(model.email) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let unique):
                if unique {
                    strongSelf.registerUser(model: model) { result in
                        strongSelf.hideLoadingIndicator()
                        switch result {
                        case .success(let success):
                            if success {
                                strongSelf.signUpRequestDataSource.remove(at: indexPath.row)
                                strongSelf.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                            }
                        case .failure:
                            break
                        }
                    }
                } else {
                    print("Unique Email success false")
                    strongSelf.hideLoadingIndicator()
                    strongSelf.presentDuplicateEmailAlert()
                    strongSelf.signUpRequestDataSource.remove(at: indexPath.row)
                    strongSelf.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                }
            case .failure:
                print("Unique Email failed")
                break
            }
        }
    }
    
    private func handleDenySignUp(model: SignUpRequestVOM, indexPath: IndexPath) {
        self.removeHandledSignUpRequest(model: model) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let success):
                if success {
                    clearEmailFromPool()
                }
            case .failure:
                strongSelf.hideLoadingIndicator()
                break
            }
        }
        
        func clearEmailFromPool() {
            self.clearEmailFromPool(model: model) { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.hideLoadingIndicator()
                
                switch result {
                case .success(let success):
                    if success {
                        strongSelf.signUpRequestDataSource.remove(at: indexPath.row)
                        strongSelf.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    private func createAcceptAlert(model: SignUpRequestVOM, indexPath: IndexPath) -> UIAlertController {
        
        let alertController = UIAlertController(
            title: "Accept Sign Up",
            message: "Are you sure you want to accept this account?",
            preferredStyle: .alert
        )
        
        let acceptAction = UIAlertAction(
            title: "Accept",
            style: .default,
            handler: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.showLoadingIndicator()
                strongSelf.handleAcceptSignUp(model: model, indexPath: indexPath)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func createDenyAlert(model: SignUpRequestVOM, indexPath: IndexPath) -> UIAlertController {
        
        let alertController = UIAlertController(
            title: "Deny Sign Up",
            message: "Are you sure you want to deny this account?",
            preferredStyle: .alert
        )
        
        let acceptAction = UIAlertAction(
            title: "Deny",
            style: .destructive,
            handler: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.showLoadingIndicator()
                strongSelf.handleDenySignUp(model: model, indexPath: indexPath)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func presentDuplicateEmailAlert() {
        let alertController = UIAlertController(
            title: InvalidEmailTitle,
            message: SnatchedEmailMessage,
            preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: OK,
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: SignUpRequestCellDelegate Functions
    
    internal func showAcceptAlert(with model: SignUpRequestVOM, sender: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: sender) else { return }
        let alert = self.createAcceptAlert(model: model, indexPath: indexPath)
        self.present(alert, animated: true)
    }
    
    internal func showDenyAlert(with model: SignUpRequestVOM, sender: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: sender) else { return }
        let alert = self.createDenyAlert(model: model, indexPath: indexPath)
        self.present(alert, animated: true)
    }
}
