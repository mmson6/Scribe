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
        self.chapterNumberLabel.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
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
    
    func didDeselect() {
        self.selectionStatus = !self.selectionStatus
        self.selectBackgroundView.backgroundColor = .white
        self.chapterNumberLabel.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
    }
    
    func didSelect() {
        self.selectionStatus = !self.selectionStatus
        self.selectBackgroundView.backgroundColor = .bookChapterSelectedRedColor
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
//            self.highlightView.backgroundColor = .white
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
    
    func highlightPossibleSelection() {
        print("\(self.selectionStatus)")
        if !self.selectionStatus {
            self.selectBackgroundView.backgroundColor = .bookChapterPossiblySelectedRedColor
            self.chapterNumberLabel.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        } else {
            self.didSelect()
        }
    }
    
    func unhighlightPossibleSelection() {
//        print("\(self.selectionStatus)")
        if !self.selectionStatus {
            self.selectBackgroundView.backgroundColor = .white
        } else {
            self.didSelect()
        }
    }
}
