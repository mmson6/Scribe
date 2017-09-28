//
//  ChapterHolderView.swift
//  Scribe
//
//  Created by Mikael Son on 9/6/17.
//  Copyright © 2017 SPR Consulting. All rights reserved.
//

import UIKit

fileprivate let itemsPerRow: CGFloat = 10
fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

protocol ChapterHolderViewDelegate: class {
    func updateHeightConstraint(height: CGFloat)
}

class ChapterHolderView: UIView {
    
    weak var delegate: ChapterHolderViewDelegate?
    
    var chapterCount: Int = 0 {
        didSet {
            //            print("count is set")
            if let window = UIApplication.shared.keyWindow {
                let width = window.frame.width * 0.7
                self.draw(CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width-20, height: width-26))
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let byTen = self.chapterCount / 10
        let paddingSpace = sectionInsets.left * (itemsPerRow - 1)
        let availableWidth = rect.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if self.subviews.count <= 0 {
            for i in 0...byTen {
                let byOne = (i == byTen) ? self.chapterCount % 10 : 10
                if byOne != 0 {
                    for j in 1...byOne {
                        let horizontalPointer: CGFloat = ((widthPerItem + sectionInsets.left) * CGFloat(j-1))
                        let verticalPointer: CGFloat = ((widthPerItem + sectionInsets.bottom) * CGFloat(i))
                        
                        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: widthPerItem, height: widthPerItem))
                        backgroundView.center = CGPoint(x: widthPerItem/2 + horizontalPointer, y: widthPerItem/2 + verticalPointer)
                        backgroundView.layer.cornerRadius = backgroundView.frame.width / 2
                        
                        let numberLabel = UILabel(frame: CGRect(x: -2.5, y: 0, width: widthPerItem + 5, height: widthPerItem))
                        numberLabel.lineBreakMode = .byClipping
                        numberLabel.textAlignment = .center
                        numberLabel.font = UIFont.systemFont(ofSize: 10)
                        numberLabel.textColor = UIColor.rgb(red: 110, green: 110, blue: 110)
                        numberLabel.backgroundColor = .clear
                        
                        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (widthPerItem/2) + 2.5, y: widthPerItem/2), radius: widthPerItem/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = circlePath.cgPath
                        
                        //change the fill color
                        shapeLayer.fillColor = UIColor.clear.cgColor
                        //you can change the stroke color
                        shapeLayer.strokeColor = UIColor.rgb(red: 210, green: 210, blue: 210).cgColor
                        //you can change the line width
                        shapeLayer.lineWidth = 1.0
                        
                        var y: Int
                        var x: Int = i
                        if j == 10 { y = 0; x += 1 }
                        else { y = j }
                        
                        
                        if i == 0 && j != 10 {
                            shapeLayer.name = "\(y)"
                            if let tag = Int("\(y)") {
                                numberLabel.tag = tag
                            }
                        }
                        else {
                            shapeLayer.name = "\(x)\(y)"
                            if let tag = Int("\(x)\(y)") {
                                numberLabel.tag = tag
                            }
                        }
                        
                        numberLabel.layer.addSublayer(shapeLayer)
                        numberLabel.text = shapeLayer.name
                    
                        backgroundView.addSubview(numberLabel)
                        self.addSubview(backgroundView)
                    }
                }
            }
        }
        
        var viewHeight: CGFloat = 0
        if byTen > 0 {
            if self.chapterCount % 10 > 0 {
                viewHeight = (widthPerItem * CGFloat(byTen + 1)) + (sectionInsets.bottom * CGFloat(byTen))
                
            } else {
                viewHeight = (widthPerItem * CGFloat(byTen)) + (sectionInsets.bottom * CGFloat(byTen - 1))
            }
        } else {
            viewHeight = widthPerItem
        }
        
        self.delegate?.updateHeightConstraint(height: viewHeight)
    }
    
    func updateChapterCount(with counter: PlannerDataVOM) {
        let json = counter.chaptersReadCount
        for (key, value) in json {
//        for (i, count) in counterData.enumerated() {
            guard
                let count = value as? Int,
                let i = Int(key)
            else {
                return
            }

            let subView = self.subviews[i]
            let width = subView.frame.width
            
            let startAngle = CGFloat(Double.pi * 3 / 2)
            var endAngle: CGFloat = 0
            if count > 0 {
                endAngle = startAngle + (CGFloat(Double.pi / 2) * 4)
                
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle: startAngle, endAngle:endAngle, clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                
                //change the fill color
                shapeLayer.fillColor = UIColor.clear.cgColor

                //you can change the stroke color
//                shapeLayer.strokeColor = UIColor.rgb(red: 92, green: 160, blue: 102).cgColor
                shapeLayer.strokeColor = UIColor.rgb(red: 143, green: 203, blue: 160).cgColor
                

                //you can change the line width
                shapeLayer.lineWidth = 1.0
                subView.layer.addSublayer(shapeLayer)
                
                // Add background color to chapters read at least once
                subView.backgroundColor = UIColor.rgb(red: 234, green: 255, blue: 247)
            }
            if count > 1 {
                let countValue = CGFloat(count - 1)
                endAngle = startAngle + (CGFloat(Double.pi / 2) * countValue)
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: (width/2) + 1, startAngle: startAngle, endAngle:endAngle, clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                
                //change the fill color
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                //you can change the stroke color
                shapeLayer.strokeColor = UIColor.rgb(red: 71, green: 152, blue: 105).cgColor

                //you can change the line width
                shapeLayer.lineWidth = 2.5
                subView.layer.addSublayer(shapeLayer)
                
                // Add background color to chapters read more than once
                subView.backgroundColor = UIColor.rgb(red: 224, green: 248, blue: 237)
            }
        }
    }
}
