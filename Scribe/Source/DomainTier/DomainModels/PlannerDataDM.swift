//
//  PlannerDataDM.swift
//  Scribe
//
//  Created by Mikael Son on 9/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct PlannerDataDM: JSONTransformable {
    public let bookName: String
    public var chaptersReadCount: JSONObject
    
    public init(bookName: String, chaptersReadCount: JSONObject) {
        self.bookName = bookName
        self.chaptersReadCount = chaptersReadCount
    }
    
    init(from jsonObj: JSONObject) {
        var json = jsonObj
        json["name"] = nil
        
        self.bookName = jsonObj["name"] as! String
        self.chaptersReadCount = json
    }
    
    public func asJSON() -> JSONObject {
        var json = self.chaptersReadCount
        json["name"] = self.bookName
        return json
    }
}
