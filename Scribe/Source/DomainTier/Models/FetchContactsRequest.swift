//
//  FetchContactsRequest.swift
//  Scribe
//
//  Created by Mikael Son on 5/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct FetchContactsRequest {
    public let contactVer: Int64
    
    public func asJSON() -> JSONObject {
        var json:JSONObject = [:]
        json["contactVer"] = self.contactVer
        return json
    }
}
