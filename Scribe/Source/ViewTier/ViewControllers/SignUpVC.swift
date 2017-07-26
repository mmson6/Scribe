//
//  SignUpVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/26/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authenticationView: UIView!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
        self.addTapGesture()
        // Do any additional setup after loading the view.
    }

    // MARK: Helper Functions
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapped(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func commonInit() {
        self.activityIndicator.isHidden = true
        //        self.bgImageView.layer.opacity = 0.3
        self.setLayoutAttributes()
        self.setShadowEffect()
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
        
        self.signUpButton.layer.cornerRadius = 25
    }
    
    private func setShadowEffect() {
        self.authenticationView.layer.cornerRadius = 3
        self.authenticationView.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.authenticationView.layer.shadowColor = UIColor.black.cgColor
        self.authenticationView.layer.shadowRadius = 10
        self.authenticationView.layer.shadowOpacity = 0.15
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
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
//        self.showLoadingIndicator()
//        
//        let email = "mson62@gmail.com"
//        let password = "123456"
//        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
//            guard let strongSelf = self else { return }
//            
//            if let user = user {
//                strongSelf.hideLoadingIndicator()
//                strongSelf.performSegue(withIdentifier: "loginToLanding", sender: nil)
//            }
//        }
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
}
