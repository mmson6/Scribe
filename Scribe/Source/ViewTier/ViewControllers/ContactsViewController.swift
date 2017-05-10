//
//  ContactsViewController.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public class ContactsViewController: SPRTableViewController {

    // MARK : SPRTableViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactsCommand()
        cmd.onCompletion(do: callback)
        cmd.execute()
    }
    
    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = "mike"
        return cell
    }
    
//    override func renderCell(inTableView tableView: UITableView, withError error: Error, at indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
}
