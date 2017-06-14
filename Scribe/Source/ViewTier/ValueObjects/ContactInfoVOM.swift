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
    
    public init?(jsonObj: JSONObject, _ extra: String = "") {
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
        
//        
//        let nameData: JSONDictionary = ["name": name]
//        let addressData: JSONDictionary = ["address": address]
//        let districtData: JSONDictionary = ["district": district]
//        let birthdayData: JSONDictionary = ["birthday": birthday]
//        let sBirthdayData: JSONDictionary = ["spiritualBirthday": sBirthday]
//        let emailData: JSONDictionary = ["email": email]
//        
//        var dataArray: Array<JSONDictionary> = []
//        dataArray.append(nameData)
//        dataArray.append(nameData)
//        dataArray.append(addressData)
//        dataArray.append(districtData)
//        dataArray.append(birthdayData)
//        dataArray.append(sBirthdayData)
//        dataArray.append(emailData)
//        
//        self.contactDetailArray = dataArray
    }
}
