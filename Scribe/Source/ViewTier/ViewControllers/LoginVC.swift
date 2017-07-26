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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.commonInit()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapped(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
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
            guard let strongSelf = self else { return }
            
            if let user = user {
                strongSelf.hideLoadingIndicator()
                strongSelf.performSegue(withIdentifier: "loginToLanding", sender: nil)
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
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.activityIndicator.isHidden = true
        self.bgImageView.layer.opacity = 0.3
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)
            ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)
            ])
        
        self.loginButton.layer.cornerRadius = 25
    }
    
    private func showLoadingIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
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
    
    
    // MARK: TextField Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let moveUp = CGAffineTransform(translationX: 0, y: -self.stackView.frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.stackView.transform = moveUp
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.stackView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
