//
//  ManageContactInfoVC.swift
//  Scribe
//
//  Created by Mikael Son on 8/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ManageContactInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    let customSearchBar = ContactSearchBar()
    var filteredDataSource = [ContactVOM]()
    var contactDataSource = [ContactVOM]()
    @IBOutlet var tableView: UITableView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.initializeSearchController()
        self.checkForContactsUpdate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 74
        
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handleScroll(gestureRecognizer:)))
    }
    
    private func checkForContactsUpdate() {
        let cmd = FetchContactsVersionCommand()
        cmd.onCompletion { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let ver):
                strongSelf.fetchContactDataSource(with: ver)
            case .failure:
                strongSelf.fetchContactDataSource(with: 0)
            }
        }
        cmd.execute()
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
    
    // MARK: UITableView Delegate Functions
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
        
        guard
            let vc = segue.destination as? EditContactInfoVC,
            let cell = sender as? ContactCell
        else {
            return
        }
        
        vc.lookupKey = cell.lookupKey
    }
    
    @IBAction func unwindToManageContactInfoVC(segue: UIStoryboardSegue) {
        
    }
}
