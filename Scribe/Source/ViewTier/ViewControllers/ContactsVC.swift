//
//  ContactsVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/20/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var contactDataSource = [ContactVOM]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.fetchContactDataSource()
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor.scribePintNavBarColor
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 74
    }
    
    private func fetchContactDataSource(with ver: Int64 = 0) {
        
        let ctd: [[String: Any]] = 	[
            [
                "name_kor": "안명숙",
                "name_eng": "Myungsook Ahn",
                "phone": "8476368041",
                "address": "10373 Dearlove Road #3E, Glenview, IL 60025",
                "group": "Mothers",
                "teacher": false,
                "choir": false,
                "translator": false,
                "district": "11"
            ],
            [
                "name_kor": "백중현",
                "name_eng": "John Baek",
                "phone": "6309949989",
                "address": "23801 Tallgrass Drive, Plainfield, IL 60658",
                "group": "Fathers",
                "teacher": false,
                "choir": false,
                "translator": false,
                "district": "11"
            ],
            [
                "name_kor": "김경민",
                "name_eng": "Ace Bowling",
                "phone": "8478262343",
                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
                "group": "Young Adults",
                "teacher": true,
                "choir": false,
                "translator": false,
                "district": "31"
            ],
            [
                "name_kor": "",
                "name_eng": "Ryan Bowling",
                "phone": "8478264755",
                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
                "group": "Young Adults",
                "teacher": true,
                "choir": false,
                "translator": false,
                "district": "31"
            ],
            [
                "name_kor": "변영희",
                "name_eng": "Younghee Byun",
                "phone": "2246228329",
                "address": "1509 Summerhill Lane, Cary IL 60013",
                "group": "Mothers",
                "teacher": false,
                "choir": false,
                "translator": false,
                "district": "21"
            ],
            [
                "name_kor": "장혜숙",
                "name_eng": "Hazel Chang",
                "phone": "6308809345",
                "address": "2426 North Kennicott Drive #2B, Arlington Heights, IL 60004",
                "group": "Mothers",
                "teacher": false,
                "choir": false,
                "translator": false,
                "district": "31"
            ],
            [
                "name_kor": "지시현",
                "name_eng": "Anna Chee",
                "phone": "2244028225",
                "address": "813 West Springfied Avenue APT 101, Urbana, IL 61801",
                "group": "Young Adults",
                "teacher": false,
                "choir": false,
                "translator": false,
                "district": "21"
            ]
        ]
        
        let models = ctd.enumerated().flatMap({ (index, jsonObj) -> ContactVOM? in
            let index64 = Int64(index)
            let dm = ContactDM(from: jsonObj, with: index64)
            let model = ContactVOM(model: dm)
            return model
        })
        
        self.contactDataSource = models
        self.tableView.reloadData()
//        
//        let cmd = FetchContactsCommand()
//        cmd.onCompletion { result in
//            switch result {
//            case .success(let array):
//                self.contactDataSource = array
//                self.tableView.reloadData()
//            case .failure(let error):
//                NSLog("Error: \(error)")
//            }
//        }
//        cmd.execute()
    }
    
    private func populate(_ cell: ContactCell, with model: ContactVOM) {
        cell.commonInit()
        cell.lookupKey = model.id
        cell.nameLabel.text = model.nameEng
        cell.subNameLabel.text = model.nameKor
    }

    // MARK: IBAction Functions
    
    @IBAction func groupButtonTapped(_ sender: UIBarButtonItem) {
    }
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contactDataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contactModel = self.contactDataSource[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell
        else {
            return UITableViewCell()
        }
        
        self.populate(cell, with: contactModel)

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    @IBAction func unwindToContactsVC(segue: UIStoryboardSegue) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "contactsToContactGroups" {
            guard
                let vc = segue.destination as? ContactGroupsVC
            else {
                return
            }
            
            vc.contactDataSource = self.contactDataSource
        } else if identifier == "contactsToContactDetail" {
            guard
                let vc = segue.destination as? ContactDetailVC,
                let cell = sender as? ContactCell
                else {
                    return
            }
            
            vc.lookupKey = cell.lookupKey
            vc.parentVC = "ContactsVC"
            vc.animator.operationPresenting = true
        }
    }
}
