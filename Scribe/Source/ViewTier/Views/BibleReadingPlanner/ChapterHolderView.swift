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
//            (self.chapterCount / 10 > 0) ? self.chapterCount / 10 : 1
        let paddingSpace = sectionInsets.left * (itemsPerRow - 1)
        let availableWidth = rect.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        if self.subviews.count <= 0 {
            for i in 0...byTen {
                let byOne = (i == byTen) ? self.chapterCount % 10 : 10
                if byOne != 0 {
                    for j in 1...byOne {
                        let numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: widthPerItem + 5, height: widthPerItem))
                        numberLabel.lineBreakMode = .byClipping
                        numberLabel.textAlignment = .center
                        numberLabel.font = UIFont.systemFont(ofSize: 10)
                        numberLabel.textColor = .darkGray
                        let horizontalPointer: CGFloat = ((widthPerItem + sectionInsets.left) * CGFloat(j-1))
                        let verticalPointer: CGFloat = ((widthPerItem + sectionInsets.bottom) * CGFloat(i))
                        //                    print(horizontalPointer)
                        numberLabel.center = CGPoint(x: widthPerItem/2 + horizontalPointer, y: widthPerItem/2 + verticalPointer)
                        
                        let circlePath = UIBezierPath(arcCenter: CGPoint(x: (widthPerItem/2) + 2.5, y: widthPerItem/2), radius: widthPerItem/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                        //                    let circlePath = UIBezierPath(arcCenter: CGPoint(x: widthPerItem/2 + horizontalPointer, y: widthPerItem/2 + verticalPointer), radius: widthPerItem/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = circlePath.cgPath
                        
                        //change the fill color
                        shapeLayer.fillColor = UIColor.clear.cgColor
                        //you can change the stroke color
                        shapeLayer.strokeColor = UIColor.lightGray.cgColor
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
                        
                        //                    numberLabel.center = shapeLayer.anchorPoint
                        numberLabel.layer.addSublayer(shapeLayer)
                        numberLabel.text = shapeLayer.name
                        self.addSubview(numberLabel)
                        //                    self.layer.addSublayer(shapeLayer)
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
//        let viewHeight = byTen > 0 ? ((widthPerItem * CGFloat(byTen + 1)) + (sectionInsets.bottom * CGFloat(byTen))) : widthPerItem
        self.delegate?.updateHeightConstraint(height: viewHeight)
    }
    
    
    func drawcircles() {
        print(self.frame.width)
        let paddingSpace = sectionInsets.left * (itemsPerRow - 1)
        let availableWidth = self.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        for i in 0...2 {
            for j in 0...9 {
                let horizontalPointer: CGFloat = ((widthPerItem + sectionInsets.left) * CGFloat(j))
                let verticalPointer: CGFloat = ((widthPerItem + sectionInsets.bottom) * CGFloat(i))
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: widthPerItem/2 + horizontalPointer, y: widthPerItem/2 + verticalPointer), radius: widthPerItem/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                
                //change the fill color
                shapeLayer.fillColor = UIColor.clear.cgColor
                //you can change the stroke color
                shapeLayer.strokeColor = UIColor.red.cgColor
                //you can change the line width
                shapeLayer.lineWidth = 1.0
                
                var y: Int
                if j+1 == 10 { y = 0 }
                else { y = j+1 }
                
                if i == 0 { shapeLayer.name = "\(y)" }
                else { shapeLayer.name = "\(i)\(y)" }
                
                self.layer.addSublayer(shapeLayer)
            }
            
        }
    }
    
    func updateCircle() {
        for subview in self.subviews {
//            print(subview.tag)
            
            let width = subview.frame.width
            UIView.animate(withDuration: 1.0, animations: {
                //                let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle: CGFloat(Double.pi * -0.5), endAngle:CGFloat(Double.pi * 0), clockwise: true)
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                
                //change the fill color
                shapeLayer.fillColor = UIColor.clear.cgColor
                //you can change the stroke color
                shapeLayer.strokeColor = UIColor.red.cgColor
                //you can change the line width
                shapeLayer.lineWidth = 1.0
                subview.layer.addSublayer(shapeLayer)
            })
            
        }
    }
}
