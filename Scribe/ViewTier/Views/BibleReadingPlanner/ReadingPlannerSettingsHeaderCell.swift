//
//  ReadingPlannerSettingsHeaderCell.swift
//  Scribe
//
//  Created by Mikael Son on 9/25/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ReadingPlannerSettingsHeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTextLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.separatorView.isHidden = false
    }
}
