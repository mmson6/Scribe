//
//  PlannerDataDM.swift
//  Scribe
//
//  Created by Mikael Son on 9/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct PlannerDataDM: JSONTransformable {
    public let bookName: String
    public var chaptersReadCount: JSONObject
    
    
    public init(bookName: String, chaptersReadCount: JSONObject) {
        self.bookName = bookName
        self.chaptersReadCount = chaptersReadCount
    }
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.bookName = json["bookName"].string ?? ""

        if let chaptersReadCountJSON = jsonObj["chaptersReadCount"] as? JSONObject {
            self.chaptersReadCount = chaptersReadCountJSON
        } else {
            self.chaptersReadCount = [:]
        }
    }
    
    public func asJSON() -> JSONObject {
        var json = JSONObject()
        json["bookName"] = bookName
        json["chaptersReadCount"] = chaptersReadCount
        return json
    }
}
