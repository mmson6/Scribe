//
//  GroupContactListVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/22/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class GroupContactListVC: SPRTableViewController {
    
    public var contactDataSource: [ContactVOM]?
    public var lookupKey: Any?
    
    // MARK : SPRTableViewController
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        
        if let contacts = self.contactDataSource {
            if contacts.count > 0 {
                let ods = ArrayObjectDataSource<Any>(objects: contacts)
                callback(.success(ods))
            }
        } else {
            let cmd = FetchGroupContactsCommand()
            cmd.lookupKey = self.lookupKey
            cmd.onCompletion { result in
                switch result {
                case .success(let array):
                    callback(.success(array))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
            cmd.execute()
        }
    }
    
    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell,
            let contactModel = model as? ContactVOM
            else {
                return UITableViewCell()
        }
        
        print(model)
        self.populate(cell, with: contactModel)
        
        return cell
    }
    
    // MARK: Lifecycle Functions
    
    @IBAction func unwindToGroupContactListView(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: Helper Functions
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        cell.nameLabel.text = model.name
        
    }
    

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? ContactDetailVC,
            let cell = sender as? ContactCell
            else {
                return
        }
        
        vc.parentVC = "GroupContactListVC"
        vc.lookupKey = cell.lookupKey
    }
    
}
