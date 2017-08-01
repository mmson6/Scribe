//
//  MoreInfoVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class MoreInfoVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var authenticationView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var churchPickerView: UIPickerView!
    
    var requestModel: SignUpRequest?
//    let churchs = ["US, Atlanta",
//                   "US, Chicago",
//                   "US, New Jersey",
//                   "US, New York",
//                   "US, Michigan",
//                   "US, S. Illinois",
//                   "US, Washington"]
    let churchs = ["US, Chicago"]
    var selectedChurch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.selectedChurch = self.churchs[0]
        self.churchPickerView.selectedRow(inComponent: 0)
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.setLayoutAttributes()
        self.setShadowEffect()
    }
    
    private func setLayoutAttributes() {
        self.signUpButton.layer.cornerRadius = 23
        
        let image = UIImage(named: "back_arrow5")?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(image, for: .normal)
        self.backButton.tintColor = UIColor.scribeDesignTwoDarkBlue
    }
    
    private func setShadowEffect() {
        self.authenticationView.layer.cornerRadius = 3
        self.authenticationView.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.authenticationView.layer.shadowColor = UIColor.black.cgColor
        self.authenticationView.layer.shadowRadius = 10
        self.authenticationView.layer.shadowOpacity = 0.15
        self.authenticationView.layer.masksToBounds = false
    }
    
    private func presentAlert() {
        if let alert = self.createInvalidInputAlert() {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createInvalidInputAlert() -> UIAlertController? {
        
        let alertController = UIAlertController(
            title: RequestSentTitle,
            message: RequestSentMessage,
            preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: OK,
            style: .default,
            handler: { action in
                self.performSegue(withIdentifier: "unwindToLoginView", sender: nil)
        })
        
        alertController.addAction(okayAction)
        
        return alertController
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
    
    // MARK: IBAction Functions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToSignUpVC", sender: self)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.backButton.isEnabled = false
        self.signUpButton.isEnabled = false
        self.activityIndicator.startAnimating()
        
        guard var requestModel = self.requestModel else { return }
        requestModel.church = self.selectedChurch
        let recomposedEmail = self.recomposeEmailForFirebase(requestModel.email)
        
        let baseRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let emailPath = "users/email_pool"
        let emailRef = baseRef.child(emailPath)
        
        var emailJSON: JSONObject = [:]
        emailJSON["email"] = requestModel.email
        emailJSON["name"] = "\(requestModel.first) \(requestModel.last)"
        emailJSON["church"] = requestModel.church
        emailJSON["status"] = "pending"
        
        emailRef.child(recomposedEmail).setValue(emailJSON) { [weak self] (error, ref) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error)
            } else {
                requestSignUp()
//                strongSelf.presentAlert()
            }
//            strongSelf.activityIndicator.stopAnimating()
//            strongSelf.signUpButton.isEnabled = true
//            strongSelf.backButton.isEnabled = true
        }
        
        func requestSignUp() {
            let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
            let path = "users/signup_request"
            let requestRef = ref.child(path)
            let jsonObj = requestModel.asJSON()
            
            requestRef.child(recomposedEmail).setValue(jsonObj) { [weak self] (error, ref) in
                guard let strongSelf = self else { return }
                
                if let error = error {
                    print(error)
                } else {
                    strongSelf.presentAlert()
                }
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.signUpButton.isEnabled = true
                strongSelf.backButton.isEnabled = true
            }
        }
        
//        
//        
//        let first = model.first
//        let last = model.last
//        let email = model.email
//        let password = model.password
//        let church = self.selectedChurch
//        
//        let newEmail = self.recomposeEmailForFirebase(email: email)
//        
//        let key = "\(composed)-\(first):\(last)-\(church)"
//        
//        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
//        let path = "users/signup_request"
//        let requestRef = ref.child(path)
//        let status = "request pending"
//        let object = ["status": status] as Any
//        
//        requestRef.child(key).setValue(object) { [weak self] (error, ref) in
//            guard let strongSelf = self else { return }
//            
//            if let error = error {
//                print(error)
//            } else {
//                strongSelf.presentAlert()
//            }
//            strongSelf.activityIndicator.stopAnimating()
//            strongSelf.signUpButton.isEnabled = true
//            strongSelf.backButton.isEnabled = true
//        }
    }
    
    // MARK: Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    // MARK: PickerView Related Delegate Functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.churchs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.churchs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedChurch = self.churchs[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Remove indicator lines
        let subViews = self.churchPickerView.subviews
        if subViews.count == 3 {
            self.churchPickerView.subviews[1].isHidden = true
            self.churchPickerView.subviews[2].isHidden = true
        }
        
        return 1
    }
}
