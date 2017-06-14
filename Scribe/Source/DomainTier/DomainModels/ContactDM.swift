//
//  ContactDM.swift
//  Scribe
//
//  Created by Mikael Son on 6/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct ContactDM {
    public let id: Int64
    public let name: String
    
    private let originalJSON: JSONObject
    
    
    public init(from jsonObj: JSONObject, with id: Int64) {
        let json = JSON(jsonObj)
        self.id = id
        self.name = json["name_eng"].string ?? ""
        
        self.originalJSON = jsonObj
    }
    
    public func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
