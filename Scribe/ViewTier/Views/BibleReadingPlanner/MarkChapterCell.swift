//
//  MarkChapterCell.swift
//  Scribe
//
//  Created by Mikael Son on 9/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class MarkChapterCell: UICollectionViewCell {
    
    @IBOutlet weak var countBackgroundView: UIView!
    @IBOutlet weak var selectBackgroundView: UIView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    var selectionStatus: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.selectionStatus = false
        self.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
    }
    
    func commonInit() {
        self.initializeLayout()
    }
    
    private func initializeLayout() {
        self.layer.cornerRadius = 21
        
        self.countBackgroundView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        self.countBackgroundView.layer.borderWidth = 2
        self.countBackgroundView.layer.cornerRadius = (self.frame.width - 6) / 2
        
        self.selectBackgroundView.layer.cornerRadius = (self.frame.width - 13) / 2
        
    }
    
    // MARK: Helper Functions
    
    func drawCellRect(with plannerDataVOM: PlannerDataVOM?, index: Int) {
        guard
            let json = plannerDataVOM?.chaptersReadCount,
            let count = json["\(index)"] as? Int
        else {
            return
        }
        
        let width = self.frame.width
        
        let startAngle = CGFloat(Double.pi * 3 / 2)
        var endAngle: CGFloat = 0
        if count == 0 {
            self.countBackgroundView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
            
        } else if count > 0 {
            self.countBackgroundView.layer.borderColor = UIColor.rgb(red: 132, green: 185, blue: 144).cgColor
        }
        if count > 1 {
            let countValue = CGFloat(count - 1)
    
            endAngle = startAngle + (CGFloat(Double.pi / 2) * countValue)
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: (width/2) - 3, startAngle: startAngle, endAngle:endAngle, clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.rgb(red: 71, green: 152, blue: 105).cgColor
            
            //you can change the line width
            shapeLayer.lineWidth = 4
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    func updateCell(with index: Int, min: Int, max: Int, and map: JSONObject) {
        self.chapterNumberLabel.text = "\(index+1)"
        
        if map["\(index)"] != nil {
            self.didSelect()
        } else {
            if index > min && index < max {
                self.selectBackgroundView.backgroundColor = UIColor.Scribe.ReadingPlanner.bookChapterPossiblySelectedGreenColor
                self.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
            } else {
                self.selectBackgroundView.backgroundColor = .white
                self.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
            }
        }
    }
    
    func didDeselect() {
        self.selectBackgroundView.backgroundColor = .white
        self.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
    }
    
    func didSelect() {
        self.selectBackgroundView.backgroundColor = UIColor.Scribe.ReadingPlanner.bookChapterSelectedGreenColor
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
