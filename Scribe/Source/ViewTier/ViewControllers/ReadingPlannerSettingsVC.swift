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
    var readingPlannerDataSource = [ReadingPlannerVOM]()
    var goalJSONData = JSONObject()
    var startDateToggled = false
    var endDateToggled = false
    var goalToggled = false
    var emptyPastAcitivity = true
    var showLoadMoreCell = true
    var activitiesLoadAmount = 10
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
        self.showLoadingIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchBiblePlannerActivities()
        }
    }
    
    private func fetchBiblePlannerActivities() {
        let cmd = FetchPlannerMarkActivitiesCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                NSLog("FetchPlannerMarkActivitiesCommand returned with success")
                self.activityDataSource = array
            case .failure:
                NSLog("FetchPlannerMarkActivitiesCommand returned with failure")
            }
            self.fetchBiblePlannerGoal()
        }
        cmd.execute()
    }
    
    private func fetchBiblePlannerGoal() {
        let cmd = FetchPlannerGoalCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let model):
                NSLog("FetchPlannerGoalCommand returned with success")
                self.goalJSONData = model.asJSON()
            case .failure:
                NSLog("FetchPlannerGoalCommand returned with failure")
//                self.setPlannerInitialGoal()
            }
            self.fetchReadingPlanners()
//            DispatchQueue.main.async {
//                self.hideLoadingIndicator()
//                self.tableView.reloadData()
//            }
        }
        cmd.execute()
    }
    
    private func fetchReadingPlanners() {
        let cmd = FetchReadingPlannersCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.readingPlannerDataSource = array
            case .failure(let error):
                NSLog("FetchReadingPlannersCommand returned with error: \(error)")
            }
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
                self.tableView.reloadData()
            }
        }
        cmd.execute()
    }
    
    private func createNewReadingPlannerAlert() -> UIAlertController? {
        
        let alertController = UIAlertController(
            title: "Confirm",
            message: CreateNewReadingPlanMessage,
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(
            title: YES,
            style: .default,
            handler: { action in
                
        })
        
        let noAction = UIAlertAction(
            title: "No",
            style: .cancel,
            handler: { _ in
        })
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        return alertController
    }
    
    private func createReadingPlannerSelectionAlert(with indexPath: IndexPath) -> UIAlertController? {
        
        let alertController = UIAlertController(
            title: "Cannot Delete",
            message: CurrentReadingPlannerSelectedMessage,
            preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: OK,
            style: .default,
            handler: { _ in
        })
        
        alertController.addAction(okayAction)

        return alertController
    }
    
    private func createUndoMarkChaptersAlert(with indexPath: IndexPath) -> UIAlertController? {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ReadActivityCell,
            let title = cell.bookLabel.text
        else {
            return nil
        }
        let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 2)]

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
                strongSelf.activityDataSource.remove(at: (strongSelf.activityDataSource.count - 1) - (indexPath.row - 2))
                if strongSelf.activityDataSource.count < 10 {
                    strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    strongSelf.tableView.reloadSections([0], with: .fade)
                }
                
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
        cell.activityCountLabel.text = "\(indexPath.row - 1)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm"
        if let date = dateFormatter.date(from: model.time) {
            if Date.compareYears(from: date) > 0 {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = timeFormatter.string(from: date)
                cell.timeLabel.text = dateString
//                let years = Date.compareYears(from: date)
//                if years > 1 {
//                    cell.timeLabel.text = "\(years)y ago"
//                } else {
//                    cell.timeLabel.text = "Last year"
//                }
            } else if Date.compareMonths(from: date) > 0 {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "MM/dd/yyyy"
                let dateString = timeFormatter.string(from: date)
                cell.timeLabel.text = dateString
                
//                let months = Date.compareMonths(from: date)
//                if months > 1 {
//                    cell.timeLabel.text = "\(months) months ago"
//                } else {
//                    cell.timeLabel.text = "Last month"
//                }
            } else if Date.compareWeeks(from: date) > 0 {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "EEE, h:mm a"
                let dateString = timeFormatter.string(from: date)
                cell.timeLabel.text = dateString
                
//                let weeks = Date.compareWeeks(from: date)
//                if weeks > 1 {
//                    cell.timeLabel.text = "\(weeks)w ago"
//                } else {
//                    cell.timeLabel.text = "Last week"
//                }
            } else if Date.compareDays(from: date) > 0 {
                let timeFormatter = DateFormatter()
                
                let days = Date.compareDays(from: date)
                if days > 1 {
                    timeFormatter.dateFormat = "EEE, h:mm a"
                    let dateString = timeFormatter.string(from: date)
                    cell.timeLabel.text = dateString
//                    cell.timeLabel.text = "\(days)d ago"
                } else {
                    timeFormatter.dateFormat = "'Yesterday', h:mm a"
                    let dateString = timeFormatter.string(from: date)
                    cell.timeLabel.text = dateString
//                    cell.timeLabel.text = "Yesterday"
                }
            } else if Date.compareHours(from: date) > 0 {
                let hours = Date.compareHours(from: date)
                cell.timeLabel.text = "\(hours)h ago"
//                if hours > 1 {
//                    cell.timeLabel.text = "\(hours)h ago"
//                } else {
//                    cell.timeLabel.text = "\(hours)h ago"
//                }
            } else if Date.compareMinutes(from: date) > 0 {
                let mins = Date.compareMinutes(from: date)
                cell.timeLabel.text = "\(mins)m ago"
//                if mins > 1 {
//                    cell.timeLabel.text = "\(mins)m ago"
//                } else {
//                    cell.timeLabel.text = "\(mins)m ago"
//                }
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
        let model = PlannerGoalVOM(from: self.goalJSONData)
        
        let OTText = model.OTGoal == 1 ? "time" : "times"
        let NTText = model.NTGoal == 1 ? "time" : "times"
        
        if indexPath.row == 1 {
            cell.titleLabel.text = "Start Date :"
            cell.dateRangeLabel.text = "From"
            cell.dateLabel.text = model.startDate
        } else if indexPath.row == 3 {
            cell.titleLabel.text = "End Date :"
            cell.dateRangeLabel.text = "To"
            cell.dateLabel.text = model.endDate
        } else {
            cell.titleLabel.text = "Goal :"
            cell.dateRangeLabel.text = ""
            if model.OTGoal == 0 {
                cell.dateLabel.text = "NT \(model.NTGoal) \(NTText)"
            } else if model.NTGoal == 0 {
                cell.dateLabel.text = "OT \(model.OTGoal) \(OTText)"
            } else {
                cell.dateLabel.text = "OT \(model.OTGoal) \(OTText) + NT \(model.NTGoal) \(NTText)"
            }
        }
    }
    
    private func populate(cell: ReadingPlannerCell, with model: ReadingPlannerVOM, at indexPath: IndexPath) {
        
//        if indexPath.row == 1 {
//            cell.titleLabel.text = "Start Date :"
//            cell.dateRangeLabel.text = "From"
//            cell.dateLabel.text = model.startDate
//        } else if indexPath.row == 3 {
//            cell.titleLabel.text = "End Date :"
//            cell.dateRangeLabel.text = "To"
//            cell.dateLabel.text = model.endDate
//        } else {
//            cell.titleLabel.text = "Goal :"
//            cell.dateRangeLabel.text = ""
//            if model.OTGoal == 0 {
//                cell.dateLabel.text = "NT \(model.NTGoal) \(NTText)"
//            } else if model.NTGoal == 0 {
//                cell.dateLabel.text = "OT \(model.OTGoal) \(OTText)"
//            } else {
//                cell.dateLabel.text = "OT \(model.OTGoal) \(OTText) + NT \(model.NTGoal) \(NTText)"
//            }
//        }
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
            
            if let startDate = self.goalJSONData["startDate"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if let dateData = dateFormatter.date(from: startDate) {
                    cell.datePickerView.setDate(dateData, animated: false)
                }
            }
        } else if indexPath.row == 4 {
            let minDate = Calendar.current.date(byAdding: components, to: Date())
            
            components.year = 5
            let maxDate = Calendar.current.date(byAdding: components, to: Date())
            
            cell.datePickerView.minimumDate = minDate
            cell.datePickerView.maximumDate = maxDate
            
            if let endDate = self.goalJSONData["endDate"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if let dateData = dateFormatter.date(from: endDate) {
                    cell.datePickerView.setDate(dateData, animated: false)
                }
            }
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
    
    private func createNewReadingPlan() {
        let goalModel = BibleFactory.getDefaultGoal()
        let initialPDS = BibleFactory.getDefaultPDS()
        let defaultsStore = UserDefaultsStore()
        let index = defaultsStore.loadReadingPlannerIndex()
        
        let plannerModel = ReadingPlannerVOM(id: index, goal: goalModel, data: initialPDS, selected: true)
        
        let cmd = SaveSelectedReadingPlannerCommand()
        cmd.readingPlannerVOM = model
        cmd.onCompletion { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func removePastActivity() {
        let cmd = RemovePlannerMarkActivityCommand()
        cmd.plannerActivityDataSource = self.activityDataSource
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("RemovePlannerMarkActivityCommand returned with success")
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
                NotificationCenter.default.post(name: biblePlannerDataUpdatedFromSettings, object: nil)
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func savePlannerGoalToDB(with model: PlannerGoalVOM, showToast: Bool = true) {
        let cmd = SavePlannerGoalCommand()
        cmd.plannerGoalData = model
        cmd.onCompletion { result in
            switch result {
            case .success:
                if showToast {
                    self.showSuccessToast(on: self.tableView)
                }
                self.startDateToggled = false
                self.endDateToggled = false
                self.goalToggled = false
                self.tableView.reloadSections([1], with: .fade)
                NSLog("SavePlannerGoalCommand returned with success")
                NotificationCenter.default.post(name: biblePlannerDataUpdatedFromSettings, object: nil)
            case .failure:
                NSLog("SavePlannerGoalCommand returned with failure")
            }
            self.hideLoadingIndicator()
            self.disableSaveButton()
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.activityDataSource.count == 0 {
                self.emptyPastAcitivity = true
            } else {
                self.emptyPastAcitivity = false
                if self.activityDataSource.count > 10 && self.showLoadMoreCell {
//                    self.showLoadMoreCell = true
                    return self.activitiesLoadAmount + 3
                }
            }
            return self.activityDataSource.count + 2
        } else if section == 2 {
            return self.readingPlannerDataSource.count + 1
        } else if section == 3 {
            return 2
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
                cell.titleLabel.text = "PLANNER GOAL"
                cell.subTextLabel.text = "You need to save the change to apply."
            } else if indexPath.section == 2 {
                cell.titleLabel.text = "READING PLANS"
                cell.subTextLabel.text = "Change or delete reading plans."
            } else if indexPath.section == 3 {
                cell.separatorView.isHidden = true
                cell.titleLabel.text = "NEW READING PLAN"
                cell.subTextLabel.text = "Create a new reading plan."
            }
            return cell
        }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyActivityCell", for: indexPath) as? ReadActivityCell
                    else {
                        return UITableViewCell()
                }
                return cell
            } else {
                if self.activityDataSource.count > 10 {
                    if indexPath.row == (self.activitiesLoadAmount + 2) {
                        guard
                            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreActivitiesCell", for: indexPath) as? LoadMoreActivitiesCell
                        else {
                            return UITableViewCell()
                        }
                        UITableViewCell.applyScribeCellAttributes(to: cell)
                        cell.tag = -1
                        return cell
                    }
                }
                
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReadActivityCell", for: indexPath) as? ReadActivityCell
                else {
                    return UITableViewCell()
                }
                UITableViewCell.applyScribeCellAttributes(to: cell)
                
                let model = self.activityDataSource[(self.activityDataSource.count - 1) - (indexPath.row - 2)]
                self.populate(cell: cell, with: model, at: indexPath)
                return cell
            }
            
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
                UITableViewCell.applyScribeCellAttributes(to: cell)
                
                self.populate(cell: cell, at: indexPath)
                
                return cell
            }
            
        case 2:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingPlannerCell", for: indexPath) as? ReadingPlannerCell
                else {
                    return UITableViewCell()
            }
            UITableViewCell.applyScribeCellAttributes(to: cell)
            
            let model = self.readingPlannerDataSource[indexPath.row - 1]
            self.populate(cell: cell, with: model, at: indexPath)
            
            return cell
        case 3:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreateNewReadingPlanCell", for: indexPath) as? CreateNewReadingPlanCell
                else {
                    return UITableViewCell()
            }
//            UITableViewCell.applyScribeClearCellAttributes(to: cell)
            cell.selectionStyle = .none
            
//            let model = self.readingPlannerDataSource[indexPath.row - 1]
//            self.populate(cell: cell, with: model, at: indexPath)
            let test = UIView()
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.tag == -1 {
                self.activitiesLoadAmount = self.activitiesLoadAmount + 10
                if self.activityDataSource.count <= self.activitiesLoadAmount {
                    self.showLoadMoreCell = false
                }
                tableView.reloadSections([0], with: .fade)
            } else {
                if let alertController = self.createUndoMarkChaptersAlert(with: indexPath) {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                self.startDateToggled = !self.startDateToggled
            } else if indexPath.row == 3 {
                self.endDateToggled = !self.endDateToggled
            } else if indexPath.row == 5 {
                // Initialize Pickerview
                let indexPath = IndexPath(row: 6, section: 1)
                guard let cell = tableView.cellForRow(at: indexPath) as? GoalPickerCell else { return }
                let model = PlannerGoalVOM(from: self.goalJSONData)
                cell.pickerView.selectRow(model.OTGoal, inComponent: 0, animated: false)
                cell.pickerView.selectRow(model.NTGoal, inComponent: 1, animated: false)
                
                // Toggle to show/hide
                self.goalToggled = !self.goalToggled
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if indexPath.section == 2 {
            let model = self.readingPlannerDataSource[indexPath.row - 1]
            if model.selected {
                if let alertController = self.createReadingPlannerSelectionAlert(with: indexPath) {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else if indexPath.section == 3 {
//            let model = self.readingPlannerDataSource[indexPath.row - 1]
//            if model.selected {
                if let alertController = self.createReadingPlannerSelectionAlert(with: indexPath) {
                    self.present(alertController, animated: true, completion: nil)
                }
//            }
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
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                if self.emptyPastAcitivity {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            }
        }
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
        }
        
        return UITableViewAutomaticDimension
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
        
        if let frame = pickerLabel?.frame {
            pickerLabel?.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height - 10)
        }
        
        if component == 0 {
            if row == 0 {
                pickerLabel?.text =  "- Old Testament -"
            } else {
                if row == 1 {
                    pickerLabel?.text =  "OT \(row) time"
                } else {
                    pickerLabel?.text =  "OT \(row) times"
                }
            }
            
        } else {
            if row == 0 {
                pickerLabel?.text =  "- New Testament -"
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
        
        if row == 0 {
            if component == 0 {
                pickerView.selectRow(1, inComponent: 1, animated: true)
            } else if component == 1 {
                pickerView.selectRow(1, inComponent: 0, animated: true)
            }
        }
        
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
        
        self.goalJSONData["OTGoal"] = OTRow
        self.goalJSONData["NTGoal"] = NTRow
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
            self.goalJSONData["startDate"] = stringDate
        } else if sender.tag == 4 {
            let indexPath = IndexPath(row: 3, section: 1)
            if let cell = self.tableView.cellForRow(at: indexPath) as? SetGoalCell {
                cell.dateLabel.text = stringDate
            }
            self.goalJSONData["endDate"] = stringDate
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.showLoadingIndicator()
        let model = PlannerGoalVOM(from: self.goalJSONData)
        self.savePlannerGoalToDB(with: model)
    }
    
    @IBAction func createNewPlanTapped(_ sender: UIButton) {
        if let alertController = self.createNewReadingPlannerAlert() {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("ha")
//        self.navigationController?.navigationBar.barTintColor = UIColor.scribeDesignTwoBlue
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//    }
}
