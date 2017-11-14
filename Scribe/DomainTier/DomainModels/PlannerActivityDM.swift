//
//  PlannerActivityDM.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON

public struct PlannerActivityDM: JSONTransformable {
    public let bookName: String
    public let isConsecutive: Bool
    public let chapterDict: JSONObject
    public let min: Int
    public let max: Int
    public let time: String
    
    private let originalJSON: JSONObject
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.bookName = json["bookName"].string ?? ""
        self.isConsecutive = json["isConsecutive"].bool ?? false
        
        if let dict = json["chapterDict"].dictionaryObject {
            self.chapterDict = dict
        } else {
            self.chapterDict = [:]
        }
        
        self.min = json["min"].int ?? -1
        self.max = json["max"].int ?? -1
        self.time = json["time"].string ?? ""
        
        self.originalJSON = jsonObj
    }
    
    init(from model: PlannerActivityVOM) {
        self.bookName = model.bookName
        self.isConsecutive = model.isConsecutive
        self.chapterDict = model.chapterDict
        self.min = model.min
        self.max = model.max
        self.time = model.time
        
        self.originalJSON = model.asJSON()
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
