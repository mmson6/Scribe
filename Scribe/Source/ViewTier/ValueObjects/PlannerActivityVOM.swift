//
//  PlannerActivityVOM.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct PlannerActivityVOM {
    public let bookName: String
    public let isConsecutive: Bool
    public let chapterDict: JSONObject
    public let min: Int
    public let max: Int
    
    init(bookName: String, isConsecutive: Bool, chapterDict: JSONObject, min: Int, max: Int) {
        self.bookName = bookName
        self.isConsecutive = isConsecutive
        self.chapterDict = chapterDict
        self.min = min
        self.max = max
    }
    
    init(from model: PlannerActivityDM) {
        self.bookName = model.bookName
        self.isConsecutive = model.isConsecutive
        self.chapterDict = model.chapterDict
        self.min = model.min
        self.max = model.max
    }
    
    internal func asJSON() -> JSONObject {
        var json: JSONObject = [:]
        json["bookName"] = self.bookName
        json["isConsecutive"] = self.isConsecutive
        json["chapterDict"] = self.chapterDict
        json["min"] = self.min
        json["max"] = self.max
        
        return json
//        return self.originalJSON
    }
}
