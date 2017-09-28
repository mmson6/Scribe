//
//  ReadingPlannerSettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 9/25/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ReadingPlannerSettingsVC: UITableViewController {

    var activityDataSource = [PlannerActivityVOM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
        self.fetchData()
    }

    // MARK: Helpter FUnctions
    
    private func commonInit() {
        self.tableView.separatorStyle = .none
    }
    
    private func fetchData() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchBiblePlannerActivities()
        }
    }
    
    private func fetchBiblePlannerActivities() {
        let cmd = FetchPlannerMarkActivitiesCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.activityDataSource = array
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activityDataSource.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingPlannerSettingsHeaderCell", for: indexPath) as? ReadingPlannerSettingsHeaderCell
            else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReadActivityCell", for: indexPath) as? ReadActivityCell
            else {
                return UITableViewCell()
            }
            
            // Present cells in descending order - lastest acitivity top
            let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 1)]
            if model.isConsecutive {
                cell.bookLabel.text = "\(model.bookName) Ch. \(model.min + 1) ~ \(model.max + 1)"
            } else {
                cell.bookLabel.text = "\(model.bookName) Ch. \(model.min + 1)"
            }
            
            return cell
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
