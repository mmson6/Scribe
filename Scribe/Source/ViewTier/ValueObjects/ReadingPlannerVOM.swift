//
//  ReadingPlannerVOM.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct ReadingPlannerVOM {
    public let plannerID: String
    public let plannerGoal: PlannerGoalVOM
    public let plannerData: [PlannerDataVOM]?
    public let selected: Bool
    
    public init(model: ReadingPlannerDM) {
        self.plannerID = model.plannerID
        self.plannerGoal = model.plannerGoal
        self.plannerData = model.plannerData
        self.selected = model.selected
    }
//
//    public init(bookName: String, chaptersReadCount: JSONObject) {
//        self.bookName = bookName
//        self.chaptersReadCount = chaptersReadCount
//    }
}
