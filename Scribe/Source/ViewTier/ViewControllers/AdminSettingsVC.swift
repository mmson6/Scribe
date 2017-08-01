//
//  AdminSettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class AdminSettingsVC: UITableViewController {

    var signUpRequestDataSource = [SignUpRequestVOM]()
    var emails: [String] {
        let email1 = "mmson6@gmail.com"
        let email2 = "mike_mws@hotmail.com"
        let email3 = "mike2@gmail.com"
        let email4 = "mike3@gmail.com"
        let email5 = "mike4@gmail.com"
        let email6 = "mike5@gmail.com"
        let email7 = "mike6@gmail.com"
        
        let emails = [email1, email2, email3, email4, email5, email6, email7]
        return emails
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.commonInit()
//        self.fetchRequestDataSource()
    }
    
    private func commonInit() {
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 70
    }
    
    // MARK: UITableView Related Functions
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.signUpRequestDataSource.count
//    }
//    
//    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Helper Functions
    
    
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
