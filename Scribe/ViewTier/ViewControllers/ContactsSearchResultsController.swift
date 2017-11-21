//
//  ContactsSearchResultsController.swift
//  Scribe
//
//  Created by Mikael Son on 11/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public protocol ContactsSearchResultsControllerDelegate: class {
    func fetchContactDataSource() -> [ContactVOM]
    func didSelectFromSearchResult(with cell: ContactCell)
}

public class ContactsSearchResultsController: UITableViewController, UISearchResultsUpdating {

    var contactDataSource = [ContactVOM]()
    var filteredDataSource = [ContactVOM]()
    
    var delegate: ContactsSearchResultsControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.fetchContacts()
    }

    // MARK: - Helper Functions
    
    private func commonInit() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 74
//        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handleScroll(gestureRecognizer:)))
    }
    
    private func fetchContacts() {
        if let delegate = self.delegate {
            self.contactDataSource = delegate.fetchContactDataSource()
        }
    }
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        cell.nameLabel.text = model.nameEng
        cell.subNameLabel.text = model.nameKor
    }
    
    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
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
        UITableViewCell.applyScribeCellAttributes(to: cell)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ContactCell {
            self.delegate?.didSelectFromSearchResult(with: cell)
        }
    }

    // MARK: - UISearchResultsUpdating Functions
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentForSearchText(searchText)
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        self.filteredDataSource = self.contactDataSource.filter({ (model) -> Bool in
            return model.nameEng.lowercased().contains(searchText.lowercased()) ||
                model.nameKor.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("haha")
    }
}
