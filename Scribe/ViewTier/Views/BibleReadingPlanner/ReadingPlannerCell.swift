//
//  ReadingPlannerCell.swift
//  Scribe
//
//  Created by Mikael Son on 10/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ReadingPlannerCell: UITableViewCell {

    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var untilDateLabel: UILabel!
    @IBOutlet weak var readingGoalLabel: UILabel!
    @IBOutlet weak var progressDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
