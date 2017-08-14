//
//  ScribeCommand.swift
//  Scribe
//
//  Created by Mikael Son on 8/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct ContactDetailVOM {
    public let nameEng: String?
    public let nameKor: String?
    public let district: String?
    public let address: String?
    public let phone: String?
    public let group: String?
    public let teacher: Bool
    public let translator: Bool
    public let choir: Bool
    
    
    public init?(model: ContactInfoDM) {
        self.nameEng = model.nameEng
        self.nameKor = model.nameKor
        self.district = model.district
        self.address = model.address
        self.phone = model.phone
        self.group = model.group
        self.teacher = model.teacher
        self.translator = model.translator
        self.choir = model.choir
    }
    
    public func asJSON() -> JSONObject {
        var json: JSONObject = [:]
        json["nameEng"] = self.nameEng
        json["nameKor"] = self.nameKor
        json["district"] = self.district
        json["address"] = self.address
        json["phone"] = self.phone
        json["group"] = self.nameKor
        json["teacher"] = self.teacher
        json["translator"] = self.translator
        json["choir"] = self.choir
        return json
    }
}
