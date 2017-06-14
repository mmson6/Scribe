//
//  ContactDetailVC.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import MapKit

import Firebase


public class ContactDetailVC: UITableViewController {
    
    public var lookupKey: Any?
    private var infoDataSource: [ContactInfoVOM] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.topDesignView.sendSubview(toBack: self.view)
        
//        self.navigationController?.navigationBar.tintColor = UIColor.scribeColorNavigationBlue
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.loadDataSource()
//        self.commonInit()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.tintColor = UIColor.scribeColorNavigationBlue
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil
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
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.infoDataSource[indexPath.row]
        switch model.label {
        case "address":
            self.presentAlertForAddress(with: model.value)
        case "phone":
            self.presentAlertForPhone(with: model.value)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.infoDataSource[indexPath.row]
        
        switch model.label {
        case "address":
            return 110
        case "name":
            return 220
        default:
            return 60
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.mapView.isHidden = true
        cell.subTitleLabel.text = model.label
        cell.infoLabel.text = model.value
        
        if model.label == "address" {
            let address = model.value
            cell.initializeMapKit(with: address)
        }
    }
    
    private func populate(_ cell: ContactImageCell, with model: ContactInfoVOM) {
        cell.nameLabel.text = model.value
    }

    
    private func presentAlertForAddress(with address: Any?) {
        if let alert = createMapOptionsAlert(with: address) {
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func presentAlertForPhone(with phone: Any?) {
        if let alert = createPhoneOptionsAlert(with: phone) {
            present(alert, animated: true, completion: nil)
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
}
