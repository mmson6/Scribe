//
//  ContactDetailViewController.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public class ContactDetailViewController: SPRTableViewController {
    
    // MARK : SPRTableViewController
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactDetailCommand()
        cmd.onCompletion(do: callback)
        cmd.execute()
//        let cmd = FetchContactsCommand()
//        cmd.onCompletion(do: callback)
//        cmd.execute()
    }
    
    override public func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
//            ContactImageCell
            let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactImageCell", for: indexPath)
            return contactCell
        default:
            let contactCell: ContactInfoCell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoCell", for: indexPath) as! ContactInfoCell
            
            for (key, value) in model.enu {
                contactCell.initializeCellWith(subTitle: key, andInfo: value)
            }
//            if let jsonModel = model as? [String: String] {
//                for (key, value) in jsonModel {
//                    contactCell.initializeCellWith(subTitle: key, andInfo: value)
//                }
//            }
            
            return contactCell
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
