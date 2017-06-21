//
//  SettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseAuth


class SettingsVC: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
//        Auth.auth().
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
