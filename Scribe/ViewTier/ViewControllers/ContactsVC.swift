//
//  ContactsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/20/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ContactsSearchResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var contactDataSource = [ContactVOM]()
    var filteredDataSource = [ContactVOM]()
    var searchController = UISearchController()
    var contactsNeedUpdate = false
    
    // Store all firebase database reference obserbers to remove at deinit later
    var fbObserverRefs = [DatabaseReference]()
    
    // MARK: UIViewController Functions
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initObservers()
    }
    
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
    }
    
    private func commonInit() {
        self.title = "Contacts"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    @objc func handleScroll(gestureRecognizer: UIPanGestureRecognizer) {
        self.searchController.searchBar.resignFirstResponder()
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
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.searchBar.isFirstResponder && self.searchController.searchBar.text != "" {
            return self.filteredDataSource.count
        }
        return self.contactDataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.searchController.searchBar.text != "" {
            UIView.animate(withDuration: 0.5) {
                self.searchController.searchBar.text = ""
                self.searchController.searchBar.resignFirstResponder()
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
        let storyboard = UIStoryboard(name: "Contacts", bundle: nil)
        if let searchResultsController = storyboard.instantiateViewController(withIdentifier: "ContactsSearchResultsController") as? ContactsSearchResultsController {
            self.searchController = UISearchController(searchResultsController: searchResultsController)
            searchResultsController.delegate = self
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.searchController.hidesNavigationBarDuringPresentation = true
            self.definesPresentationContext = true
            self.searchController.searchBar.placeholder = "Search by name"
            self.searchController.searchBar.tintColor = UIColor.scribeDesignTwoDarkBlue
            self.searchController.searchResultsUpdater = searchResultsController
        }
    }
    
    // MARK: - ContactsSearchResultsControllerDelegate Functions
    
    func fetchContactDataSource() -> [ContactVOM] {
        return self.contactDataSource
    }
    
    func didSelectFromSearchResult(with cell: ContactCell) {
        self.performSegue(withIdentifier: "contactsToContactDetail", sender: cell)
    }
    
    // MARK: - Navigation

    @IBAction func unwindToContactsVC(segue: UIStoryboardSegue) {}
    
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
