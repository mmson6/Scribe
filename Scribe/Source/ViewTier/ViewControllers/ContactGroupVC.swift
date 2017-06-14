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
    
    // MARK: SPRCollectionViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactGroupCommand()
        cmd.onCompletion(do: callback)
        cmd.execute()
    }
    
    override func renderCell(inCollectionView collectionView: UICollectionView, withModel model: Any, at indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactGroupCell", for: indexPath) as? ContactGroupCell,
            let groupModel = model as? ContactGroupVOM
        else {
            return UICollectionViewCell()
        }
        
        
        self.populate(cell, with: groupModel)
        
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
    
    private func populate(_ cell: ContactGroupCell, with model:ContactGroupVOM) {
        cell.lookupKey = model.type
        cell.commonInit()
        print(model.type)
        switch model.type {
        case .Fathers:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup1
            cell.groupNameLabel.textColor = UIColor.scribeColorGray
            cell.groupNameLabel.text = GroupName.Fathers_Group
            break
        case .YoungAdults:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup2
            cell.groupNameLabel.textColor = UIColor.scribeColorGray
            cell.groupNameLabel.text = GroupName.YA_Group
//            cell.cellBackgroundImage.image = UIImage(named: "YA_Group_Image")
            break
        case .Mothers:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup3
            cell.groupNameLabel.textColor = UIColor.scribeColorDarkGray
            cell.groupNameLabel.text = GroupName.Mothers_Group
//            cell.cellBackgroundImage.image = UIImage(named: "Mothers_Group_Image")
            break
        case .Teachers:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup4
            cell.groupNameLabel.textColor = UIColor.scribeColorGray
            cell.groupNameLabel.text = GroupName.Teachers_Group
            break
        case .Choir:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup5
            cell.groupNameLabel.textColor = UIColor.scribeColorGray
            cell.groupNameLabel.text = GroupName.Choir_Group
            break
        }
        
        cell.countLabel.text = "7"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? GroupContactListVC,
            let cell = sender as? ContactGroupCell
        else {
            return
        }
        
        vc.lookupKey = cell.lookupKey
    }
}
