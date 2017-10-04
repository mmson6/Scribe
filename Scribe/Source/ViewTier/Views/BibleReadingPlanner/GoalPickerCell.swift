//
//  GoalPickerCell.swift
//  Scribe
//
//  Created by Mikael Son on 10/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class GoalPickerCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
