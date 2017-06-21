//
//  ContactGroupDM.swift
//  Scribe
//
//  Created by Mikael Son on 6/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct ContactGroupDM: JSONTransformable {
    public let type: ContactGroups
    
    private let originalJSON: JSONObject
    
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        let type = json["groupType"].string ?? ""
        
        switch type {
        case "Young Adult":
            self.type = ContactGroups.YoungAdults
        case "Fathers Group":
            self.type = ContactGroups.Fathers
        case "Mothers Group":
            self.type = ContactGroups.Mothers
        case "Teachers":
            self.type = ContactGroups.Teachers
        case "Choir":
            self.type = ContactGroups.Choir
        case "Church School":
            self.type = ContactGroups.ChurchSchool
        case "Translators":
            self.type = ContactGroups.Translators
        default:
            self.type = ContactGroups.YoungAdults
        }
        
        self.originalJSON = jsonObj
    }
    
    public func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
