//
//  ContactsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/20/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var contactDataSource = [ContactVOM]()
    var filteredDataSource = [ContactVOM]()
    let customSearchBar = ContactSearchBar()
    var contactsNeedUpdate = false
    
    // Store all firebase database reference obserbers to remove at deinit later
    var fbObserverRefs = [DatabaseReference]()
    
    // MARK: UIViewController Functions
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.initializeSearchController()
        self.checkForContactsUpdate()
    }
    
    deinit {
        self.fbObserverRefs.forEach({ $0.removeAllObservers() })
    }
    
    // MARK: Helper Functions
    private func initObservers() {
        self.initFirebaseObservers()
//        
//        NotificationCenter.default.addObserver(
//            forName: mainLanguageChanged,
//            object: nil,
//            queue: nil
//        ) { [weak self] _ in
//            DispatchQueue.main.async {
//                guard let strongSelf = self else { return }
//                strongSelf.tableView.reloadData()
//            }
//        }

    }
    
    private func commonInit() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 74
        
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handleScroll(gestureRecognizer:)))
    }
    
    private func checkForContactsUpdate() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactVerRef = ref.child(contactsChicago).child("contactsVer")
        
        contactVerRef.observeSingleEvent(of: .value, with: { [weak self] (snap) in
            guard let strongSelf = self else { return }
            
            guard
                let object = snap.value as? JSONObject,
                let ver = object["version"] as? Int64
                else {
                    return
            }
            //            let ver = object["version"] as? Int64
            
            strongSelf.fetchContactDataSource(with: ver)
        })
    }
    
    private func fetchContactDataSource(with ver: Int64 = 0) {
        let cmd = FetchContactsCommand()
        cmd.contactsVer = ver
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.contactDataSource = array
                self.tableView.reloadData()
            case .failure(let error):
                NSLog("Error: \(error)")
            }
        }
        cmd.execute()
    }
    
    func handleScroll(gestureRecognizer: UIPanGestureRecognizer) {
        self.customSearchBar.resignFirstResponder()
    }
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        cell.nameLabel.text = model.nameEng
        cell.subNameLabel.text = model.nameKor
    }

    // MARK: Firebase Related Functions
    
    private func initFirebaseObservers() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactVerRef = ref.child("contacts_ver")
        
        self.fbObserverRefs.append(contactVerRef)
        self.fbObserverRefs.last!.observe(.childChanged, with: { [weak self] snap in
            guard let strongSelf = self else { return }
            
            guard
                let ver = snap.value as? Int64
                else {
                    return
            }
            
            let store = UserDefaultsStore()
            if store.contactsNeedUpdate(ver) {
                strongSelf.fetchContactDataSource(with: ver)
                //                store.saveContactsVer(ver)
            }
        })
        
//        
//        contactRef.observe(.childAdded, with: { snap in
//            guard
//                let json = snap.value as? JSONObject
//                else {
//                    return
//            }
//            
//            let group = json["group"] as? String
//            let teacher = json["teacher"] as? Bool
//            let choir = json["choir"] as? Bool
//            let translator = json["translator"] as? Bool
//            let engName = json["name_eng"] as? String
//            let korName = json["name_kor"] as? String
//            
//            let contactsNameRef = ref.child("contacts_name")
//            contactsNameRef.child(snap.key).setValue(
//                ["name_eng": engName as Any,
//                 "name_kor": korName as Any,
//                 "group": group as Any,
//                 "teacher": teacher as Any,
//                 "choir": choir as Any,
//                 "translator": translator as Any
//                ])
//            
//        })
//        
//        contactRef.observe(.childRemoved, with: { snap in
//            let contactsNameRef = ref.child("contacts_name")
//            contactsNameRef.child(snap.key).removeValue()
//        })
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.customSearchBar.isFirstResponder && self.customSearchBar.text != "" {
            return self.filteredDataSource.count
        }
        return self.contactDataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.customSearchBar.text != "" {
            UIView.animate(withDuration: 0.5) {
                self.customSearchBar.text = ""
                self.customSearchBar.resignFirstResponder()
                self.filteredDataSource = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contactModel: ContactVOM
        if self.filteredDataSource.count > 0 {
            contactModel = self.filteredDataSource[indexPath.row]
        } else {
            contactModel = self.contactDataSource[indexPath.row]
        }
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell
        else {
            return UITableViewCell()
        }
        
        self.populate(cell, with: contactModel)
        UITableViewCell.applyScribeCellAttributes(to: cell)
        
        return cell
    }
    
    // MARK: Search Controller Functions
    
    private func initializeSearchController() {
        self.customSearchBar.delegate = self
        self.customSearchBar.setSearchImageColor(color: UIColor.scribeDesignTwoLightBlue)
        self.customSearchBar.setTextFieldClearButtonColor(color: UIColor.scribeDesignTwoLightBlue)
        self.customSearchBar.setPlaceholderTextColor(color: UIColor.scribeDesignTwoLightBlue)
        self.customSearchBar.setTextColor(color: UIColor.scribeDesignTwoDarkBlue)
        self.customSearchBar.tintColor = UIColor.scribeDesignTwoLightBlue
        
        self.customSearchBar.sizeToFit()
        self.navigationItem.titleView = customSearchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredDataSource = self.contactDataSource.filter({ (model) -> Bool in
            return model.nameEng.lowercased().contains(searchText.lowercased()) ||
                model.nameKor.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    @IBAction func unwindToContactsVC(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "contactsToContactGroups" {
            guard
                let vc = segue.destination as? ContactGroupsVC
            else {
                return
            }
            
            vc.contactDataSource = self.contactDataSource
        } else if identifier == "contactsToContactDetail" {
            guard
                let vc = segue.destination as? ContactDetailVC,
                let cell = sender as? ContactCell
                else {
                    return
            }
            
            vc.lookupKey = cell.lookupKey
            vc.parentVC = "ContactsVC"
//            vc.animator.operationPresenting = true
        }
    }
}
