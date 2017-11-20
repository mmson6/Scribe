//
//  SignUpRequestDM.swift
//  Scribe
//
//  Created by Mikael Son on 7/31/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct SignUpRequestDM: JSONTransformable {
    public let email: String
    public let church: String
    public let firstName: String
    public let lastName: String
    public let password: String
    
    public let originalJSON: JSONObject
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.email = json["email"].string ?? ""
        self.church = json["church"].string ?? ""
        self.firstName = json["firstName"].string ?? ""
        self.lastName = json["lastName"].string ?? ""
        self.password = json["password"].string ?? ""
        
        self.originalJSON = jsonObj
    }
    
    func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
