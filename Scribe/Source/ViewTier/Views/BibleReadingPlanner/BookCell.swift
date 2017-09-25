//
//  BookCell.swift
//  Scribe
//
//  Created by Mikael Son on 9/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell, ChapterHolderViewDelegate {
    
    @IBOutlet weak var korNameLabel: UILabel!
    @IBOutlet weak var engNameLabel: UILabel!
    @IBOutlet weak var tapAnimationView: UIView!
    @IBOutlet weak var titleLayoutView: UIView!
    @IBOutlet weak var chapterLayoutView: UIView!
    @IBOutlet weak var chapterHolderView: ChapterHolderView!
    @IBOutlet weak var chapterHolderViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.chapterHolderView.delegate = self
        
        // Initialization code
        self.commonInit()
    }
    
    override func prepareForReuse() {
        for view in self.chapterHolderView.subviews {
            view.removeFromSuperview()
        }
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateHeightConstraint(height: CGFloat) {
        self.chapterHolderViewHeightConstraint.constant = height
    }
    
    func populate(with model: BibleVOM, and counter: ChapterCounterVOM) {
        self.chapterHolderView.chapterCount = model.chapters
        self.engNameLabel.text = model.engName
        self.korNameLabel.text = model.korName
        
        self.chapterHolderView.updateChapterCount(with: counter)
    }
    
    private func animateTap() {
        self.tapAnimationView.alpha = 0.7
        UIView.animate(withDuration: 0.5) {
        self.tapAnimationView.alpha = 0
        }
    }
    
}
