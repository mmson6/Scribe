//
//  GroupContactListVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/22/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class GroupContactListVC: SPRTableViewController {
    
    public var lookupKey: Any?
    
    // MARK : SPRTableViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
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
        
        vc.lookupKey = cell.lookupKey
    }
    
}
