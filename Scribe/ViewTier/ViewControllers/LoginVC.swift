//
//  LoginVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging


class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpContainerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authenticationView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let animator = SlowDissolveTransitionAnimator()
    
    
    // MARK: UIViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInit()
    }

    // MARK: Helper Functions
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapped(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func commonInit() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
//        self.bgImageView.layer.opacity = 0.3
        self.setLayoutAttributes()
        self.setShadowEffect()
        self.initTransitionAnimation()
        self.addTapGesture()
    }
    private func initTransitionAnimation() {
        self.transitioningDelegate = self.animator
    }
    
    private func setLayoutAttributes() {
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email address", attributes: [
            NSAttributedStringKey.foregroundColor: UIColor(white: 0.8, alpha: 0.5)
            ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [
            NSAttributedStringKey.foregroundColor: UIColor(white: 0.8, alpha: 0.5)
            ])
        
        self.loginButton.layer.cornerRadius = 23
    }
    
    private func setShadowEffect() {
        self.authenticationView.layer.cornerRadius = 3
        self.authenticationView.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.authenticationView.layer.shadowColor = UIColor.black.cgColor
        self.authenticationView.layer.shadowRadius = 10
        self.authenticationView.layer.shadowOpacity = 0.3
        self.authenticationView.layer.masksToBounds = false
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
    
    private func isAdmin(user: User, with email: String, callback: @escaping (AsyncResult<Bool>) -> Void) {
//        let recomposedEmail = self.recomposeEmailForFirebase(email)
        let uid = user.uid
        
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "users/profiles/\(uid)"
        let usersEmailRef = rootRef.child(path)
        
        usersEmailRef.observeSingleEvent(of: .value, with: { snap in
            if let snapArray = snap.children.allObjects as? [DataSnapshot] {
                for json in snapArray {
                    if json.key == "isAdmin" {
                        callback(.success(true))
                        return
                    }
                }
                callback(.success(false))
            }
        })
    }
    
    private func presentWrongCredentialsAlert() {
        let alertController = UIAlertController(
            title: InvalidCredentialsTitle,
            message: InvalidCredentialsMessage,
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

    // MARK: IBAction Functions
    
    @IBAction func handleScreenTapped(_ sender: UITapGestureRecognizer) {
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.loginButton.isEnabled = false
        self.signUpButton.isEnabled = false
        self.activityIndicator.startAnimating()
        //        guard
        //            let email = self.emailTextField.text,
        //            let password = self.passwordTextField.text
        //        else {
        //            return
        //        }
        let email = "mson62@gmail.com"
//        let email = "mmson6@gmail.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error occurred: \(error)")
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.loginButton.isEnabled = true
                strongSelf.signUpButton.isEnabled = true
                strongSelf.presentWrongCredentialsAlert()
                return
            }
            
            if let user = user {
                strongSelf.isAdmin(user: user, with: email, callback: { result in
                    switch result {
                    case .success(let isAdmin):
                        if isAdmin {
                            let store = UserDefaultsStore()
                            store.setUserAdminStatus()
                            Messaging.messaging().subscribe(toTopic: "admin")
                            NSLog("Subscribed to topic 'admin'")
                        }
                    case .failure:
                        break
                    }
                    
                    strongSelf.performSegue(withIdentifier: "loginToLanding", sender: nil)
                    
                    
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.loginButton.isEnabled = true
                    strongSelf.signUpButton.isEnabled = true
                })
            }
        }
    }
    
    // MARK: TextField Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let moveUp = CGAffineTransform(translationX: 0, y: -self.authenticationView.frame.height/2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.authenticationView.transform = moveUp
            self.signUpContainerView.transform = moveUp
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.authenticationView.transform = CGAffineTransform.identity
            self.signUpContainerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 0:
            self.passwordTextField.becomeFirstResponder()
        case 1:
            self.loginButtonTapped(textField)
            textField.resignFirstResponder()
        default:
            break
        }
        // Do not add a line break
        return false
    }
    
    // MARK: - Navigation

    @IBAction func unwindToLoginView(segue: UIStoryboardSegue) {
        
    }
    
}
