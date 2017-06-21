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
    
    public var contactDataSource: [ContactVOM]?
    
    // MARK : SPRTableViewController
    
    public override func viewDidLoad() {
//        self.initObservers()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        let animator = UIDynamicAnimator(referenceView: self.tableView)
        
//        let behav = UIAttachmentBehavior(
//        let elasticityBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior
//        UIDynamicItemBehavior *elasticityBehavior =
//            [[UIDynamicItemBehavior alloc] initWithItems:@[self.redSquare]];
//        elasticityBehavior.elasticity = 0.7f;
    }
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        if let contacts = self.contactDataSource {
            if contacts.count > 0 {
                let ods = ArrayObjectDataSource<Any>(objects: contacts)
                callback(.success(ods))
            }
        } else {
            let cmd = FetchContactsCommand()
            cmd.onCompletion { result in
                switch result {
                case .success(let array):
                    let ods = ArrayObjectDataSource<Any>(objects: array)
                    callback(.success(ods))
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
        
        return cell
    }
//    
//    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.isHidden = true
//        
////        cell.frame = CGRect(x: cell.frame.size.width, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
////        cell.frame = CGRectMake(cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
////        
//        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
//            cell.isHidden = false
////            cell.frame = CGRect(x: 0, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
//        }, completion: nil)
//        
////        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: {
////            cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)
////        }, completion: { finished in
////            
////        })
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
        vc.parentVC = "ContactListVC"
    }
    
    // MARK: Lifecycle Functions
    
    @IBAction func unwindToContactListView(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Firebase Related Functions
//    
//    private func initObservers() {
//        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
//        let contactRef = ref.child("contacts")
//        
//        contactRef.observe(.childAdded, with: { snap in
//            guard
//                let json = snap.value as? JSONObject
//                else {
//                    return
//            }
//            
//            let contactsNameRef = ref.child("contacts_name")
//            let group = json["group"] as? String
//            let teacher = json["teacher"] as? Bool
//            let choir = json["choir"] as? Bool
//            let translator = json["translator"] as? Bool
//            let engName = json["name_eng"] as? String
//            let korName = json["name_kor"] as? String
//            contactsNameRef.child(snap.key).setValue(
//                ["name_eng": engName as Any,
//                 "name_kor": korName as Any,
//                 "group": group as Any,
//                 "teacher": teacher as Any,
//                 "choir": choir as Any,
//                 "translator": translator as Any
//                 ])
//            
//        })
//        
//        contactRef.observe(.childRemoved, with: { snap in
//            let contactsNameRef = ref.child("contacts_name")
//            contactsNameRef.child(snap.key).removeValue()
//        })
//    }
}
