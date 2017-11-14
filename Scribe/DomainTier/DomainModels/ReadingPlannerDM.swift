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
    public let plannerGoal: PlannerGoalVOM
    public let plannerData: [PlannerDataVOM]?
    public let selected: Bool
    
    init(from model: ReadingPlannerVOM) {
        self.plannerID = model.plannerID
        self.plannerGoal = model.plannerGoal
        self.plannerData = model.plannerData
        self.selected = model.selected
    }
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.plannerID = json["plannerID"].int ?? 0
        
        if let plannerGoalJSON = jsonObj["plannerGoal"] as? JSONObject {
            self.plannerGoal = PlannerGoalVOM(from: plannerGoalJSON)
        } else {
            self.plannerGoal = PlannerGoalVOM(from: [:])
        }
        
        
        if let plannerDataJSONArray = jsonObj["plannerData"] as? JSONArray {
            let modelArray = plannerDataJSONArray.map({ json -> PlannerDataVOM in
                let model = PlannerDataVOM(from: json)
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
