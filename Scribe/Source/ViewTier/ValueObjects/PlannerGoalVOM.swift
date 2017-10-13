//
//  PlannerGoalVOM.swift
//  Scribe
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct PlannerGoalVOM: JSONTransformable {
    public let startDate: String
    public let endDate: String
    public let OTGoal: Int
    public let NTGoal: Int
    
    public let originalJSON: JSONObject
    
    init(start: String, end: String, OT: Int, NT: Int) {
        self.startDate = start
        self.endDate = end
        self.OTGoal = OT
        self.NTGoal = NT
        
        var json = JSONObject()
        json["startDate"] = start
        json["endDate"] = end
        json["OTGoal"] = OT
        json["NTGoal"] = NT
        self.originalJSON = json
    }
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.startDate = json["startDate"].string ?? ""
        self.endDate = json["endDate"].string ?? ""
        self.OTGoal = json["OTGoal"].int ?? 0
        self.NTGoal = json["NTGoal"].int ?? 0
        
        self.originalJSON = jsonObj
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
