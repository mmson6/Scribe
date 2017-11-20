//
//  LanguageSettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class LanguageSettingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath),
            let lang = cell.reuseIdentifier
        else {
            return
        }
        
        if let alert = self.createConfirmAlert(for: lang) {
            present(alert, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Helper Functions
    
    private func createConfirmAlert(for lang: String) -> UIAlertController? {

        let alertController = UIAlertController(
            title: "Change Language?",
            message: "Are you sure you want to change the language?",
            preferredStyle: .alert
        )
        
        let changeAction = UIAlertAction(
            title: "Change",
            style: .default,
            handler: { [weak self] action in
                guard let strongSelf = self else { return }
                let store = UserDefaultsStore()
                store.saveMainLanguage(lang)
                NotificationCenter.default.post(name: mainLanguageChanged, object: nil)
                strongSelf.performSegue(withIdentifier: "unwindToSettingsVC", sender: nil)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }

}
