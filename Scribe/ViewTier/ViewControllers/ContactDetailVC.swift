//
//  ContactDetailVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import MapKit

import PhoneNumberKit


class ContactDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    public var lookupKey: Any?
    public var parentVC: String?
    private var infoDataSource: [ContactInfoVOM] = []
    let animator = PullDownTransitionAnimator()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.loadDataSource()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        //        self.navigationController?.navigationBar.barTintColor = UIColor.scribeColorGroup7
//        self.navigationController?.navigationBar.tintColor = UIColor.scribeColorCDNavBarBackground
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        //        UIView.animate(withDuration: 0.1, animations: {
        //            self.navigationController?.navigationBar.barTintColor = UIColor.white
        //            self.navigationController?.navigationBar.layoutIfNeeded()
        //        })
        
//        self.navigationController?.navigationBar.tintColor = UIColor.scribeDarkGray
        //        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        //        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard
//            self.infoDataSource.count > indexPath.row
//        else {
//            return UITableViewCell()
//        }
        
        let model: ContactInfoVOM
        if self.infoDataSource.count > indexPath.row {
            model = self.infoDataSource[indexPath.row]
        } else {
            model = ContactInfoVOM(jsonObj: [:])
        }
        
        
        switch indexPath.section {
        case 0:
            //            ContactImageCell
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactImageCell", for: indexPath) as? ContactImageCell
                else {
                    return UITableViewCell()
            }
            self.populate(cell, with: model)
            UITableViewCell.applyScribeCellAttributes(to: cell)
            return cell
            
        default:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoCell", for: indexPath) as? ContactInfoCell
                else {
                    return UITableViewCell()
            }
            self.populate(cell, with: model)
            UITableViewCell.applyScribeCellAttributes(to: cell)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.infoDataSource[indexPath.row]
        switch model.label {
        case "ADDRESS":
            self.presentAlertForAddress(with: model.value)
        case "PHONE":
            self.presentAlertForPhone(with: model.value)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            return self.infoDataSource.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 45
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return "Test Info"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.rgb(red: 248, green: 252, blue: 252)
        
        let margins = headerView.layoutMarginsGuide
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.addSubview(sectionLabel)
        sectionLabel.text = "GENERAL INFO"
        sectionLabel.textColor = .scribeDesignTwoDarkBlue
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 13)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sectionLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        return headerView
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: openFromSignUpRequest,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func initializeAnimator() {
        self.transitioningDelegate = self.animator
        self.animator.sourceViewController = self
        
        
        guard let parentVC = self.parentVC else { return }
        
        switch parentVC {
        case "ContactsVC":
            self.animator.parentVC = "unwindToContactsVC"
        case "GroupContactListVC":
            self.animator.parentVC = "unwindToGroupContactListView"
        default:
            return
        }
    }
    
    private func initializeViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.initializeAnimator()
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10))
        customView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = customView
    }
    
    private func loadDataSource() {
        let cmd = FetchContactDetailCommand()
        let store = UserDefaultsStore()
        let ver = store.loadContactsVer()
        cmd.lookupKey = self.lookupKey
        cmd.contactsVer = ver
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.infoDataSource = array
                self.tableView.reloadData()
            case .failure(let error):
                NSLog("error occurred: \(error)")
            }
        }
        cmd.execute()
    }
    
    private func createMapOptionsAlert(with address: Any?) -> UIAlertController? {
        
        guard let stringAddress = address as? String else { return nil }
        
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let copyAction = UIAlertAction(
            title: "Copy Address",
            style: .default,
            handler: { action in
                let pasteboard = UIPasteboard.general
                pasteboard.string = stringAddress
        })
        
        let openMapAction = UIAlertAction(
            title: "Open in Maps",
            style: .default,
            handler: { action in
                self.openMapForPlace(with: stringAddress)
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(copyAction)
        alertController.addAction(openMapAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func createPhoneOptionsAlert(with phone: Any?) -> UIAlertController? {
        guard let number = phone as? String else { return nil }
        
        let alertController = UIAlertController(
            title: nil,
            message: number,
            preferredStyle: .alert
        )
        
        let callAction = UIAlertAction(
            title: "Call",
            style: .default,
            handler: { action in
                let url = URL(string: "telprompt://\(number)")!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
        })
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(callAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func populate(_ cell: ContactInfoCell, with model: ContactInfoVOM) {
        cell.mapCoverView.isHidden = true
        cell.titleLabel.text = model.label
        cell.infoLabel.text = model.value
        //        cell.setShadowEffect()
        
        switch model.label {
        case "ADDRESS":
            cell.isUserInteractionEnabled = true
            cell.iconLabel.text = "\u{f2b9}"
            
            let address = model.value
            cell.initializeMapKit(with: address)
        case "PHONE":
            cell.isUserInteractionEnabled = true
            cell.iconLabel.text = "\u{f095}"
            
            let phoneNumberKit = PhoneNumberKit()
            if let parsedNumber = try? phoneNumberKit.parse(model.value) {
                let formattedNumber = phoneNumberKit.format(parsedNumber, toType: .national)
                cell.infoLabel.text = formattedNumber
            }
        case "DISTRICT":
            cell.iconLabel.text = "\u{f0f7}"
        case "GROUP":
            cell.iconLabel.text = "\u{f0c0}"
        case "BIRTHDAY":
            cell.iconLabel.text = "\u{f1fd}"
        default:
            break
        }
        
        //        if model.label == "address" {
        //            let address = model.value
        //            cell.initializeMapKit(with: address)
        //        }
    }
    
    private func populate(_ cell: ContactImageCell, with model: ContactInfoVOM) {
        cell.nameLabel.text = model.value
        
        if model.extra != "" {
            cell.smallNameLabel.text = model.extra
            cell.smallNameLabel.isHidden = false
        }
    }
    
    
    private func presentAlertForAddress(with address: Any?) {
        if let alert = createMapOptionsAlert(with: address) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentAlertForPhone(with phone: Any?) {
        if let number = phone as? String {
            let url = URL(string: "telprompt://\(number)")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        //        if let alert = createPhoneOptionsAlert(with: phone) {
        //            present(alert, animated: true, completion: nil)
        //        }
    }
    
    // MARK: IBAction Functions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        guard let parentVC = self.parentVC else { return }
        
        switch parentVC {
        case "ContactsVC":
            performSegue(withIdentifier: "unwindToContactsVC", sender: nil)
            self.animator.finish()
        case "GroupContactListVC":
            performSegue(withIdentifier: "unwindToGroupContactListView", sender: nil)
            self.animator.finish()
        default:
            return
        }
    }
    
    // MARK: Map Kit Functions
    
    private func openMapForPlace(with address:String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placeMarks, error) in
            if let error = error {
                NSLog("error occurred: \(error)")
            } else {
                guard
                    let placeMark = placeMarks?.last,
                    let latitude = placeMark.location?.coordinate.latitude,
                    let longitude = placeMark.location?.coordinate.longitude
                    else {
                        NSLog("error occurred")
                        return
                }
                
                let regionDistance:CLLocationDistance = 7500
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = address
                mapItem.openInMaps(launchOptions: options)
            }
        }
    }
    
    // MARK: Navigation Functions 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        self.animator.operationPresenting = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            self.animator.scrolledToTop = true
//            print("------------- scrolled to top")
        } else {
            self.animator.scrolledToTop = false
            
        }
        
        if self.animator.transitionStarted {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
}

extension UIView {
    
    func addContraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}

