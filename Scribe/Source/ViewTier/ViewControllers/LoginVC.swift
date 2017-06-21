//
//  LoginVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginVC: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.layer.opacity = 0.3
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)
            ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.5)
            ])
        
        self.loginButton.layer.cornerRadius = 25

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let user = user {
                self.performSegue(withIdentifier: "loginToLanding", sender: nil)
            }
            print(user)
            print(error)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
