//
//  ContactDetailVC.swift
//  Scribe
//
//  Created by Mikael Son on 7/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import MapKit


class ContactDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    public var lookupKey: Any?
    public var parentVC: String?
    private var infoDataSource: [ContactInfoVOM] = []
    
    var interactor:Interactor? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(ContactDetailVC.handleGesture(_:)))
        
        self.tableView.backgroundColor = UIColor.white
//        self.tableView.separatorStyle = .none
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.estimatedRowHeight = 60
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10))
        customView.backgroundColor = UIColor.white
        self.tableView.tableFooterView = customView
        
        self.loadDataSource()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.barTintColor = UIColor.scribeColorGroup7
        self.navigationController?.navigationBar.tintColor = UIColor.scribeColorCDNavBarBackground
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        //        UIView.animate(withDuration: 0.1, animations: {
        //            self.navigationController?.navigationBar.barTintColor = UIColor.white
        //            self.navigationController?.navigationBar.layoutIfNeeded()
        //        })
        
        self.navigationController?.navigationBar.tintColor = UIColor.scribeDarkGray
        //        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        //        self.navigationController?.navigationBar.shadowImage = nil
    }
    // MARK: Private Funcitons
    
    private func loadDataSource() {
        let cmd = FetchContactDetailCommand()
        cmd.lookupKey = self.lookupKey
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
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.infoDataSource[indexPath.row]
        
        switch indexPath.row {
        case 0:
            //            ContactImageCell
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactImageCell", for: indexPath) as? ContactImageCell
                else {
                    return UITableViewCell()
            }
            self.populate(cell, with: model)
            return cell
            
        default:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoCell", for: indexPath) as? ContactInfoCell
                else {
                    return UITableViewCell()
            }
            self.populate(cell, with: model)
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.infoDataSource[indexPath.row]
        
        switch model.label {
        case "NAME":
            return 300
        case "ADDRESS":
            return 110
        default:
            return 82
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoDataSource.count
    }
    
    
    // MARK: Helper Functions
    
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
        case "DISTRICT":
            cell.iconLabel.text = "\u{f0f7}"
        case "GROUP":
            cell.iconLabel.text = "\u{f0c0}"
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
            present(alert, animated: true, completion: nil)
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
        case "ContactListVC":
            performSegue(withIdentifier: "unwindToContactCoordinator", sender: nil)
        case "GroupContactListVC":
            performSegue(withIdentifier: "unwindToGroupContactListView", sender: nil)
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
    
    // MARK: Dismiss Animator Functions
    
    // Refactoring the progress calculation.
    // In the case of dragging downward, pulling down 50, and the screen height is 500, results in 0.10
    func progressAlongAxis(_ pointOnAxis: CGFloat, axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
    
        let percentThreshold:CGFloat = 0.15
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        // using the helper method
        let progress = progressAlongAxis(translation.y, axisLength: view.bounds.height)
        
        guard
            let interactor = interactor,
            let originView = sender.view
            else {
                return
        }
        
        let velocity = sender.velocity(in: self.view).y
        
        // Only let the table view dismiss the modal only if we're at the top.
        // If the user is in the middle of the table, let him scroll.
        switch originView {
        case view:
            break
        case tableView:
            if tableView.contentOffset.y > 0 {
                return
            }
        default:
            break
        }
        
        switch sender.state {
        case .began:
            print(1)
            interactor.hasStarted = true
            
        case .changed:
            print(2)
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            print(3)
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            print(4)
            interactor.hasStarted = false
            if progress > percentThreshold || velocity > 1500.0 {
                self.dismiss(animated: true, completion: nil)
            }
            
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
}

