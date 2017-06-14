//
//  ContactsCoordinator.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FontAwesomeKit

public let defaultContatIndex = 0

public enum ContactType {
    case list
    case group
}

class ContactsCoordinator: UIViewController {
    
    @IBOutlet weak var contactListView: UIView!
    @IBOutlet weak var contactGroupView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    internal var contactType: ContactType = .list
    
    // MARK: UIViewController 
    
    
    override func viewDidLoad() {
        self.initializeTabBarItems()
    }
    
    // MARK: Private Functions
    
    private func initializeTabBarItems() {
        let settingsIcon = FAKIonIcons.iosSettingsIcon(withSize: 30)
        let contactIcon = FAKIonIcons.iosContactIcon(withSize: 30)
        if let tabBarItems = self.tabBarController?.tabBar.items {
            tabBarItems[0].image = contactIcon?.image(with: CGSize(width: 30, height: 30))
            tabBarItems[1].image = settingsIcon?.image(with: CGSize(width: 30, height: 30))
        }
    }
    
    // MARK : IBAction Methods
    
    @IBAction func groupButtonTapped(_ sender: Any) {
        guard
            let button = sender as? UIButton
            else {
                return
        }
        
        button.isSelected = !button.isSelected
        
        print(button.state)
        if !button.isSelected {
            UIView.animate(withDuration: 0.5, animations: {
//                self.navigationController?.navigationBar.barTintColor = UIColor.white
//                self.navigationController?.navigationBar.layoutIfNeeded()
//                self.navigationController?.navigationBar.tintColor = UIColor.scribeColorNavigationBlue
            })
            
            self.contactType = .list
            self.contactGroupView.isHidden = true
            self.contactListView.isHidden = false
            
        } else {
            UIView.animate(withDuration: 0.5, animations: {
//                self.navigationController?.navigationBar.barTintColor = UIColor.scribeColorBackgroundBeige
//                self.navigationController?.navigationBar.layoutIfNeeded()
//                UINavigationBar.appearance().barTintColor = UIColor.scribeColorBackgroundBeige
//                self.navigationController?.navigationBar.tintColor = UIColor.gray
            })
            
            self.contactType = .group
            
            self.contactGroupView.isHidden = false
            self.contactListView.isHidden = true
        }
    }
    @IBAction func toggleTapped(_ sender: Any) {
       
    }
//    @IBAction func toggleContactDisplayType(_ sender: Any) {
//        guard let segmentedControl = sender as? UISegmentedControl else { return }
//        
//        let selectedIndex = segmentedControl.selectedSegmentIndex
//        
//        if selectedIndex == defaultContatIndex {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.navigationController?.navigationBar.tintColor = UIColor.scribeColorNavigationBlue
////                self.navigationController?.navigationBar.barTintColor = UIColor.white
//            })
//            
//            self.contactType = .list
//            self.contactGroupView.isHidden = true
//            self.contactListView.isHidden = false
////            self.tabBarController?.tabBar.tintColor = UIColor.scribeColorNavigationBlue
//            
//        } else {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.navigationController?.navigationBar.tintColor = UIColor.gray
////                self.navigationController?.navigationBar.barTintColor = UIColor.scribeColorNavigationBlue
//            })
//            
//            self.contactType = .group
////            self.tabBarController?.tabBar.tintColor = UIColor.cyan
//            self.contactGroupView.isHidden = false
//            self.contactListView.isHidden = true
//        }
//    }
}
