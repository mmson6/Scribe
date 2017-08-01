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
        let contactVerRef = ref.child("contacts_ver")
        
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
        
//        let ctd: [[String: Any]] = 	[
//            [
//                "name_kor": "안명숙",
//                "name_eng": "Myungsook Ahn",
//                "phone": "8476368041",
//                "address": "10373 Dearlove Road #3E, Glenview, IL 60025",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "11"
//            ],
//            [
//                "name_kor": "백중현",
//                "name_eng": "John Baek",
//                "phone": "6309949989",
//                "address": "23801 Tallgrass Drive, Plainfield, IL 60658",
//                "group": "Fathers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "11"
//            ],
//            [
//                "name_kor": "김경민",
//                "name_eng": "Ace Bowling",
//                "phone": "8478262343",
//                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
//                "group": "Young Adults",
//                "teacher": true,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "",
//                "name_eng": "Ryan Bowling",
//                "phone": "8478264755",
//                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
//                "group": "Young Adults",
//                "teacher": true,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "변영희",
//                "name_eng": "Younghee Byun",
//                "phone": "2246228329",
//                "address": "1509 Summerhill Lane, Cary IL 60013",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "21"
//            ],
//            [
//                "name_kor": "장혜숙",
//                "name_eng": "Hazel Chang",
//                "phone": "6308809345",
//                "address": "2426 North Kennicott Drive #2B, Arlington Heights, IL 60004",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "지시현",
//                "name_eng": "Anna Chee",
//                "phone": "2244028225",
//                "address": "813 West Springfied Avenue APT 101, Urbana, IL 61801",
//                "group": "Young Adults",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "21"
//            ]
//        ]
//        
//        let models = ctd.enumerated().flatMap({ (index, jsonObj) -> ContactVOM? in
//            let index64 = Int64(index)
//            let dm = ContactDM(from: jsonObj, with: index64)
//            let model = ContactVOM(model: dm)
//            return model
//        })
//        
//        self.contactDataSource = models
//        self.tableView.reloadData()
//
        
//            let test = snap.value as? JSONObject
//            guard
//                let object = snap.value as? JSONObject,
//                let ver = object[0]["contacts_ver"]
//            else {
//                return
//            }
        
        
//        contactVerRef.observe(.childChanged, with: { [weak self] snap in
//            guard let strongSelf = self else { return }
//            
//            guard
//                let ver = snap.value as? Int64
//                else {
//                    return
//            }
//            
//            if strongSelf.store.contactsNeedUpdate(ver) {
//                strongSelf.fetchContactDataSource(with: ver)
//                strongSelf.store.saveContactsVer(ver)
//            }
//        })
        
//        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
//        let contactRef = ref.child("contacts")
//        let query = contactRef.queryOrderedByKey().queryEqual(toValue: "\(request.id)")
//        
//        query.observeSingleEvent(of: .value, with: { snap in
//            if let dataSnap = snap.children.allObjects as? [DataSnapshot] {
//                guard let json = dataSnap.last else { return }
//                if let jsonData = json.value as? JSONObject {
//                    let dm = ContactInfoDM(from: jsonData)
//                    //                    let dms = jsonData.flatMap({ (key, value) -> ContactInfoDM? in
//                    //                        let dm = ContactInfoDM(from: ["label": key, "value": value])
//                    //                        return dm
//                    //                    })
//                    callback(.success(dm))
//                }
//            }
//        })
        
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

    private func applyCellSettings(to cell: ContactCell) {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 237, green: 241, blue: 244)
        cell.selectedBackgroundView = view
    }
    
    // MARK: Firebase Related Functions
    
    private func initFirebaseObservers() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactVerRef = ref.child("contacts_ver")
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
        
        
        contactVerRef.observe(.childChanged, with: { [weak self] snap in
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
        
        
        self.applyCellSettings(to: cell)
        
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
