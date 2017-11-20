//
//  ReadingPlannerDM.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct ReadingPlannerDM: JSONTransformable {
    public let plannerID: Int
    public let plannerGoal: PlannerGoalDM
    public let plannerData: [PlannerDataDM]?
    public var selected: Bool
    
    init(ID: Int, goal: PlannerGoalDM, data: [PlannerDataDM], selected: Bool) {
        self.plannerID = ID
        self.plannerGoal = goal
        self.plannerData = data
        self.selected = selected
    }
    
    init(from model: ReadingPlannerVOM) {
        self.plannerID = model.plannerID
        self.plannerGoal = PlannerGoalDM(from: model.plannerGoal.asJSON())
        if let plannerDataArray = model.plannerData {
            let dmArray = plannerDataArray.map({ model -> PlannerDataDM in
                let dm = PlannerDataDM(from: model.asJSON())
                return dm
            })
            self.plannerData = dmArray
        } else {
            self.plannerData = nil
        }
        self.selected = model.selected
    }
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.plannerID = json["plannerID"].int ?? 0
        
        if let plannerGoalJSON = jsonObj["plannerGoal"] as? JSONObject {
            self.plannerGoal = PlannerGoalDM(from: plannerGoalJSON)
        } else {
            self.plannerGoal = PlannerGoalDM(from: [:])
        }
        
        
        if let plannerDataJSONArray = jsonObj["plannerData"] as? JSONArray {
            let modelArray = plannerDataJSONArray.map({ json -> PlannerDataDM in
                let model = PlannerDataDM(from: json)
                return model
            })
            self.plannerData = modelArray
        } else {
            self.plannerData = nil
        }
        
        self.selected = json["selected"].bool ?? false
    }
    
    func asJSON() -> JSONObject {
        var json = JSONObject()
        json["plannerID"] = self.plannerID
        json["plannerGoal"] = self.plannerGoal.asJSON()
        let plannerDataJSONArray = self.plannerData?.map({ model -> JSONObject in
            return model.asJSON()
        })
        json["plannerData"] = plannerDataJSONArray
        json["selected"] = self.selected
        return json
    }
}
