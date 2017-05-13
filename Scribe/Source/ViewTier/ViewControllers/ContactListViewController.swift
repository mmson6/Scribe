//
//  ContactListViewController.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public struct EmptyODSIndicator {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

public class EmptyContacts: ObjectDataSource<Any> {
    
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

public class ContactListViewController: SPRTableViewController {

    // MARK : SPRTableViewController
    public override func viewDidLoad() {
    }
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
//        let cmd = FetchContactsCommand()
//        cmd.onCompletion(do: callback)
//        cmd.execute()
        let ods = EmptyContacts()
        
        callback(.success(ods))
    }
    
    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell,
            let contactModel = model as? ContactVO
        else {
            return UITableViewCell()
        }
        
        print(model)
        cell.populateCell(with: contactModel)
        
        return cell
    }
    
//    override func renderCell(inTableView tableView: UITableView, withError error: Error, at indexPath: IndexPath) -> UITableViewCell {
//
//    }
}
