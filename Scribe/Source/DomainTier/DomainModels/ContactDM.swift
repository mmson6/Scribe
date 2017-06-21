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
    public let group: String
    public let teacher: Bool
    public let choir: Bool
    public let translator: Bool
    
    private let originalJSON: JSONObject
    
    
    public init(from jsonObj: JSONObject, with id: Int64) {
        let json = JSON(jsonObj)
        self.id = id
        self.name = json["name_eng"].string ?? ""
        self.group = json["group"].string ?? ""
        self.teacher = json["teacher"].bool ?? false
        self.choir = json["choir"].bool ?? false
        self.translator = json["translator"].bool ?? false
        
        self.originalJSON = jsonObj
    }
    
    public func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
