//
//  ChurchServiceCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ChurchServiceCell: UITableViewCell {

    public var buttonSelected = false
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        let image = self.checkButton.currentImage?.withRenderingMode(.alwaysTemplate)
        self.checkButton.setImage(image, for: .normal)
    }
    
    internal func animateSelected() {
        let scaleGrow = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.setSelectedLayerAttributes()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.checkButton.transform = scaleGrow
                self.checkButton.tintColor = UIColor.Scribe.Design2.green
            }, completion: { (_) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.checkButton.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    internal func animateDeselected() {
        let scaleShrink = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.setUnselectedLayerAttributes()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.checkButton.transform = scaleShrink
                self.checkButton.tintColor = UIColor.rgb(red: 235, green: 235, blue: 235)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.checkButton.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func setSelectedLayerAttributes() {
        let image = UIImage(named: "check_icon_filled_500")?.withRenderingMode(.alwaysTemplate)
        self.checkButton.setImage(image, for: .normal)
        self.checkButton.tintColor = UIColor.Scribe.Design2.green
        self.checkButton.layer.borderWidth = 0
    }
    
    func setUnselectedLayerAttributes() {
        self.checkButton.setImage(nil, for: .normal)
        self.checkButton.layer.borderWidth = 2
        self.checkButton.layer.borderColor = UIColor.rgb(red: 235, green: 235, blue: 235).cgColor
        self.checkButton.layer.cornerRadius = self.checkButton.frame.width / 2
    }
    
    // MARK: IBAction Functions
    
}
