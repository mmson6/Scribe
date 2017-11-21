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
    
    let store = UserDefaultsStore()
    
    // MARK : SPRTableViewController
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.setNavigationBarTitle()
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
        
        self.populate(cell, with: contactModel)
        UITableViewCell.applyScribeCellAttributes(to: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Lifecycle Functions
    
    @IBAction func unwindToGroupContactListView(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: Helper Functions
    
    private func setNavigationBarTitle() {
        guard let group = self.lookupKey as? ContactGroups else { return }
        
        switch group {
        case .Choir:
            self.title = GroupName.Choir_Group
        case .ChurchSchool:
            self.title = GroupName.Church_School
        case .Fathers:
            self.title = GroupName.Fathers_Group
        case .Mothers:
            self.title = GroupName.Mothers_Group
        case .Teachers:
            self.title = GroupName.Teachers_Group
        case .Translators:
            self.title = GroupName.Translators_Group
        case .YoungAdults:
            self.title = GroupName.YA_Group
        }
        
    }
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        
        if let mainLang = self.store.loadMainLanguage() {
            switch mainLang {
            case "Eng_US":
                if model.nameEng == "" {
                    cell.nameLabel.text = model.nameKor
                    cell.subNameLabel.isHidden = true
                } else {
                    cell.nameLabel.text = model.nameEng
                    cell.subNameLabel.text = model.nameKor
                }
            case "Kor":
                if model.nameKor == "" {
                    cell.nameLabel.text = model.nameEng
                    cell.subNameLabel.isHidden = true
                } else {
                    cell.nameLabel.text = model.nameKor
                    cell.subNameLabel.text = model.nameEng
                }
            default:
                if model.nameEng == "" {
                    cell.nameLabel.text = model.nameKor
                } else {
                    cell.nameLabel.text = model.nameEng
                    cell.subNameLabel.text = model.nameKor
                }
            }
        } else {
            if model.nameEng == "" {
                cell.nameLabel.text = model.nameKor
            } else {
                cell.nameLabel.text = model.nameEng
                cell.subNameLabel.text = model.nameKor
            }
        }
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
        
        
//        if let destinationViewController = segue.destination as? ContactDetailVC {
//            destinationViewController.transitioningDelegate = self
//            destinationViewController.interactor = interactor
//        }
    }
}
