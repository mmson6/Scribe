//
//  LoginVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.layer.opacity = 0.3
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSForegroundColorAttributeName: UIColor.white
            ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSForegroundColorAttributeName: UIColor.white
            ])
        
        self.loginButton.layer.cornerRadius = 25

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
