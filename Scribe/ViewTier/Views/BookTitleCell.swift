//
//  BookTitleCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/29/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class BookTitleCell: UICollectionViewCell {
    
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
    }
}
