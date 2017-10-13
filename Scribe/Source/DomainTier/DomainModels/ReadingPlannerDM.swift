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
    public let plannerID: String
    public let plannerGoal: PlannerGoalVOM
    public let plannerData: [PlannerDataVOM]?
    public let selected: Bool
    
    private let originalJSON: JSONObject
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.plannerID = json["plannerID"].string ?? ""
        
        let plannerGoalJSON = json["plannerGoal"].dictionaryValue
        self.plannerGoal = PlannerGoalVOM(from: plannerGoalJSON)
        
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
        
        self.originalJSON = jsonObj
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
