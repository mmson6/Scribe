//
//  FetchGroupContactsRequest.swift
//  Scribe
//
//  Created by Mikael Son on 6/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct FetchGroupContactsRequest {
    public let lookupKey: ContactGroups
    
    public func asJSON() -> JSONObject {
        var json:JSONObject = [:]
        json["lookupKey"] = self.lookupKey
        return json
    }
}
