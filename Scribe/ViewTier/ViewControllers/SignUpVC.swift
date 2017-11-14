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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var churchPickerView: UIPickerView!
    @IBOutlet weak var authenticationView: UIView!
    @IBOutlet weak var firstNameTextField: LoginTextField!
    @IBOutlet weak var lastNameTextField: LoginTextField!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var custumNavBar: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
        self.addTapGesture()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.firstNameTextField.text?.characters.count == 0 {
            self.firstNameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Helper Functions
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenTapped(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func commonInit() {
        self.setLayoutAttributes()
        self.setShadowEffect()
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
        
        self.nextButton.layer.cornerRadius = 23
    }
    
    private func setShadowEffect() {
        self.authenticationView.layer.cornerRadius = 3
        self.authenticationView.layer.shadowOffset = CGSize(width: 8.0, height: 8.0)
        self.authenticationView.layer.shadowColor = UIColor.black.cgColor
        self.authenticationView.layer.shadowRadius = 10
        self.authenticationView.layer.shadowOpacity = 0.15
        self.authenticationView.layer.masksToBounds = false
    }
    
    private func isValidName(_ name: String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return name.rangeOfCharacter(from: characterset.inverted) == nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isUniqueEmail(_ email: String, callback: @escaping (AsyncResult<Bool>) -> Void) {
        let parts = email.components(separatedBy: ".")
        var recomposed = ""
        for part in parts {
            recomposed.append(part)
            if parts.last != part {
                recomposed.append("_")
            }
        }
        
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let path = "users/emails/" + recomposed
        let usersEmailRef = rootRef.child(path)
        usersEmailRef.observeSingleEvent(of: .value, with: { snap in
            if let snapArray = snap.children.allObjects as? [DataSnapshot] {
                if snapArray.count > 0 {
                    callback(.success(false))
                } else {
                    callback(.success(true))
                }
            }
        })
    }
    
    private func validateTextFields(){
        var title: String
        var message: String
        
        if let firstName = self.firstNameTextField.text {
            if firstName.characters.count <= 0 {
                title = InvalidNameTitle
                message = EmptyFirstNameMessage
                self.presentAlert(with: title, and: message, for: self.firstNameTextField)
                return
            } else if !self.isValidName(firstName) {
                title = InvalidNameTitle
                message = InvalidFirstNameMessage
                self.presentAlert(with: title, and: message, for: self.firstNameTextField)
                return
            }
        }
        if let lastName = self.lastNameTextField.text {
            if lastName.characters.count <= 0 {
                title = InvalidNameTitle
                message = EmptyLastNameMessage
                self.presentAlert(with: title, and: message, for: self.lastNameTextField)
                return
            } else if !self.isValidName(lastName) {
                title = InvalidNameTitle
                message = InvalidLastNameMessage
                self.presentAlert(with: title, and: message, for: self.lastNameTextField)
                return
            }
        }
        if let email = self.emailTextField.text {
            if email.characters.count <= 0 {
                title = InvalidEmailTitle
                message = EmptyEmailMessage
                self.presentAlert(with: title, and: message, for: self.emailTextField)
                return
            } else if !self.isValidEmail(email) {
                title = InvalidEmailTitle
                message = InvalidEmailMessage
                self.presentAlert(with: title, and: message, for: self.emailTextField)
                return
            } else {
                self.activityIndicator.startAnimating()
                self.isUniqueEmail(email) { result in
                    self.activityIndicator.stopAnimating()
                    switch result {
                    case .success(let unique):
                        if unique {
                            validatePassword()
                        } else {
                            let title = InvalidEmailTitle
                            let message = DuplicateEmailMessage
                            self.presentAlert(with: title, and: message, for: self.emailTextField)
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
        
        func validatePassword() {
            if let password = self.passwordTextField.text {
                if password.characters.count <= 5 {
                    let title = InvalidPasswordTitle
                    let message = InvalidPasswordMessage
                    self.presentAlert(with: title, and: message, for: self.passwordTextField)
                    return
                } else {
                    self.navigateToNextView()
                }
            }
        }
    }
    
    private func presentAlert(with title: String, and message: String, for textField: UITextField) {
        let alert = self.createInvalidInputAlert(with: title, and: message, for: textField)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createInvalidInputAlert(with title: String, and message: String, for textField: UITextField) -> UIAlertController {
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
            if (textField.text?.characters.count)! > 0 {
                title = InvalidEmailTitle
                message = InvalidEmailMessage
            } else {
                title = InvalidEmailTitle
                message = EmptyEmailMessage
            }
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
    
    @IBAction func handleScreenTapped(_ sender: UITapGestureRecognizer?) {
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
        self.validateTextFields()
    }
    
    // MARK: Navigation Functions
    
    private func navigateToNextView() {
        self.performSegue(withIdentifier: "signUpToMoreInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let first = self.firstNameTextField.text,
            let last = self.lastNameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let destVC = segue.destination as? MoreInfoVC
        else {
            return
        }
        
        let model = SignUpRequest(first: first, last: last, email: email, password: password)
        destVC.requestModel = model
        
        self.handleScreenTapped(nil)
    }
    
    @IBAction func unwindToSignUpVC(segue: UIStoryboardSegue) {
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        
        if tag == 0 || tag == 1 {
            if self.isValidName(string) {
                return true
            } else {
                return false
            }
        }
        
        return true
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
