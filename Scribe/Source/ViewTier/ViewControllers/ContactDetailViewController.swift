//
//  ContactDetailViewController.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import Firebase

public class EmptyContactDetail: ObjectDataSource<Any> {
    
    var objArray = [ContactVO]()
    
    override init() {
        let obj1 = ContactVO(name: "Mike")
        let obj2 = ContactVO(name: "Daniel")
        let obj3 = ContactVO(name: "Roy")
        let obj4 = ContactVO(name: "Paul")
        let obj5 = ContactVO(name: "Andrew")
        objArray.append(obj1)
        objArray.append(obj2)
        objArray.append(obj3)
        objArray.append(obj4)
        objArray.append(obj5)
    }
    
    public override func numberOfObjects(inSection section: Int) -> Int {
        return objArray.count
    }
    
    public override func numberOfSections() -> Int {
        return 1
    }
    
    public override func object(at indexPath: IndexPath) throws -> Any {
        //        let obj1 = EmptyODSIndicator(name: "Mike")
        //        let obj2 = EmptyODSIndicator(name: "Daniel")
        //        let obj3 = EmptyODSIndicator(name: "Roy")
        //        let obj4 = EmptyODSIndicator(name: "Paul")
        //        let obj5 = EmptyODSIndicator(name: "Andrew")
        //        objArray.append(obj1)
        //        objArray.append(obj2)
        //        objArray.append(obj3)
        //        objArray.append(obj4)
        //        objArray.append(obj5)
        //        let obj = [EmptyODSIndicator]()
        print(indexPath.row)
        return objArray[indexPath.row]
    }
}

public class ContactDetailViewController: SPRTableViewController {
    
//    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    public override func viewDidLoad() {
        self.commonInit()
    }
    
    private func commonInit() {
        var myRootRef = Firebase(url: "https://scribe-4ed24.firebaseio.com/Core/")
        
//        myRootRef?.setValue("Do you have data? You'll love Firebase.")
        
//        myRootRef.observe
        
        myRootRef?.child(byAppendingPath: "Contacts/Global_Ver").observeSingleEvent(of: .value, with: { snapshot in
            if let snapshot = snapshot {
                print("\(snapshot)")
            }
            
            let value = snapshot?.value as? NSDictionary
            print("\(value)")
        })
//        myRootRef?.observe(.value, with: { snapshot in
//            if let snapshot = snapshot {
//                print("\(snapshot.key) -> \(snapshot.value)")
//            }            
//        })
        
    }
    
    // MARK : SPRTableViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
//        let cmd = FetchContactDetailCommand()
//        cmd.onCompletion(do: callback)
//        cmd.execute()
        
        let ods = EmptyContactDetail()
        callback(.success(ods))
//        let cmd = FetchContactsCommand()
//        cmd.onCompletion(do: callback)
//        cmd.execute()
        
    }
    
    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
//            ContactImageCell
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactImageCell", for: indexPath) as? ContactImageCell
            else {
                return UITableViewCell()
            }
            return cell
            
        default:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoCell", for: indexPath) as? ContactInfoCell,
                let contactModel = model as? ContactVO
            else {
                return UITableViewCell()
            }
            cell.populate(with: contactModel)
            
            return cell
        }
        
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == 0 {
            return 220;
        } else {
            return 60
        }
    }
}
