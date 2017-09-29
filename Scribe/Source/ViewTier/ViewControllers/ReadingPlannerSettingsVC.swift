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
    @IBOutlet var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
        self.fetchData()
    }

    // MARK: Helpter FUnctions
    
    private func commonInit() {
        self.tableView.separatorStyle = .none
        
        // Add activity indicator to the view
        self.activityIndicatorView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        self.tableView.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.isHidden = true
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
    
    private func createUndoMarkChaptersAlert(with indexPath: IndexPath) -> UIAlertController? {

        guard
            let cell = tableView.cellForRow(at: indexPath) as? ReadActivityCell,
            let title = cell.bookLabel.text
        else {
            return nil
        }
        let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 1)]

        let alertController = UIAlertController(
            title: title,
            message: UndoMarkChaptersMessage,
            preferredStyle: .alert
        )
        
        let undoAction = UIAlertAction(
            title: "Undo",
            style: .destructive,
            handler: { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.showLoadingIndicator()
                strongSelf.activityDataSource.remove(at: (strongSelf.activityDataSource.count - 1) - (indexPath.row - 1))
                strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                strongSelf.removePastActivity()
                strongSelf.removeBiblePlannerData(with: model)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: { _ in
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(undoAction)
        
        return alertController
    }
    
    private func removePastActivity() {
        let cmd = RemovePlannerMarkActivityCommand()
        cmd.plannerActivityDataSource = self.activityDataSource
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("RemovePlannerMarkActivityCommand returned with success")
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            case .failure:
                break
            }
            self.hideLoadingIndicator()
        }
        cmd.execute()
    }
    
    private func removeBiblePlannerData(with model: PlannerActivityVOM) {
        let cmd = RemoveBiblePlannerDataCommand()
        cmd.plannerActivityData = model
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("removeBiblePlannerData returned with success")
                NotificationCenter.default.post(name: biblePlannerDataUpdated, object: nil)
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func showLoadingIndicator() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Table view data source

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
            
            let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 1)]
            
            cell.activityCountLabel.text = "\(indexPath.row)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm"
            if let date = dateFormatter.date(from: model.time) {
                if Date.compareYears(from: date) > 0 {
                    let years = Date.compareYears(from: date)
                    if years > 1 {
                        cell.timeLabel.text = "\(years) years ago"
                    } else {
                        cell.timeLabel.text = "Last year"
                    }
                } else if Date.compareMonths(from: date) > 0 {
                    let months = Date.compareMonths(from: date)
                    if months > 1 {
                        cell.timeLabel.text = "\(months) months ago"
                    } else {
                        cell.timeLabel.text = "Last month"
                    }
                } else if Date.compareWeeks(from: date) > 0 {
                    let weeks = Date.compareWeeks(from: date)
                    if weeks > 1 {
                        cell.timeLabel.text = "\(weeks) weeks ago"
                    } else {
                        cell.timeLabel.text = "Last week"
                    }
                } else if Date.compareDays(from: date) > 0 {
                    let days = Date.compareDays(from: date)
                    if days > 1 {
                        cell.timeLabel.text = "\(days) days ago"
                    } else {
                        cell.timeLabel.text = "Yesterday"
                    }
                } else if Date.compareHours(from: date) > 0 {
                    let hours = Date.compareHours(from: date)
                    if hours > 1 {
                        cell.timeLabel.text = "\(hours) hours ago"
                    } else {
                        cell.timeLabel.text = "\(hours) hour ago"
                    }
                } else if Date.compareMinutes(from: date) > 0 {
                    let mins = Date.compareMinutes(from: date)
                    if mins > 1 {
                        cell.timeLabel.text = "\(mins) minutes ago"
                    } else {
                        cell.timeLabel.text = "\(mins) minute ago"
                    }
                } else {
                    cell.timeLabel.text = "Just now"
                }
            }
            
            // Present cells in descending order - lastest acitivity top
            if model.isConsecutive {
                cell.bookLabel.text = "\(model.bookName) Ch. \(model.min + 1) ~ \(model.max + 1)"
            } else {
                cell.bookLabel.text = "\(model.bookName) Ch. \(model.min + 1)"
            }
            
            return cell
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let alertController = self.createUndoMarkChaptersAlert(with: indexPath) {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
