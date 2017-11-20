//
//  TopPlanTrackerView.swift
//  Scribe
//
//  Created by Mikael Son on 10/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class TopPlanTrackerView: UIView {

    var selectedPlannerID: Int = 0
    
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    public func initAttributes() {
        self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.65)
        
        self.recentLabel.textColor = UIColor(white: 1, alpha: 0.95)
//        self.averageLabel.textColor = UIColor.rgb(red: 211, green: 251, blue: 206)
        self.averageLabel.textColor = UIColor.rgb(red: 203, green: 204, blue: 248)
        
        self.recentLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(rawValue: 0.4))
        self.averageLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.3))
    }
    
    public func update(with model: PlannerGoalVOM, and plannerDataSource: [PlannerDataVOM]) {
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
        
        if daysLeft == 0 {
            self.recentLabel.text = "Your word is a lamp to my feet, And a light to my path."
//            self.averageLabel.text = "Period ended. You read average \(String(format: "%.1f", (totalChapters / totalDays))) chapters per day."
            self.averageLabel.text = "Period ended. You read average \(totalChapters / totalDays) chapters per day."
            self.averageLabel.textColor = UIColor.rgb(red: 190, green: 190, blue: 190)
        } else {
            if Int(floor(average)) == Int(round(average)) {
                self.averageLabel.text = "You need to read \(Int(floor(average)))~\(Int(round(average)) + 1) chapters per day. (\(String(format: "%.1f", average)) chapters)"
            } else {
                self.averageLabel.text = "You need to read \(Int(floor(average)))~\(Int(round(average))) chapters per day. (\(String(format: "%.1f", average)) chapters)"
            }
            self.fetchRecentReadingActivity()
        }
    }
    
    private func fetchRecentReadingActivity() {
        let cmd = FetchPlannerLastMarkActivityCommand()
        cmd.plannerID = self.selectedPlannerID
        cmd.onCompletion { result in
            switch result {
            case .success(let model):
                print(model)
                self.updateRecentReadingActivity(with: model)
            case .failure:
                self.recentLabel.text = "Your word is a lamp to my feet, And a light to my path."
            }
        }
        cmd.execute()
    }
    
    private func updateRecentReadingActivity(with model: PlannerActivityVOM) {
        // Present cells in descending order - lastest acitivity top
        if model.isConsecutive {
            self.recentLabel.text = "Recently you read \(model.bookName) \(model.min + 1)-\(model.max + 1)"
        } else {
            self.recentLabel.text = "Recently you read \(model.bookName) \(model.min + 1)"
        }
    }
}
