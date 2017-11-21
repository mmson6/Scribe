//
//  EditContactInfoVC.swift
//  Scribe
//
//  Created by Mikael Son on 8/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseDatabase
import PhoneNumberKit


internal enum Section: Int {
    case Top
    case General
    case Address
    case Birthday
    case ChurchService
    case ChurchGroup
    
    func int() -> Int {
        return self.rawValue
    }
}

class EditContactInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var selectedGroupCell: ChurchGroupCell?
    private var addedBirthday = false
    private var datePickerVisible = false
    var editingTextField: UITextField?
    var lookupKey: Any?
    var contactModel: ContactDetailVOM? {
        didSet {
            guard let model = self.contactModel else { return }
            
            var generalInfoList = [String: Any?]()
            generalInfoList["Name (Kor)"] = model.nameKor
            generalInfoList["Name (Eng)"] = model.nameEng
            generalInfoList["Phone"] = model.phone
            generalInfoList["District"] = model.district
            
            self.contactDetailInfo["GeneralInfo"] = generalInfoList
            self.contactDetailInfo["Address"] = ["Address": model.address]
            self.contactDetailInfo["Birthday"] = ["Birthday": model.birthday]
            
            var churchServiceList = [String: Bool]()
            churchServiceList["Teacher"] = model.teacher
            churchServiceList["Choir"] = model.choir
            churchServiceList["Translator"] = model.translator
            self.contactDetailInfo["ChurchServices"] = churchServiceList
            
            self.contactDetailInfo["ChurchGroup"] = ["Group": model.group]
        }
    }
    var contactDetailInfo = [String: [String: Any?]]()
    let sectionArray: [String] = ["", "", "ADDRESS", "", "CHURCH SERVICES", "GROUP"]
    
    // MARK: UIViewController Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.loadDataSource()
    }

    // MARK: Helper Functions
    
    private func createGroupCheckAlert(with cell: ChurchGroupCell) -> UIAlertController? {
        guard let group = cell.infoLabel.text else { return nil }
        var title: String
        var message: String
        var buttonTitle: String
        var buttonStyle: UIAlertActionStyle
        
        if cell.buttonSelected {
            title = "Revoke Assignment"
            message = "Are you sure you want to revoke this assignment?"
            buttonTitle = "Revoke"
            buttonStyle = .destructive
        } else {
            title = "Assign to Group"
            message = "Do you want to assign this user to \(group) Group??"
            buttonTitle = "Assign"
            buttonStyle = .default
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let assignAction = UIAlertAction(
            title: buttonTitle,
            style: buttonStyle,
            handler: { action in
                guard
                    var churchGroupData = self.contactDetailInfo["ChurchGroup"] as? [String: String]
                    else {
                        return
                }
                
                cell.buttonSelected = true
                cell.animateSelected()
                if let selectedCell = self.selectedGroupCell {
                    selectedCell.buttonSelected = false
                    selectedCell.animateDeselected()
                }
                
                self.saveButton.isEnabled = true
                if action.style != .destructive {
                    self.selectedGroupCell = cell
                    churchGroupData["Group"] = group
                } else {
                    self.selectedGroupCell = nil
                    churchGroupData["Group"] = ""
                }
                
                self.contactDetailInfo["ChurchGroup"] = churchGroupData as [String: Any?]
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(assignAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func createServiceCheckAlert(with cell: ChurchServiceCell) -> UIAlertController? {
        guard let service = cell.infoLabel.text else { return nil }
        var title: String
        var message: String
        var buttonTitle: String
        var buttonStyle: UIAlertActionStyle
        
        if cell.buttonSelected {
            title = "Revoke Assignment"
            message = "Are you sure you want to revoke this assignment?"
            buttonTitle = "Revoke"
            buttonStyle = .destructive
        } else {
            title = "Assign Service"
            message = "Do you want to assign \(service) Service to this user?"
            buttonTitle = "Assign"
            buttonStyle = .default
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let assignAction = UIAlertAction(
            title: buttonTitle,
            style: buttonStyle,
            handler: { action in
                guard
                    var churchServiceData = self.contactDetailInfo["ChurchServices"] as? [String: Bool]
                    else {
                        return
                }
                
                if cell.buttonSelected {
                    cell.buttonSelected = false
                    churchServiceData[service] = false
                    cell.animateDeselected()
                } else {
                    cell.buttonSelected = true
                    churchServiceData[service] = true
                    cell.animateSelected()
                }
                self.saveButton.isEnabled = true
                self.contactDetailInfo["ChurchServices"] = churchServiceData as [String: Any?]
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(assignAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func didSetBirthday(date: String) {
        var birthdayInfoData = [String: String]()
        birthdayInfoData["Birthday"] = date
        self.contactDetailInfo["Birthday"] = birthdayInfoData as [String: Any?]
    }
    
    private func handleBirthdayAdded(with indexPath: IndexPath) {
        let birthdayInfoIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        guard let cell = self.tableView.cellForRow(at: birthdayInfoIndexPath) as? BirthdayInfoCell else { return }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let stringDate = dateFormatter.string(from: date)
        cell.birthdayLabel.text = stringDate
        self.didSetBirthday(date: stringDate)
    }
    

    private func initializeViews() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handleScroll(gestureRecognizer:)))
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30))
        footerView.backgroundColor = .white
        self.tableView.tableFooterView = footerView

        let window = UIApplication.shared.keyWindow!
        self.activityIndicatorView.frame = CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height)
        window.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.isHidden = true
        
        self.saveButton.setTitleColor(UIColor.rgb(red: 235, green: 235, blue: 235), for: .disabled)
        self.saveButton.isEnabled = false
    }
    
    private func loadDataSource() {
        let cmd = FetchContactDetailEditCommand()
        let store = UserDefaultsStore()
        let ver = store.loadContactsVer()
        cmd.lookupKey = self.lookupKey
        cmd.contactsVer = ver
        cmd.onCompletion { result in
            switch result {
            case .success(let object):
                self.contactModel = object
                self.tableView.reloadData()
            case .failure(let error):
                NSLog("error occurred: \(error)")
            }
        }
        cmd.execute()
    }
    
    private func populate(cell: AddBirthdayCell, data: [String: Any?], indexPath: IndexPath ) {
        if let birthday = data["Birthday"] as? String {
            if birthday == "" {
                self.addedBirthday = false
            } else {
                self.addedBirthday = true
                tableView.setEditing(true, animated: true)
                tableView.allowsSelectionDuringEditing = true
            }
        }
    }
    
    private func populate(cell: AddressInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        
        guard let address = data["Address"] as? AddressDM else { return }
        cell.streetTextField.text = address.addressLine
        cell.cityTextField.text = address.city
        cell.stateTextField.text = address.state
        cell.zipTextField.text = address.zipCode
    }
    
    private func populate(cell: BirthdayInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.infoLabel.text = "birthday"
        if let birthday = data["Birthday"] as? String {
            if birthday == "" {
                self.addedBirthday = false
            } else {
                self.addedBirthday = true
                cell.birthdayLabel.text = birthday
            }
        }
    }
    
    private func populate(cell: ChurchGroupCell, data: [String: Any?], indexPath: IndexPath ) {
        func updateChecker(checked: Bool, cell: ChurchGroupCell) {
            if checked {
                cell.buttonSelected = true
                cell.setSelectedLayerAttributes()
                self.selectedGroupCell = cell
                
            } else {
                cell.buttonSelected = false
                cell.setUnselectedLayerAttributes()
            }
        }
        
        guard let group = data["Group"] as? String else { return }
        
        switch indexPath.row {
        case 1:
            cell.infoLabel.text = "Fathers"
            updateChecker(checked: group == "Fathers", cell: cell)
        case 2:
            cell.infoLabel.text = "Mothers"
            updateChecker(checked: group == "Mothers", cell: cell)
        case 3:
            cell.infoLabel.text = "Young Adults"
            updateChecker(checked: group == "Young Adults", cell: cell)
        case 4:
            cell.infoLabel.text = "Church School"
            updateChecker(checked: group == "Church School", cell: cell)
        default:
            break
        }
    }
    
    private func populate(cell: ChurchServiceCell, data: [String: Any?], indexPath: IndexPath ) {
        func updateChecker(checked: Bool, cell: ChurchServiceCell) {
            if checked {
                cell.buttonSelected = true
                cell.setSelectedLayerAttributes()
                
            } else {
                cell.buttonSelected = false
                cell.setUnselectedLayerAttributes()
            }
        }
        
        switch indexPath.row {
        case 1:
            if let checked = data["Teacher"] as? Bool {
                cell.infoLabel.text = "Teacher"
                updateChecker(checked: checked, cell: cell)
            }
        case 2:
            if let checked = data["Choir"] as? Bool {
                cell.infoLabel.text = "Choir"
                updateChecker(checked: checked, cell: cell)
            }
        case 3:
            if let checked = data["Translator"] as? Bool {
                cell.infoLabel.text = "Translator"
                updateChecker(checked: checked, cell: cell)
            }
        default:
            break
        }
    }
    
    private func populate(cell: GeneralInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 1:
            let name = data["Name (Eng)"] as? String
            cell.infoLabel.text = "name (eng)"
            cell.infoTextField.text = name
            cell.infoTextField.placeholder = "Enter Enlish name"
            cell.infoTextField.tag = 21
        case 2:
            let name = data["Name (Kor)"] as? String
            cell.infoLabel.text = "name (kor)"
            cell.infoTextField.text = name
            cell.infoTextField.placeholder = "Enter Korean name"
            cell.infoTextField.tag = 22
        case 3:
            let phone = data["Phone"] as? String
            cell.infoLabel.text = "phone"
            
            let phoneNumberKit = PhoneNumberKit()
            if let text = phone {
                if let parsedNumber = try? phoneNumberKit.parse(text) {
                    let formattedNumber = phoneNumberKit.format(parsedNumber, toType: .national)
                    cell.infoTextField.text = formattedNumber
                }
            }
            cell.infoTextField.placeholder = "Enter phone number"
            cell.infoTextField.tag = 23
            cell.infoTextField.keyboardType = .numberPad
        case 4:
            let district = data["District"] as? String
            cell.infoLabel.text = "district"
            cell.infoTextField.text = district
            cell.infoTextField.placeholder = "Enter district"
            cell.infoTextField.keyboardType = .numberPad
            cell.infoTextField.tag = 24
        default:
            break
        }
    }
    

    private func populate(cell: SectionHeaderCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        if let text = self.tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: indexPath.section) {
            cell.sectionTitle.text = text
            if text.count == 0 {
                cell.heightConstraint.constant = 0
            } else {
                cell.heightConstraint.constant = 25
            }
        } else {
            cell.heightConstraint.constant = 0
        }
    }
    
    private func presentAlertBeforeAssignment(with cell: ChurchGroupCell) {
        if let alert = createGroupCheckAlert(with: cell) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentAlertBeforeAssignment(with cell: ChurchServiceCell) {
        if let alert = createServiceCheckAlert(with: cell) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentAlertAfterUpdate(success: Bool) {
        var title: String
        var message: String
        
        if success {
            title = "Success"
            message = "Contact updated successfully."
        } else {
            title = "Error"
            message = "Error occurred. Please try again later."
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: "Okay",
            style: .default,
            handler: { action in
                self.performSegue(withIdentifier: "unwindToManageContactInfoVC", sender: nil)
        })
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func incrementContactVer() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactVerRef = ref.child(contactsChicago).child("contactsVer")
        
        contactVerRef.observeSingleEvent(of: .value, with: { [weak self] (snap) in
            guard let strongSelf = self else { return }
            
            guard
                let object = snap.value as? JSONObject,
                var ver = object["version"] as? Int64
                else {
                    strongSelf.hideLoadingIndicator(success: false)
                    return
            }
            
            ver += 1
            let jsonData = ["version": ver ] as [String: Any]
            
            contactVerRef.setValue(jsonData, withCompletionBlock: { (error, ref) in
                
                
                if let error = error {
                    print("error occurred while incrementing contactVer:: \(error)")
                    strongSelf.hideLoadingIndicator(success: false)
                    return
                }
                print("::succesfully incremented contactVer")
                strongSelf.hideLoadingIndicator(success: true)
            })
        })
    }
    
    private func showLoadingIndicator() {
        self.editingTextField?.resignFirstResponder()
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(success: Bool) {
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
        self.presentAlertAfterUpdate(success: success)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case Section.Top.int():
            return 1
        case Section.General.int():
            return 5
        case Section.Address.int():
            return 2
        case Section.Birthday.int():
            return 4
        case Section.ChurchService.int():
            return 4
        case Section.ChurchGroup.int():
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.Top.int():
            return 160
        case Section.Address.int():
            return 250
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.Birthday.int() {
            if indexPath.row == 1 {
                if self.addedBirthday {
                    return 0
                } else {
                    return UITableViewAutomaticDimension
                }
            }
            else if indexPath.row == 2 {
                if self.addedBirthday {
                    return UITableViewAutomaticDimension
                } else {
                    return 0
                }
            } else if indexPath.row == 3 {
                if self.datePickerVisible {
                    return 140
                } else {
                    return 0
                }
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section != Section.Top.int()
        {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell", for: indexPath) as? SectionHeaderCell
            else {
                return UITableViewCell()
            }
            self.populate(cell: cell, data: [:], indexPath: indexPath)
            
            return cell
        } else {
            switch indexPath.section {
            case Section.Top.int():
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as? TopCell
                else {
                    return UITableViewCell()
                }
                
                return cell
                
            case Section.General.int():
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInfoCell", for: indexPath) as? GeneralInfoCell,
                    let generalInfoData = self.contactDetailInfo["GeneralInfo"]
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, data: generalInfoData, indexPath: indexPath)
                
                return cell
                
            case Section.Address.int():
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddressInfoCell", for: indexPath) as? AddressInfoCell,
                    let addressInfoData = self.contactDetailInfo["Address"]
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, data: addressInfoData, indexPath: indexPath)
                
                return cell
                
            case Section.Birthday.int():
                
                switch indexPath.row {
                case 1:
                    guard
                        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBirthdayCell", for: indexPath) as? AddBirthdayCell,
                        let birthdayInfoData = self.contactDetailInfo["Birthday"]
                    else {
                        return UITableViewCell()
                    }
                    
                    self.populate(cell: cell, data: birthdayInfoData, indexPath: indexPath)
                    UITableViewCell.applyScribeCellAttributes(to: cell)
                    
                    return cell
                    
                case 2:
                    guard
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayInfoCell", for: indexPath) as? BirthdayInfoCell,
                        let birthdayInfoData = self.contactDetailInfo["Birthday"]
                    else {
                        return UITableViewCell()
                    }
                    
                    self.populate(cell: cell, data: birthdayInfoData, indexPath: indexPath)
                    UITableViewCell.applyScribeCellAttributes(to: cell)
                    
                    return cell
                    
                case 3:
                    guard
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayDatePickerCell", for: indexPath) as? BirthdayDatePickerCell
                    else {
                        return UITableViewCell()
                    }
                    
                    // Remove indicator lines
                    if cell.datePickerView.subviews.count > 0 {
                        let subViews = cell.datePickerView.subviews[0]
                        if subViews.subviews.count == 3 {
                            subViews.subviews[1].isHidden = true
                            subViews.subviews[2].isHidden = true
                        }
                    }
                    
                    return cell
                default:
                    return UITableViewCell()
                }
                
            case Section.ChurchService.int():
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChurchServiceCell", for: indexPath) as? ChurchServiceCell,
                    let churchInfoData = self.contactDetailInfo["ChurchServices"]
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, data: churchInfoData, indexPath: indexPath)
                UITableViewCell.applyScribeCellAttributes(to: cell)
                
                return cell
            case Section.ChurchGroup.int():
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChurchGroupCell", for: indexPath) as? ChurchGroupCell,
                    let groupData = self.contactDetailInfo["ChurchGroup"]
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, data: groupData, indexPath: indexPath)
                UITableViewCell.applyScribeCellAttributes(to: cell)
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.tableView.setEditing(true, animated: true)
        } else {
            self.tableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Section.Birthday.int() && indexPath.row ==  2 {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            self.addedBirthday = false
            self.datePickerVisible = false
            self.saveButton.isEnabled = true
            self.didSetBirthday(date: "")
            
            tableView.setEditing(false, animated: true)
            tableView.beginUpdates()
            tableView.endUpdates()
        })
        deleteAction.backgroundColor = UIColor.scribeDesignTwoRed
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.sectionArray[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.Birthday.int() {
            
            if indexPath.row == 1 { // Add Birthday Tapped
                self.addedBirthday = true
                tableView.setEditing(true, animated: true)
                tableView.allowsSelectionDuringEditing = true
                
                self.handleBirthdayAdded(with: indexPath)
                self.saveButton.isEnabled = true
            } else if indexPath.row == 2 { // Show DatePicker View
                self.datePickerVisible = !self.datePickerVisible
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.section == Section.ChurchService.int() {
            guard
                let cell = tableView.cellForRow(at: indexPath) as? ChurchServiceCell
            else {
                return
            }
            
            self.presentAlertBeforeAssignment(with: cell)
        }
        if indexPath.section == Section.ChurchGroup.int() {
            guard
                let cell = tableView.cellForRow(at: indexPath) as? ChurchGroupCell
                else {
                    return
            }
            
            self.presentAlertBeforeAssignment(with: cell)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // MARK: IBAction Funtions
    
    @IBAction func addressValueChanged(_ sender: UITextField) {
        guard
            let addressInfoData = self.contactDetailInfo["Address"],
            let model = addressInfoData["Address"] as? AddressDM
            else {
                return
        }
        
        var json = model.asJSON()
        switch sender.tag {
        case 31:
            if let text = sender.text {
                json["addressLine"] = text
            }
        case 32:
            if let text = sender.text {
                json["city"] = text
            }
        case 33:
            if let text = sender.text {
                json["state"] = text
            }
        case 34:
            if let text = sender.text {
                json["zipCode"] = text
            }
        default:
            break
        }
        
        self.contactDetailInfo["Address"] = ["Address": AddressDM(from: json)]
        self.saveButton.isEnabled = true
    }
    
    @IBAction func generalInfoValueChanged(_ sender: UITextField) {
        guard var jsonData = self.contactDetailInfo["GeneralInfo"] else { return }
        
        switch sender.tag {
        case 21:
            if let text = sender.text {
                jsonData["Name (Eng)"] = text
            }
        case 22:
            if let text = sender.text {
                jsonData["Name (Kor)"] = text
            }
        case 23:
            if let text = sender.text {
                jsonData["Phone"] = text
            }
        case 24:
            if let text = sender.text {
                jsonData["District"] = text
            }
        default:
            break
        }
        
        self.contactDetailInfo["GeneralInfo"] = jsonData
        self.saveButton.isEnabled = true
    }
    
    @IBAction func handleDPValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let indexPath = IndexPath(row: 2, section: Section.Birthday.int())
        if let cell = self.tableView.cellForRow(at: indexPath) as? BirthdayInfoCell {
            let stringDate = dateFormatter.string(from: sender.date)
            cell.birthdayLabel.text = stringDate
            self.didSetBirthday(date: stringDate)
            self.saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.showLoadingIndicator()
        
        guard let contactId = self.lookupKey as? String else { return }
        let requestModel = UpdateContactDetailRequest(from: self.contactDetailInfo, and: contactId)
        let jsonData = requestModel.asJSON()

        let baseRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactsPath = baseRef.child(contactsChicago).child("contacts")

        contactsPath.child(contactId).setValue(jsonData) { [weak self] (error, ref) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("error occurred while updating contact detail:: \(error)")
                strongSelf.hideLoadingIndicator(success: false)
                return
            }
            
            strongSelf.incrementContactVer()
        }
    }
    
    // MARK: ScrollView Delegate Functions
    
    @objc func handleScroll(gestureRecognizer: UIPanGestureRecognizer) {
        self.editingTextField?.resignFirstResponder()
    }
    
    // MARK: UITextField Delegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 23 {
            guard
                let generalInfoData = self.contactDetailInfo["GeneralInfo"],
                let phone = generalInfoData["Phone"] as? String
                else {
                    return true
            }
            textField.text = phone
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 23 {
            let characterset = CharacterSet(charactersIn: "0123456789")
            return string.rangeOfCharacter(from: characterset.inverted) == nil
        }
        if textField.tag == 33 {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 23 {
            guard
                var generalInfoData = self.contactDetailInfo["GeneralInfo"]
            else {
                return true
            }
            generalInfoData["Phone"] = textField.text as Any?
            self.contactDetailInfo["GeneralInfo"] = generalInfoData
            
            let phoneNumberKit = PhoneNumberKit()
            if let text = textField.text {
                if let parsedNumber = try? phoneNumberKit.parse(text) {
                    let formattedNumber = phoneNumberKit.format(parsedNumber, toType: .national)
                    textField.text = formattedNumber
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 31:
            if let nextTextField = self.view.viewWithTag(32) as? UITextField {
                nextTextField.becomeFirstResponder()
            }
            return false
        case 32:
            if let nextTextField = self.view.viewWithTag(33) as? UITextField {
                nextTextField.becomeFirstResponder()
            }
            return false
        case 33:
            if let nextTextField = self.view.viewWithTag(34) as? UITextField {
                nextTextField.becomeFirstResponder()
            }
            return false
        default:
            break
        }
        
        self.editingTextField?.resignFirstResponder()
        return true
    }
}
