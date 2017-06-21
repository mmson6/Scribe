//
//  ContactsCoordinatorVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FontAwesomeKit
import FirebaseDatabase


public let defaultContatIndex = 0

public enum ContactType {
    case list
    case group
}

class ContactsCoordinatorVC: UIViewController {
    public var contactDataSource: [ContactVOM]?
    internal var contactType: ContactType = .list
    
    @IBOutlet weak var contactListView: UIView!
    @IBOutlet weak var contactGroupView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    
    
    // MARK: UIViewController 
    
    
    override func viewDidLoad() {
        self.initializeNavBarItems()
        self.initializeTabBarItems()
        self.initObservers()
//        self.fetchContactDataSource()
    }
    
    // MARK: Private Functions
    
    private func initializeNavBarItems() {
        self.groupButton.setTitle("\u{f009}", for: .normal)
//        self.groupButton.setTitleColor(UIColor.scribePintInfoTitleColor, for: .normal)
    }
    
    private func initializeTabBarItems() {
        let settingsIcon = FAKIonIcons.iosSettingsIcon(withSize: 30)
        let contactIcon = FAKIonIcons.iosContactIcon(withSize: 30)
        if let tabBarItems = self.tabBarController?.tabBar.items {
            tabBarItems[0].image = contactIcon?.image(with: CGSize(width: 30, height: 30))
            tabBarItems[1].image = settingsIcon?.image(with: CGSize(width: 30, height: 30))
        }
    }
    
    private func fetchContactDataSource() {
        let cmd = FetchContactsCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
//                callback(.success(array))
                break
            case .failure(let error):
//                callback(.failure(error))
                break
            }
        }
        cmd.execute()
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
            self.contactType = .list
            self.contactGroupView.isHidden = true
            self.contactListView.isHidden = false
            
        } else {
            self.contactType = .group
            
            self.contactGroupView.isHidden = false
            self.contactListView.isHidden = true
        }
    }
    
    // MARK: Firebase Related Functions
    
    private func initObservers() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactRef = ref.child("contacts")
        
        contactRef.observe(.childAdded, with: { snap in
            guard
                let json = snap.value as? JSONObject
                else {
                    return
            }
            
            let contactsNameRef = ref.child("contacts_name")
            let group = json["group"] as? String
            let teacher = json["teacher"] as? Bool
            let choir = json["choir"] as? Bool
            let translator = json["translator"] as? Bool
            let engName = json["name_eng"] as? String
            let korName = json["name_kor"] as? String
            contactsNameRef.child(snap.key).setValue(
                ["name_eng": engName as Any,
                 "name_kor": korName as Any,
                 "group": group as Any,
                 "teacher": teacher as Any,
                 "choir": choir as Any,
                 "translator": translator as Any
                ])
            
        })
        
        contactRef.observe(.childRemoved, with: { snap in
            let contactsNameRef = ref.child("contacts_name")
            contactsNameRef.child(snap.key).removeValue()
        })
    }
    
    // MARK: Helper Function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coordinatorToContactList" {
            guard
                let vc = segue.destination as? ContactListVC
                else {
                    return
            }
            
            vc.contactDataSource = self.contactDataSource
        }
        else if segue.identifier == "coordinatorToContactGroup" {
            guard
                let vc = segue.destination as? ContactGroupVC
                else {
                    return
            }
            
            vc.contactDataSource = self.contactDataSource
        }
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
