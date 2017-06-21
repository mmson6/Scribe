//
//  ContactInfoCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ContactInfoCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapCoverView: UIView!
    @IBOutlet weak var cellLayoutView: UIView!
    
    // MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.mapCoverView.isUserInteractionEnabled = false
        self.titleLabel.textColor = UIColor.scribePintInfoTitleColor
        self.backgroundColor = UIColor.scribeColorCDCellBackground
        self.iconLabel.textColor = UIColor.scribePintInfoTitleColor
    }
    
    public func setShadowEffect() {
        self.cellLayoutView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.cellLayoutView.layer.shadowColor = UIColor.black.cgColor
        self.cellLayoutView.layer.shadowRadius = 3
        self.cellLayoutView.layer.shadowOpacity = 0.25
        self.cellLayoutView.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        self.mapView.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    // MARK: Custom Functions
    
    public func initializeMapKit(with address: String) {
        if self.frame.width > 375 {
            self.mapCoverView.isHidden = false
            
            let locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
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
                    let spanX = 0.00725
                    let spanY = 0.00725
                    var region = MKCoordinateRegion()
                    region.center.latitude = latitude
                    region.center.longitude = longitude
                    region.span = MKCoordinateSpanMake(spanX, spanY)
                    self.mapView.setRegion(region, animated: false)
                    self.mapView.addAnnotation(MKPlacemark(placemark: placeMark))
                }
            }
            
            self.mapView.isHidden = false
            self.mapView.layer.cornerRadius = 5
            self.mapView.layer.borderWidth = 1
            self.mapView.layer.borderColor = UIColor.scribeDarkGray.cgColor
        } else {
            self.mapCoverView.isHidden = true
        }
    }
}
