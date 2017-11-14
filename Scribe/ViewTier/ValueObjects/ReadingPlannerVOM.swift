//
//  ReadingPlannerVOM.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct ReadingPlannerVOM {
    public let plannerID: Int
    public let plannerGoal: PlannerGoalVOM
    public let plannerData: [PlannerDataVOM]?
    public var selected: Bool
    
    private let originalJSON: JSONObject
    
    public init(id: Int, goal: PlannerGoalVOM, data: [PlannerDataVOM], selected: Bool) {
        self.plannerID = id
        self.plannerGoal = goal
        self.plannerData = data
        self.selected = selected
        
        var json = JSONObject()
        json["plannerID"] = id
        json["plannerGoal"] = goal.asJSON()
        json["plannerData"] = data.map({ model -> JSONObject in
            return model.asJSON()
        })
        json["selected"] = selected
        self.originalJSON = json
    }
    
    public init(model: ReadingPlannerDM) {
        self.plannerID = model.plannerID
        self.plannerGoal = model.plannerGoal
        self.plannerData = model.plannerData
        self.selected = model.selected
        
        var json = JSONObject()
        json["plannerID"] = model.plannerID
        json["plannerGoal"] = model.plannerGoal.asJSON()
        
        if let plannerData = model.plannerData {
            json["plannerData"] = plannerData.map({ model -> JSONObject in
                return model.asJSON()
            })
        }
        json["selected"] = model.selected
        self.originalJSON = json
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
