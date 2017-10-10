//
//  BottomPlanTrackerView.swift
//  Scribe
//
//  Created by Mikael Son on 10/5/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class BottomPlanTrackerView: UIView {

    @IBOutlet weak var targetPeriodLabel: UILabel!
    @IBOutlet weak var daysElapsedLabel: UILabel!
    @IBOutlet weak var chaptersReadLabel: UILabel!
    @IBOutlet weak var versesReadLabel: UILabel!
    
    @IBOutlet weak var dayTrackOuterView: UIView!
    @IBOutlet weak var dayTrackInnerView: UIView!
    @IBOutlet weak var chapterTrackOuterView: UIView!
    @IBOutlet weak var chapterTrackInnerView: UIView!
    @IBOutlet weak var verseTrackOuterView: UIView!
    @IBOutlet weak var verseTrackInnerView: UIView!
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var dayTrackLabel: UILabel!
    @IBOutlet weak var chapterTrackLabel: UILabel!
    @IBOutlet weak var verseTrackLabel: UILabel!
    
    @IBOutlet weak var dayPercentageLabel: UILabel!
    @IBOutlet weak var chapterPercentageLabel: UILabel!
    @IBOutlet weak var versePercentageLabel: UILabel!
    @IBOutlet weak var dailyReadingLabel: UILabel!
    
    @IBOutlet weak var chapterTrackerInnerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayTrackerInnterViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var verseTrackerInnerViewWidthConstraint: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public func initAttributes() {
        self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.70)
        self.layer.cornerRadius = 10
        
        // Set text color
        self.targetPeriodLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.daysElapsedLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.chaptersReadLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.versesReadLabel.textColor = UIColor(white: 1, alpha: 0.95)
        
        self.targetLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.dayTrackLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.chapterTrackLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.verseTrackLabel.textColor = UIColor(white: 1, alpha: 0.95)
        
        self.dayPercentageLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.chapterPercentageLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.versePercentageLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.dailyReadingLabel.textColor = UIColor(white: 1, alpha: 0.95)
        
        // Set font and size
        self.targetPeriodLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
        self.daysElapsedLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
        self.chaptersReadLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
        self.versesReadLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
        self.targetLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
        self.dailyReadingLabel.font = UIFont.systemFont(ofSize: 11, weight: 0.3)
        
        // Set Corner Radius
        self.dayTrackOuterView.layer.cornerRadius = self.dayTrackOuterView.frame.height / 2
        self.dayTrackInnerView.layer.cornerRadius = self.dayTrackInnerView.frame.height / 2
        self.chapterTrackOuterView.layer.cornerRadius = self.chapterTrackOuterView.frame.height / 2
        self.chapterTrackInnerView.layer.cornerRadius = self.chapterTrackInnerView.frame.height / 2
        self.verseTrackOuterView.layer.cornerRadius = self.verseTrackOuterView.frame.height / 2
        self.verseTrackInnerView.layer.cornerRadius = self.verseTrackInnerView.frame.height / 2
        
        // Set background color
        self.dayTrackOuterView.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        self.chapterTrackOuterView.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        self.verseTrackOuterView.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        self.dayTrackInnerView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        self.chapterTrackInnerView.backgroundColor = UIColor.scribeDesignTwoBlue
        self.verseTrackInnerView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        self.dayTrackOuterView.layer.borderColor = UIColor.black.cgColor
        self.chapterTrackOuterView.layer.borderColor = UIColor.black.cgColor
        self.verseTrackOuterView.layer.borderColor = UIColor.black.cgColor
        
        self.dayTrackOuterView.layer.borderWidth = 1
        self.chapterTrackOuterView.layer.borderWidth = 1
        self.verseTrackOuterView.layer.borderWidth = 1
    }
    
    public func update(with model: PlannerGoalsVOM, and plannerDataSource: [PlannerDataVOM], and bibleDataSource: [BibleVOM]) {
        var startDateString = ""
        var endDateString = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        guard
            let startDate = dateFormatter.date(from: model.startDate),
            let endDate = dateFormatter.date(from: model.endDate),
            let totalDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day,
            let daysElapsed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day
            else {
                return
        }
        
        dateFormatter.dateFormat = "yyyy.MM.d"
        startDateString = dateFormatter.string(from: startDate)
        endDateString = dateFormatter.string(from: endDate)
        
        
        if model.OTGoal < 1 {
            self.targetLabel.text = "\(startDateString) ~ \(endDateString) ► NT \(model.NTGoal)"
        } else if model.NTGoal < 1 {
            self.targetLabel.text = "\(startDateString) ~ \(endDateString) ► OT \(model.OTGoal)"
        } else {
            self.targetLabel.text = "\(startDateString) ~ \(endDateString) ► OT\(model.OTGoal) + NT\(model.NTGoal)"
        }
        
        // Update Elapsed Days Tracker Bars
        self.dayTrackLabel.text = "\(daysElapsed) / \(totalDays)"
        let dayProportion = (CGFloat(daysElapsed) / CGFloat(totalDays))
        var multiplier = dayProportion * 0.985
        self.dayTrackerInnterViewWidthConstraint.constant = self.dayTrackOuterView.frame.width * multiplier
        
        // Update day percentage
        self.dayPercentageLabel.text = "\(String(format: "%.2f", multiplier * 100))%"
        
        
        // Set chapter and verse data
        var totalChaptersRead = 0
        var totalVersesRead = 0
        for (bookIndex, x) in plannerDataSource.enumerated() {
            let isOT = bookIndex < 39
            for (chapter, count) in x.chaptersReadCount {
                if let intCount = count as? Int {
                    let bibleVOM = bibleDataSource[bookIndex]
                    guard let intChapter = Int(chapter) else { return }
                    let verseCount = bibleVOM.versesPerChapter[intChapter]
                    
                    if isOT {
                        if intCount > model.OTGoal {
                            totalChaptersRead = totalChaptersRead + model.OTGoal
                            totalVersesRead = totalVersesRead + (verseCount * model.OTGoal)
                            
                        } else {
                            totalChaptersRead = totalChaptersRead + intCount
                            totalVersesRead = totalVersesRead + (verseCount * intCount)
                        }
                    } else {
                        if intCount > model.NTGoal {
                            totalChaptersRead = totalChaptersRead + model.NTGoal
                            totalVersesRead = totalVersesRead + (verseCount * model.NTGoal)
                        } else {
                            totalChaptersRead = totalChaptersRead + intCount
                            totalVersesRead = totalVersesRead + (verseCount * intCount)
                        }
                    }
                }
            }
        }
        
        let totalChapters = (model.OTGoal * totalOTChapters) + (model.NTGoal * totalNTChapters)
        let totalVerses = (model.OTGoal * totalOTVerses) + (model.NTGoal * totalNTVerses)
        self.chapterTrackLabel.text = "\(totalChaptersRead) / \(totalChapters)"
        self.verseTrackLabel.text = "\(totalVersesRead) / \(totalVerses)"
        
        // Update Chapter Tracker Bars
        let chapterProportion = (CGFloat(totalChaptersRead) / CGFloat(totalChapters))
        multiplier = chapterProportion * 0.985
        self.chapterTrackerInnerViewWidthConstraint.constant = self.chapterTrackOuterView.frame.width * multiplier
        
        // Update chapter percentage
        self.chapterPercentageLabel.text = "\(String(format: "%.2f", multiplier * 100))%"
        
        // Update Daily Average Reading
        let chaptersLeft = (Double(totalChapters) - Double(totalChaptersRead))
        let daysLeft = (Double(totalDays) - Double(daysElapsed))
        let average = chaptersLeft / daysLeft
        self.dailyReadingLabel.text = "Daily \(String(format: "%.1f", average)) chpt"
        
        // Update Verse Tracker Bars
        let verseProportion = (CGFloat(totalVersesRead) / CGFloat(totalVerses))
        multiplier = verseProportion * 0.985
        self.verseTrackerInnerViewWidthConstraint.constant = self.verseTrackOuterView.frame.width * multiplier
        
        // Update verse percentage
        self.versePercentageLabel.text = "\(String(format: "%.2f", multiplier * 100))%"
        
        UIView.animate(withDuration: 1) {
            self.chapterTrackOuterView.layoutIfNeeded()
            self.dayTrackOuterView.layoutIfNeeded()
            self.verseTrackOuterView.layoutIfNeeded()
        }
    }
}
