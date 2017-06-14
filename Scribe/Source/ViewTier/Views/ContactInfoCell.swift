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

    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapCoverView: UIView!
    
    // MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.mapCoverView.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        self.mapView.isHidden = true
    }
    
    // MARK: Custom Functions
    
    public func initializeMapKit(with address: String) {
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
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(MKPlacemark(placemark: placeMark))
            }
        }
        
        self.mapView.isHidden = false
        self.mapView.layer.cornerRadius = 5
    }
}
