//
//  ContactGroupsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/20/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
fileprivate let itemsPerRow: CGFloat = 2


class ContactGroupsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var groupDataSource = [ContactGroupVOM]()
    var contactDataSource = [ContactVOM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonInit()
        self.fetchGroupDataSource()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let groupModel = self.groupDataSource[indexPath.row]
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactGroupCell", for: indexPath) as? ContactGroupCell
            else {
                return UICollectionViewCell()
        }
        
        self.populate(cell, with: groupModel, and: self.contactDataSource)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func fetchGroupDataSource() {
        let cmd = FetchContactGroupCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.groupDataSource = array
                self.collectionView.reloadData()
            case .failure(_):
                //                callback(.failure(error))
                break
            }
        }
        cmd.execute()
    }

    private func populate(_ cell: ContactGroupCell, with model:ContactGroupVOM, and contacts:[ContactVOM]) {
        cell.lookupKey = model.type
        cell.commonInit()
        print(model.type)
        switch model.type {
        case .Fathers:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup1
            cell.groupNameLabel.textColor = UIColor.scribeGray
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
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup5
            cell.groupNameLabel.textColor = UIColor.scribeGray
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
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup4
            cell.groupNameLabel.textColor = UIColor.scribeGray
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
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup2
            cell.groupNameLabel.textColor = UIColor.scribeGray
            cell.groupNameLabel.text = GroupName.Teachers_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                let result = vom.teacher ? true : false
                return result
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .Choir:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup6
            cell.groupNameLabel.textColor = UIColor.scribeGray
            cell.groupNameLabel.text = GroupName.Choir_Group
            
            let filtered = contacts.filter({ (vom) -> Bool in
                let result = vom.choir ? true : false
                return result
            })
            cell.countLabel.text = "\(filtered.count)"
            cell.contacts = filtered
            break
        case .ChurchSchool:
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup3
            cell.groupNameLabel.textColor = UIColor.scribeGray
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
            cell.cellBackgroundImage.backgroundColor = UIColor.scribeColorGroup7
            cell.groupNameLabel.textColor = UIColor.scribeGray
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

    // MARK: IBAction Functions
    
    @IBAction func groupButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToContactsVC", sender: nil)
    }
    
    // MARK: Navigation Functions
    
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
