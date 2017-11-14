//
//  SignUpRequest.swift
//  Scribe
//
//  Created by Mikael Son on 7/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct SignUpRequest {
    public let first: String
    public let last: String
    public var email: String
    public let password: String
    public var church: String
    
    init(first: String, last: String, email: String, password: String, church: String = "") {
        self.first = first
        self.last = last
        self.email = email
        self.password = password
        self.church = church
    }
    
    public func asJSON() -> JSONObject {
        var json: JSONObject = [:]
        json["firstName"] = self.first
        json["lastName"] = self.last
        json["email"] = self.email
        json["password"] = self.password
        json["church"] = self.church
        
        return json
    }
}
