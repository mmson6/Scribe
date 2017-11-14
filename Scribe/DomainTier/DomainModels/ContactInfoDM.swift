//
//  ContactInfoDM.swift
//  Scribe
//
//  Created by Mikael Son on 6/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


internal protocol JSONTransformable {
    init(from jsonObj: JSONObject)
    func asJSON() -> JSONObject
}

public struct ContactInfoDM: JSONTransformable {
    public let nameEng: String?
    public let nameKor: String?
    public let district: String?
    public let address: AddressDM?
    public let phone: String?
    public let group: String?
    public let birthday: String
    public let teacher: Bool
    public let translator: Bool
    public let choir: Bool
    
    private let originalJSON: JSONObject
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.nameEng = json["nameEng"].string
        self.nameKor = json["nameKor"].string
        self.district = json["district"].string
        
        if let addressData = jsonObj["address"] as? JSONObject {
            self.address = AddressDM(from: addressData)
        } else {
            self.address = AddressDM(from: [:])
        }
        
        self.phone = json["phone"].string
        self.group = json["group"].string
        self.birthday = json["birthday"].string ?? ""
        self.teacher = json["teacher"].bool ?? false
        self.translator = json["translator"].bool ?? false
        self.choir = json["choir"].bool ?? false
        
        self.originalJSON = jsonObj
    }
    
    public func asJSON() -> JSONObject {
        return self.originalJSON
    }
}

//for object in t {
//                        var json: JSONObject = [:]
//                        json["\(object.key)"] = object.value
//                        infoArray.append(json)
//                    }
