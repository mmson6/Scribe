//
//  ChapterCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/29/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ChapterCell: UICollectionViewCell {
    
    @IBOutlet weak var chapterNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 11
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
}
