//
//  FetchContactDetailRequest.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation


public struct FetchContactDetailRequest {
    public let id: String
    public let contactVer: Int64
    
    public func asJSON() -> JSONObject {
        var json:JSONObject = [:]
        json["id"] = self.id
        json["contactVer"] = self.contactVer
        return json
    }
}
