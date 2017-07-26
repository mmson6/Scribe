//
//  ContactInfoVOM.swift
//  Scribe
//
//  Created by Mikael Son on 5/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public typealias JSONDictionary = [String: Any?]

public struct ContactInfoVOM {
    public let label: String
    public let value: String
    public let extra: String?
//    public var contactDetailArray: Array<JSONDictionary>
    
    public init(jsonObj: JSONObject, _ extra: String = "") {
        let json = JSON(jsonObj)
        
        if let label = json["label"].string {
            self.label = label
        } else {
            self.label = ""
        }
        
        if let value = json["value"].string {
            self.value = value
        } else {
            self.value = ""
        }
        
        self.extra = extra
    }
}
