//
//  SectionHeaderCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class SectionHeaderCell: UITableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Helper Functions
    
//    private func commonInit() {
//        self.backgroundColor = UIColor.rgb(red: 240, green: 244, blue: 244)
//    }
}
