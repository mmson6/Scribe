//
//  ReadingPlannerSettingsVC.swift
//  Scribe
//
//  Created by Mikael Son on 9/25/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ReadingPlannerSettingsVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var activityDataSource = [PlannerActivityVOM]()
    var startDateToggled = false
    var endDateToggled = false
    var goalToggled = false
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commonInit()
        self.fetchData()
    }

    // MARK: Helper FUnctions
    
    private func commonInit() {
        self.disableSaveButton()
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
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
    
    private func disableSaveButton() {
        self.saveButton.isEnabled = false
        self.saveButton.tintColor = UIColor.scribeDesignTwoDarkBlueDisabled
    }
    
    private func enableSaveButton() {
        self.saveButton.isEnabled = true
        self.saveButton.tintColor = UIColor.scribeDesignTwoDarkBlue
    }
    
    private func populate(cell: ReadActivityCell, with model: PlannerActivityVOM, at indexPath: IndexPath) {
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
    }
    
    private func populate(cell: SetGoalCell, at indexPath: IndexPath) {
        if indexPath.row == 1 {
            cell.titleLabel.text = "Start Date :"
            cell.dateRangeLabel.text = "From"
        } else if indexPath.row == 3 {
            cell.titleLabel.text = "End Date :"
            cell.dateRangeLabel.text = "To"
        } else {
            cell.titleLabel.text = "Goal"
            cell.dateRangeLabel.text = ""
        }
    }
    
    private func initializeDatePickerView(cell: GoalDatePickerCell, indexPath: IndexPath) {
        // Remove indicator lines
        if cell.datePickerView.subviews.count > 0 {
            let subViews = cell.datePickerView.subviews[0]
            if subViews.subviews.count == 3 {
                subViews.subviews[1].isHidden = true
                subViews.subviews[2].isHidden = true
            }
        }
        
        var components = DateComponents()
        if indexPath.row == 2 {
            let maxDate = Calendar.current.date(byAdding: components, to: Date())
            
            components.year = -2
            let minDate = Calendar.current.date(byAdding: components, to: Date())
            
            cell.datePickerView.minimumDate = minDate
            cell.datePickerView.maximumDate = maxDate
        } else if indexPath.row == 4 {
            let minDate = Calendar.current.date(byAdding: components, to: Date())
            
            components.year = 5
            let maxDate = Calendar.current.date(byAdding: components, to: Date())
            
            cell.datePickerView.minimumDate = minDate
            cell.datePickerView.maximumDate = maxDate
        }
    }
    
    private func initializePickerView(cell: GoalPickerCell, indexPath: IndexPath) {
        // Remove indicator lines
        if cell.pickerView.subviews.count > 0 {
            let subViews = cell.pickerView.subviews[0]
            if subViews.subviews.count == 3 {
                subViews.subviews[1].isHidden = true
                subViews.subviews[2].isHidden = true
            }
        }
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.activityDataSource.count + 1
        } else {
            return 7
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingPlannerSettingsHeaderCell", for: indexPath) as? ReadingPlannerSettingsHeaderCell
                else {
                    return UITableViewCell()
            }
            
            if indexPath.section == 0 {
                cell.titleLabel.text = "PAST ACTIVITIES"
                cell.subTextLabel.text = "Undo your past marking activities"
            } else if indexPath.section == 1 {
                cell.titleLabel.text = "SET GOALS"
                cell.subTextLabel.text = "You need to save the change to apply."
            }
            return cell
        }
        
        switch indexPath.section {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReadActivityCell", for: indexPath) as? ReadActivityCell
            else {
                return UITableViewCell()
            }
            
            let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 1)]
            self.populate(cell: cell, with: model, at: indexPath)
            return cell
            
        case 1:
            if indexPath.row == 2 || indexPath.row == 4 {
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GoalDatePickerCell", for: indexPath) as? GoalDatePickerCell
                else {
                    return UITableViewCell()
                }
                
                self.initializeDatePickerView(cell: cell, indexPath: indexPath)
                cell.datePickerView.tag = indexPath.row
                
                return cell
            } else if indexPath.row == 6 {
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GoalPickerCell", for: indexPath) as? GoalPickerCell
                    else {
                        return UITableViewCell()
                }
                
                self.initializePickerView(cell: cell, indexPath: indexPath)
                cell.pickerView.delegate = self
                
                return cell
            } else {
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SetGoalCell", for: indexPath) as? SetGoalCell
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, at: indexPath)
                
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if let alertController = self.createUndoMarkChaptersAlert(with: indexPath) {
                self.present(alertController, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                self.startDateToggled = !self.startDateToggled
            } else if indexPath.row == 3 {
                self.endDateToggled = !self.endDateToggled
            } else if indexPath.row == 5 {
                self.goalToggled = !self.goalToggled
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6) {
            return 140
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                if self.startDateToggled {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            } else if indexPath.row == 4 {
                if self.endDateToggled {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            } else if indexPath.row == 6 {
                if self.goalToggled {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            }
            
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: UIPickerView Delegate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.tableView.frame.width * 3 / 8
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16)
            pickerLabel?.textAlignment = .center
        }
        
        if component == 0 {
            if row == 0 {
                pickerLabel?.text =  "-- Old Testament --"
            } else {
                if row == 1 {
                    pickerLabel?.text =  "OT \(row) time"
                } else {
                    pickerLabel?.text =  "OT \(row) times"
                }
            }
            
        } else {
            if row == 0 {
                pickerLabel?.text =  "-- New Testament --"
            } else {
                if row == 1 {
                    pickerLabel?.text =  "NT \(row) time"
                } else {
                    pickerLabel?.text =  "NT \(row) times"
                }
            }
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.enableSaveButton()
        
        let OTRow = pickerView.selectedRow(inComponent: 0)
        let NTRow = pickerView.selectedRow(inComponent: 1)
        let OTText = OTRow == 1 ? "time" : "times"
        let NTText = NTRow == 1 ? "time" : "times"

        let indexPath = IndexPath(row: 5, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath) as? SetGoalCell {
            if OTRow == 0 {
                cell.dateLabel.text = "NT \(NTRow) \(NTText)"
            } else if NTRow == 0 {
                cell.dateLabel.text = "OT \(OTRow) \(OTText)"
            } else {
                cell.dateLabel.text = "OT \(OTRow) \(OTText) + NT \(NTRow) \(NTText)"
            }
        }
    }
    
    // MARK: IBAction Functions
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.enableSaveButton()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let stringDate = dateFormatter.string(from: sender.date)
        
        if sender.tag == 2 {
            let indexPath = IndexPath(row: 1, section: 1)
            if let cell = self.tableView.cellForRow(at: indexPath) as? SetGoalCell {
                cell.dateLabel.text = stringDate
            }
        } else if sender.tag == 4 {
            let indexPath = IndexPath(row: 3, section: 1)
            if let cell = self.tableView.cellForRow(at: indexPath) as? SetGoalCell {
                cell.dateLabel.text = stringDate
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
}
