//
//  ContactListVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


public class ContactListVC: SPRTableViewController {

    private var contactDatSource: [DataSnapshot] = []
    
    // MARK : SPRTableViewController
    
    public override func viewDidLoad() {
        self.initObservers()
    }
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactsCommand()
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
            let engName = json["name_eng"] as? String
            let korName = json["name_kor"] as? String
            contactsNameRef.child(snap.key).setValue(
                ["name_eng": engName,
                 "name_kor": korName])
        })
        
        contactRef.observe(.childRemoved, with: { snap in
            let contactsNameRef = ref.child("contacts_name")
            contactsNameRef.child(snap.key).removeValue()
        })
    }
}
