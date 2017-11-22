//
//  ContactGroupVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase


fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
fileprivate let itemsPerRow: CGFloat = 2


class ContactGroupVC: SPRCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var contactDataSource: [ContactVOM]?
    
    // MARK: SPRCollectionViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactGroupCommand()
//        cmd.onCompletion(do: callback)
        cmd.execute()
    }
    
    override func renderCell(inCollectionView collectionView: UICollectionView, withModel model: Any, at indexPath: IndexPath) -> UICollectionViewCell {
        
        var contacts: [ContactVOM] = []
        if let dataSource = self.contactDataSource {
            contacts = dataSource
        }
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactGroupCell", for: indexPath) as? ContactGroupCell,
            let groupModel = model as? ContactGroupVOM
        else {
            return UICollectionViewCell()
        }
                
        self.populate(cell, with: groupModel, and: contacts)
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    // MARK: Helper Functions
    
    private func populate(_ cell: ContactGroupCell, with model:ContactGroupVOM, and contacts:[ContactVOM]) {
        cell.lookupKey = model.type
        cell.commonInit()
        print(model.type)
        switch model.type {
        case .Fathers:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.green
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Fathers_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                if vom.group != GroupName.Fathers_Group {
                    return false
                } else {
                    return true
                }
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .YoungAdults:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.red
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.YA_Group
//            cell.cellBackgroundImage.image = UIImage(named: "YA_Group_Image")
            
            let filtered = contacts.filter({ (vom) -> Bool in
                if vom.group != GroupName.YA_Group {
                    return false
                } else {
                    return true
                }
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .Mothers:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.yellow
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Mothers_Group
//            cell.cellBackgroundImage.image = UIImage(named: "Mothers_Group_Image")
            
            let filtered = contacts.filter({ (vom) -> Bool in
                if vom.group != GroupName.Mothers_Group {
                    return false
                } else {
                    return true
                }
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .Teachers:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.blueGreen
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Teachers_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                let result = vom.teacher ? true : false
                return result
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .Choir:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.purple
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Choir_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                let result = vom.choir ? true : false
                return result
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .ChurchSchool:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.blue
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Church_School
            
            let filtered = contacts.filter({ (vom) -> Bool in
                if vom.group != GroupName.Church_School {
                    return false
                } else {
                    return true
                }
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .Translators:
            cell.cellBackgroundImage.backgroundColor = UIColor.Scribe.ContactGroup.orange
            cell.groupNameLabel.textColor = UIColor.Scribe.gray
            cell.groupNameLabel.text = GroupName.Translators_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                let result = vom.translator ? true : false
                return result
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? GroupContactListVC,
            let cell = sender as? ContactGroupCell
        else {
            return
        }
        
        vc.contactDataSource = cell.contacts
        vc.lookupKey = cell.lookupKey
    }
}
