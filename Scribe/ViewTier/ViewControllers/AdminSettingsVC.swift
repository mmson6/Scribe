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

    @IBOutlet weak var signUpRequestBadgeLabel: UILabel!
    
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
    
    // MARK: UITableViewController Functions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.signUpRequestBadgeLabel.layer.cornerRadius = self.signUpRequestBadgeLabel.frame.width / 2
        self.signUpRequestBadgeLabel.layer.masksToBounds = true
//        self.fetchRequestDataSource()
    }
    
    private func commonInit() {
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateUserRequestsBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUserRequestsBadge()
    }
    
    // MARK: UITableView Related Functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        UITableViewCell.applyScribeCellAttributes(to: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard
            let _ = cell.reuseIdentifier
        else {
            self.showDropDownToast(message: "Function Not Supported Yet")
            return
        }
    }

    // MARK: Helper Functions
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: userRequestsCountChanged,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.updateUserRequestsBadge()
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: openFromSignUpRequest,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.performSegue(withIdentifier: "userSignUpRequestsSegue", sender: nil)
//                let indexPath = IndexPath(row: 0, section: 0)
//                self.tableView(self.tableView, didSelectRowAt: indexPath)
//                super.tableView(tableView(self.tableView, didSelectRowAt: indexPath))
//                strongSelf.tableView(didselect)
//                super.tableView(strongSelf.tableView, didSelectRowAt: indexPath)
//                strongSelf.tableView.select
//                strongSelf.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    private func updateUserRequestsBadge() {
        guard
            let controller = self.tabBarController,
            let items = controller.tabBar.items,
            let item = items.last,
            let value = item.badgeValue
        else {
            self.signUpRequestBadgeLabel.isHidden = true
            return
        }
        
        if self.signUpRequestBadgeLabel != nil {
            self.signUpRequestBadgeLabel.text = value
            self.signUpRequestBadgeLabel.isHidden = false
        }
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
