//
//  TopPlanTrackerView.swift
//  Scribe
//
//  Created by Mikael Son on 10/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class TopPlanTrackerView: UIView {

    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    public func initAttributes() {
        self.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.65)
        
        self.recentLabel.textColor = UIColor(white: 1, alpha: 0.95)
        self.averageLabel.textColor = UIColor.rgb(red: 211, green: 251, blue: 206)
        
        self.recentLabel.font = UIFont.systemFont(ofSize: 13, weight: 0.4)
        self.averageLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.3)
    }
    
    public func update(with model: PlannerGoalsVOM, and plannerDataSource: [PlannerDataVOM]) {
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
        
        
        // Update Average Read Per Days Label
        
        let daysLeft = (Double(totalDays) - Double(daysElapsed))
        
        let totalChapters = (model.OTGoal * totalOTChapters) + (model.NTGoal * totalNTChapters)
        var totalChaptersRead = 0
        for (index, x) in plannerDataSource.enumerated() {
            let isOT = index < 39
            for (_, value) in x.chaptersReadCount {
                if let intVal = value as? Int {
                    if isOT {
                        totalChaptersRead = intVal > model.OTGoal ?
                            totalChaptersRead + model.OTGoal : totalChaptersRead + intVal
                    } else {
                        totalChaptersRead = intVal > model.NTGoal ?
                            totalChaptersRead + model.NTGoal : totalChaptersRead + intVal
                    }
                }
            }
        }
        
        let chaptersLeft = (Double(totalChapters) - Double(totalChaptersRead))
        let average = chaptersLeft / daysLeft
        
        self.averageLabel.text = "You need to read \(Int(floor(average)))~\(Int(round(average))) chapters per day. (\(String(format: "%.1f", average)) chapters)"
    }
}
