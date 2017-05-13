//
//  ContactInfoCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactInfoCell: UITableViewCell {

    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    internal func populate(with model: ContactVO) {
        self.subTitleLabel.text = "Name"
        self.infoLabel.text = model.name
    }
}
