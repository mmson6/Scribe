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
    
    internal var contactType: ContactType = .list
    
    // MARK: UIViewController 
    
    
    override func viewDidLoad() {
        self.initializeTabBarItems()
    }
    
    // MARK: Private Init Method
    
    private func initializeTabBarItems() {
        let settingsIcon = FAKIonIcons.iosSettingsIcon(withSize: 30)
        let contactIcon = FAKIonIcons.iosContactIcon(withSize: 30)
        if let tabBarItems = self.tabBarController?.tabBar.items {
            tabBarItems[0].image = contactIcon?.image(with: CGSize(width: 30, height: 30))
            tabBarItems[1].image = settingsIcon?.image(with: CGSize(width: 30, height: 30))
        }
    }
    
    
    // MARK : IBAction Methods
    
    @IBAction func toggleContactDisplayType(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else { return }
        
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        if selectedIndex == defaultContatIndex {
            self.contactType = .list
            self.contactGroupView.isHidden = true
            self.contactListView.isHidden = false
        } else {
            self.contactType = .group
            self.contactGroupView.isHidden = false
            self.contactListView.isHidden = true
        }
    }
}
