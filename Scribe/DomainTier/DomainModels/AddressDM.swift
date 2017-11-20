//
//  AddressDM.swift
//  Scribe
//
//  Created by Mikael Son on 8/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct AddressDM: JSONTransformable {
    public let addressLine: String
    public let city: String
    public let state: String
    public let zipCode: String
    
    public let originalJSON: JSONObject
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.addressLine = json["addressLine"].string ?? ""
        self.city = json["city"].string ?? ""
        self.state = json["state"].string ?? ""
        self.zipCode = json["zipCode"].string ?? ""
        
        self.originalJSON = jsonObj
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
