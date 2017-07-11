//
//  ContactListVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


public class ContactListVC: UITableViewController {
    
    public var contactDataSource = [ContactVOM]()
    private var filteredDataSource = [ContactVOM]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK : SPRTableViewController
    
    public override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.initializeSearchController()
        self.fetchContacts()
    }
    
    private func fetchContacts() {
        if self.contactDataSource.count <= 0 {
            self.loadObjectDataSource()
        }
    }
    private func loadObjectDataSource() {
        let cmd = FetchContactsCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.contactDataSource = array
            case .failure(let error):
                NSLog("error occurred: \(error)")
            }
        }
        cmd.execute()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredDataSource.count > 0 {
            return self.filteredDataSource.count
        } else {
            return self.contactDataSource.count
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        return cell
    }
//    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
//        
//        guard
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell,
//            let contactModel = model as? ContactVOM
//        else {
//            return UITableViewCell()
//        }
//        
//        self.populate(cell, with: contactModel)
//        
//        return cell
//    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 12, options: .curveLinear, animations: {
            cell?.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Helper Functions
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        cell.nameLabel.text = model.nameEng
        cell.subNameLabel.text = model.nameKor
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? ContactDetailVC,
            let cell = sender as? ContactCell
        else {
            return
        }
        
        vc.lookupKey = cell.lookupKey
        vc.parentVC = "ContactListVC"
    }
    
    // MARK: Lifecycle Functions
    
    @IBAction func unwindToContactListView(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Search Controller Functions
    
    private func initializeSearchController() {
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
//        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.searchBar.placeholder = "Search here..."
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        
        // Setup the Scope Bar
//        self.searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        tableView.tableHeaderView = self.searchController.searchBar
    }
}

extension ContactListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        <#code#>
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//
//        // Filter the data array and get only those countries that match the search text.
//        self
//        filteredArray = dataArray.filter({ (country) -> Bool in
//            let countryText: NSString = country
//            
//            return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
//        })
//        
//        // Reload the tableview.
//        tblSearchResults.reloadData()
//        
//        
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
