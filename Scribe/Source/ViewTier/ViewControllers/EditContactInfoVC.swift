//
//  EditContactInfoVC.swift
//  Scribe
//
//  Created by Mikael Son on 8/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import PhoneNumberKit

internal enum Section: Int {
    case Top
    case General
    case Address
    case Birthday
    case ChurchService
    
    func int() -> Int {
        return self.rawValue
    }
}

class EditContactInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    private var addedBirthday = false
    private var datePickerVisible = false
    var editingTextView: UITextView?
    var editingTextField: UITextField?
    var lookupKey: Any?
    var contactModel: ContactDetailVOM? {
        didSet {
            var generalInfoList = [String: Any?]()
            generalInfoList["Name (Kor)"] = self.contactModel?.nameKor
            generalInfoList["Name (Eng)"] = self.contactModel?.nameEng
            generalInfoList["Phone"] = self.contactModel?.phone
            generalInfoList["District"] = self.contactModel?.district
            generalInfoList["Group"] = self.contactModel?.address
            self.contactDetailInfo["GeneralInfo"] = generalInfoList
            self.contactDetailInfo["Address"] = ["Address": self.contactModel?.address]
            
            var churchServiceList = [String: Bool]()
            churchServiceList["Teacher"] = self.contactModel?.teacher
            churchServiceList["Choir"] = self.contactModel?.choir
            churchServiceList["Translator"] = self.contactModel?.translator
            self.contactDetailInfo["ChurchServices"] = churchServiceList
        }
    }
    var contactDetailInfo = [String: [String: Any?]]()
    let sectionArray: [String] = ["", "", "ADDRESS", "", "CHURCH SERVICES"]
    
    // MARK: UIViewController Functions
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
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
    
    private func initializeViews() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handleScroll(gestureRecognizer:)))
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30))
        footerView.backgroundColor = .white
        self.tableView.tableFooterView = footerView
        
        self.saveButton.setTitleColor(UIColor.rgb(red: 235, green: 235, blue: 235), for: .disabled)
        self.saveButton.isEnabled = false
    }
    
    private func commonInit() {
        
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
    
    private func presentAlertBeforeCheck(with cell: ChurchInfoCell) {
        if let alert = createServiceCheckAlert(with: cell) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createServiceCheckAlert(with cell: ChurchInfoCell) -> UIAlertController? {
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
                if cell.buttonSelected {
                    cell.buttonSelected = false
                    cell.animateDeselected()
                } else {
                    cell.buttonSelected = true
                    cell.animateSelected()
                }
                self.saveButton.isEnabled = true
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
    
    private func populate(cell: SectionHeaderCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        cell.sectionTitle.text = self.tableView.dataSource?.tableView!(tableView, titleForHeaderInSection: indexPath.section)
    }
    
    private func populate(cell: GeneralInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 1:
            let name = data["Name (Eng)"] as? String
            cell.infoLabel.text = "name (eng)"
            cell.infoTextField.text = name
            cell.infoTextField.placeholder = "Enter Enlish name"
        case 2:
            let name = data["Name (Kor)"] as? String
            cell.infoLabel.text = "name (kor)"
            cell.infoTextField.text = name
            cell.infoTextField.placeholder = "Enter Korean name"
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
            cell.infoTextField.tag = 21
        case 4:
            let district = data["District"] as? String
            cell.infoLabel.text = "district"
            cell.infoTextField.text = district
            cell.infoTextField.placeholder = "Enter district"
        default:
            break
        }
    }
    
    private func populate(cell: BirthdayInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.infoLabel.text = "birthday"
    }
    
    private func populate(cell: AddressInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        cell.selectionStyle = .none
        
        let address = data["Address"]
        cell.addressTextView.text = address as? String
    }
    
    private func populate(cell: ChurchInfoCell, data: [String: Any?], indexPath: IndexPath ) {
        func updateChecker(checked: Bool, cell: ChurchInfoCell) {
            if checked {
                cell.buttonSelected = true
                cell.checkButton.tintColor = UIColor.scribeDesignTwoGreen
            } else {
                cell.buttonSelected = false
                cell.checkButton.tintColor = UIColor.rgb(red: 235, green: 235, blue: 235)
            }
        }
        
        switch indexPath.row {
        case 1:
            if let checked = data["Teacher"] as? Bool {
                cell.infoLabel.text = "Church School"
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
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
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
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.Top.int():
            return 160
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
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print("ha?")
        return true
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
                        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBirthdayCell", for: indexPath) as? AddBirthdayCell
                        else {
                            return UITableViewCell()
                    }
                    
                    UITableViewCell.applyScribeCellAttributes(to: cell)
                    
                    return cell
                    
                case 2:
                    guard
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayInfoCell", for: indexPath) as? BirthdayInfoCell
                        else {
                            return UITableViewCell()
                    }
                    
                    self.populate(cell: cell, data: [:], indexPath: indexPath)
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ChurchInfoCell", for: indexPath) as? ChurchInfoCell,
                    let churchInfoData = self.contactDetailInfo["ChurchServices"]
                else {
                    return UITableViewCell()
                }
                
                self.populate(cell: cell, data: churchInfoData, indexPath: indexPath)
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
        if indexPath.section == Section.Birthday.int() ||
            indexPath.section == Section.ChurchService.int()
        {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.section == Section.Birthday.int() {
                
                if indexPath.row == 1 {
                    self.addedBirthday = true
                    tableView.setEditing(true, animated: true)
                    tableView.allowsSelectionDuringEditing = true
                    self.saveButton.isEnabled = true
                } else if indexPath.row == 2 {
                    self.datePickerVisible = !self.datePickerVisible
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        if indexPath.section == Section.ChurchService.int() {
            guard
                let cell = tableView.cellForRow(at: indexPath) as? ChurchInfoCell
            else {
                return
            }
            
            self.presentAlertBeforeCheck(with: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // MARK: IBAction Funtions
    
    @IBAction func handleDPValueChanged(_ sender: UIDatePicker) {
        print(sender.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let indexPath = IndexPath(row: 2, section: Section.Birthday.int())
        if let cell = self.tableView.cellForRow(at: indexPath) as? BirthdayInfoCell {
            cell.birthdayLabel.text = dateFormatter.string(from: sender.date)
            
//            guard
//                var generalInfoData = self.contactDetailInfo["GeneralInfo"]
//                else {
//                    return true
//            }
//            generalInfoData["Phone"] = textField.text as Any?
//            self.contactDetailInfo["GeneralInfo"] = generalInfoData
//            
//            let phoneNumberKit = PhoneNumberKit()
//            if let text = textField.text {
//                if let parsedNumber = try? phoneNumberKit.parse(text) {
//                    let formattedNumber = phoneNumberKit.format(parsedNumber, toType: .national)
//                    textField.text = formattedNumber
//                }
//            }
            self.saveButton.isEnabled = true
        }
    }

    // MARK: ScrollView Delegate Functions
    
    func handleScroll(gestureRecognizer: UIPanGestureRecognizer) {
        self.editingTextView?.resignFirstResponder()
        self.editingTextField?.resignFirstResponder()
    }
    
    // MARK: UITextField Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingTextField = textField
        self.saveButton.isEnabled = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 21 {
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 21 {
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
    
    // MARK: UITextView Delegate Functions
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.editingTextView = textView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.saveButton.isEnabled = true
        if textView.tag == 11 {
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
}
