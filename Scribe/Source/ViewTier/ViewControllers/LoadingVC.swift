//
//  LoadingVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseAuth


class LoadingVC: UIViewController {

    public var contactDataSource = [ContactVOM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.runLifeCycle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    private func performSegueToLogin() {
        self.performSegue(withIdentifier: "loadingToLogin", sender: nil)
    }
    
    private func performSegueToMain() {
        self.performSegue(withIdentifier: "loadingToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loadingToMain" {
            guard
                let vc = segue.destination as? MainTabBarVC
                else {
                    return
            }
            guard
                let navController = vc.viewControllers?[0] as? UINavigationController,
                let contactVC = navController.topViewController as? ContactsCoordinatorVC
                else {
                    return
            }
            
            contactVC.contactDataSource = self.contactDataSource
        }
    }
    
    private func runLifeCycle() {
        if Auth.auth().currentUser != nil {
            self.performSegueToMain()
//            self.fetchContactDataSource()
        } else {
            self.performSegueToLogin()
        }
    }
    
    @IBAction func unwindToLandingView(segue: UIStoryboardSegue) {
        
    }
    
}
