//
//  MarkChapterCell.swift
//  Scribe
//
//  Created by Mikael Son on 9/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class MarkChapterCell: UICollectionViewCell {
    
    @IBOutlet weak var selectBackgroundView: UIView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    var selectionStatus: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeLayout()
        
    }
    
    override func prepareForReuse() {
        self.selectionStatus = false
        self.chapterNumberLabel.textColor = .bookChapterTextColor
    }
    
    private func initializeLayout() {
        self.layer.cornerRadius = 21
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
        self.selectBackgroundView.layer.cornerRadius = 18
    }
    
    func commonInit() {
        self.selectionStatus = true
    }
    
    // MARK: Helper Functions
    
    func updateCell(with index: Int, min: Int, max: Int, and map: [Int: Bool]) {
        self.chapterNumberLabel.text = "\(index+1)"
        
        if map[index] != nil {
            self.didSelect()
        } else {
            if index > min && index < max {
                self.selectBackgroundView.backgroundColor = .bookChapterPossiblySelectedGreenColor
                self.chapterNumberLabel.textColor = .bookChapterTextColor
            } else {
                self.selectBackgroundView.backgroundColor = .white
                self.chapterNumberLabel.textColor = .bookChapterTextColor
            }
        }
    }
    
    func didDeselect() {
        self.selectBackgroundView.backgroundColor = .white
        self.chapterNumberLabel.textColor = .bookChapterTextColor
    }
    
    func didSelect() {
        self.selectBackgroundView.backgroundColor = .bookChapterSelectedGreenColor
        self.chapterNumberLabel.textColor = .white
    }
    
    func cellTapped() {
        if self.selectionStatus {
            self.didSelect()
        } else {
            self.didDeselect()
        }
    }
    
    func didHighlight() {
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 0.5
            self.highlightView.alpha = 0.35
        }
    }
    
    func didUnhighlight() {
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1
            self.highlightView.alpha = 0
        }
    }
}
