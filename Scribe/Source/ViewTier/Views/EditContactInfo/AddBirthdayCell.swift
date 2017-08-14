//
//  AddBirthdayCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class AddBirthdayCell: UITableViewCell {
    
    @IBOutlet weak var addIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        let image = self.addIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.addIconImageView.image = image
        self.addIconImageView.tintColor = UIColor.scribeDesignTwoGreen
    }
}
