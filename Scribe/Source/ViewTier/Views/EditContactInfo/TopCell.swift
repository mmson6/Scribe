//
//  TopCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class TopCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setShadowEffect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Helper Functions
    
    public func setShadowEffect() {
        self.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.15
        self.layer.masksToBounds = false
        self.setNeedsLayout()
    }
    
}
