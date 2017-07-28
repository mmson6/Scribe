//
//  SignUpVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/26/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var churchPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authenticationView: UIView!
    @IBOutlet weak var firstNameTextField: LoginTextField!
    @IBOutlet weak var lastNameTextField: LoginTextField!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var custumNavBar: UILabel!
    
    
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
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter first Name", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 0.5)
            ])
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter last name", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 0.5)
            ])
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
    
    private func presentAlert(for textField: UITextField) {
        if let alert = self.createInvalidInputAlert(for: textField) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createInvalidInputAlert(for textField: UITextField) -> UIAlertController? {
        
        let title: String
        let message: String
        
        let tag = textField.tag
        switch tag {
        case 0: // First name
            title = InvalidNameTitle
            message = EmptyFirstNameMessage
        case 1: // Last name
            title = InvalidNameTitle
            message = EmptyLastNameMessage
        case 2: // Email address
            title = InvalidEmailTitle
            message = EmptyEmailMessage
        case 3: // Password
            title = InvalidPasswordTitle
            message = InvalidPasswordMessage
        default:
            title = InvalidInputTitle
            message = InvalidInputMessage
            break
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: OK,
            style: .default,
            handler: { action in
                textField.becomeFirstResponder()
        })
        
        alertController.addAction(okayAction)
        
        return alertController
    }

    
    // MARK: IBAction Functions
    
    @IBAction func handleScreenTapped(_ sender: UITapGestureRecognizer) {
        if self.firstNameTextField.isFirstResponder {
            self.firstNameTextField.resignFirstResponder()
        }
        if self.lastNameTextField.isFirstResponder {
            self.lastNameTextField.resignFirstResponder()
        }
        if self.emailTextField.isFirstResponder {
            self.emailTextField.resignFirstResponder()
        }
        if self.passwordTextField.isFirstResponder {
            self.passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if (self.firstNameTextField.text?.characters.count)! <= 0 {
            self.presentAlert(for: self.firstNameTextField)
            return
        }
        if (self.lastNameTextField.text?.characters.count)! <= 0 {
            self.presentAlert(for: self.lastNameTextField)
            return
        }
        if (self.emailTextField.text?.characters.count)! <= 0 {
            self.presentAlert(for: self.emailTextField)
            return
        }
        if (self.passwordTextField.text?.characters.count)! <= 0 {
            self.presentAlert(for: self.passwordTextField)
            return
        }

        guard
            let first = self.firstNameTextField.text,
            let last = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            first != "",
            last != "",
            email != "",
            password != ""
        else {
            return
        }
        
        self.performSegue(withIdentifier: "signUpToMoreInfo", sender: self)
    }
    
    // MARK: Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let first = self.firstNameTextField.text,
            let last = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let destVC = segue.destination as? MoreInfoViewController
        else {
            return
        }
        
        let model = SignUpRequest(first: first, last: last, email: email, password: password)
        destVC.requestModel = model
    }
    
    // MARK: TextField Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        func performReset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.authenticationView.transform = CGAffineTransform.identity
                self.bottomView.transform = CGAffineTransform.identity
                self.custumNavBar.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        func performMoveUp(value: CGFloat) -> Void {
            let moveUp = CGAffineTransform(translationX: 0, y: -value)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.authenticationView.transform = moveUp
                self.bottomView.transform = moveUp
                self.custumNavBar.transform = moveUp
            }, completion: nil)
        }
        
        let tag = textField.tag
        
        switch tag {
        case 0: // First name field
            performReset()
        case 1: // Last name field
            performReset()
        case 2: // Email address field
            performReset()
        case 3: // Password field
            performMoveUp(value: 65)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.authenticationView.transform = CGAffineTransform.identity
            self.bottomView.transform = CGAffineTransform.identity
            self.custumNavBar.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 0:
            self.lastNameTextField.becomeFirstResponder()
        case 1:
            self.emailTextField.becomeFirstResponder()
        case 2:
            self.passwordTextField.becomeFirstResponder()
        case 3:
            textField.resignFirstResponder()
            self.nextButtonTapped(textField)
        default:
            break
        }
        
        return false
    }
}
