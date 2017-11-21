//
//  SettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseAuth


class SettingsVC: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViewLayout()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Helper Functions
    
    private func initializeViewLayout() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - TableViewController Delegate Functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        UITableViewCell.applyScribeCellAttributes(to: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard
            let cell = tableView.cellForRow(at: indexPath),
            let identifier = cell.reuseIdentifier
        else {
            self.showDropDownToast(message: "Function Not Supported Yet")
            return
        }
        
        switch identifier {
        case "LogOutCell":
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            NotificationCenter.default.post(name: userLoggedOut, object: nil)
            performSegue(withIdentifier: "unwindToLandingView", sender: nil)
        default:
            break
        }
        
        
//        
//        // TEST
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
    
    // MARK: IBAction Functions
    
    @IBAction func unwindToSettingsVC(segue: UIStoryboardSegue) {
        
    }
}
