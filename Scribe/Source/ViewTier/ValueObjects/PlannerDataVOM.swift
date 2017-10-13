//
//  PlannerDataVOM.swift
//  Scribe
//
//  Created by Mikael Son on 9/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct PlannerDataVOM {
    public let bookName: String
    public var chaptersReadCount: JSONObject
    
    public init(model: PlannerDataDM) {
        self.bookName = model.bookName
        self.chaptersReadCount = model.chaptersReadCount
    }
    
    public init(bookName: String, chaptersReadCount: JSONObject) {
        self.bookName = bookName
        self.chaptersReadCount = chaptersReadCount
    }
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.bookName = json["bookName"].string ?? ""
        if let chaptersReadCountJSON = json["chaptersReadCount"].dictionaryObject {
            self.chaptersReadCount = chaptersReadCountJSON
        } else {
            self.chaptersReadCount = [:]
        }
    }
}
