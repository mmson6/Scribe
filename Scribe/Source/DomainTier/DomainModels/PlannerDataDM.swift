//
//  PlannerDataDM.swift
//  Scribe
//
//  Created by Mikael Son on 9/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct PlannerDataDM {
    public let bookName: String
    public var chaptersReadCount: JSONObject
    
    public init(bookName: String, chaptersReadCount: JSONObject) {
        self.bookName = bookName
        self.chaptersReadCount = chaptersReadCount
    }
    
    public init(json: JSONObject) {
//        var readCountArray: JSONArray
        var jsonObj = json
        jsonObj["name"] = nil
        
        self.bookName = json["name"] as! String
        self.chaptersReadCount = jsonObj
//
//        json["name"]
//        
//        for (key, value) in json {
//            guard
//                key != "name",
//                let intKey = Int(key),
//                let intVal = value as? Int
//            else {
//                continue
//            }
//            print("check key: \(key)")
//            readCountArray[key] = value
////            readCountArray.insert(intVal, at: intKey)
//        }
//        
//        
//        self.chaptersReadCount = readCountArray
    }
    
    public func asJSON() -> JSONObject {
        var json = self.chaptersReadCount
        json["name"] = self.bookName
        return json
        
//        var json: JSONObject = ["name": self.bookName]
//        for (index, value) in self.chaptersReadCount.enumerated() {
//            json["\(index)"] = value
//        }
//        return json
    }
}
