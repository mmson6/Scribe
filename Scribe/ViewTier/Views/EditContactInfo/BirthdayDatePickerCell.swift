//
//  BirthdayDatePickerCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class BirthdayDatePickerCell: UITableViewCell {
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Helper Functions
//    
//    internal func dateChanged(_ sender: UIDatePicker) {
//        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
//        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
//            print("\(day) \(month) \(year)")
//        }
//    }
}
