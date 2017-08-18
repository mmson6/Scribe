//
//  BirthdayInfoCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit


class BirthdayInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.commonInit()
    }

    // MARK: Helper Functions
    
//    private func commonInit() {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        let stringDate = dateFormatter.string(from: date)
//        self.birthdayLabel.text = stringDate
//    }
}
