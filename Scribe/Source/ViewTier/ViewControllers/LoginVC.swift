//
//  LoginVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import FirebaseAuth


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
        self.activityIndicator.isHidden = true
        
//        self.bgImageView.layer.opacity = 0.3
        self.setLayoutAttributes()
        self.setShadowEffect()
        self.initTransitionAnimation()
        self.addTapGesture()
    }
    private func initTransitionAnimation() {
        self.transitioningDelegate = self.animator
    }
    
    private func hideLoadingIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func setLayoutAttributes() {
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email address", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 0.5)
            ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 0.5)
            ])
        
        self.loginButton.layer.cornerRadius = 25
    }
    
    private func setShadowEffect() {
        self.authenticationView.layer.cornerRadius = 3
        self.authenticationView.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.authenticationView.layer.shadowColor = UIColor.black.cgColor
        self.authenticationView.layer.shadowRadius = 10
        self.authenticationView.layer.shadowOpacity = 0.3
        self.authenticationView.layer.masksToBounds = false
    }
    
    private func showLoadingIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
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
        self.showLoadingIndicator()
        //        guard
        //            let email = self.emailTextField.text,
        //            let password = self.passwordTextField.text
        //        else {
        //            return
        //        }
        let email = "mson62@gmail.com"
        let password = "123456"
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                print("Error occurred: \(error)")
            }
            guard let strongSelf = self else { return }
            
            if let user = user {
                strongSelf.hideLoadingIndicator()
                strongSelf.performSegue(withIdentifier: "loginToLanding", sender: nil)
                strongSelf.loginButton.isEnabled = true
                strongSelf.signUpButton.isEnabled = true
            }
        }
        //
        //        if Auth.auth().currentUser != nil {
        //            print("user signed in")
        //            let user = Auth.auth().currentUser
        //            if let user = user {
        //
        //                let email = user.email
        //                print(email)
        //            }
        //
        //        } else {
        //            print("no users")
        //        }
        //
        
        //
        //        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
        //            print(user)
        //            print(error)
        //
        //            if let user = user {
        //                print(user.displayName)
        //                print(user.photosysURL)
        //            }
        //        }
        //
    }
    
    // MARK: TextField Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let moveUp = CGAffineTransform(translationX: 0, y: -self.authenticationView.frame.height/2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.authenticationView.transform = moveUp
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.authenticationView.transform = CGAffineTransform.identity
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
