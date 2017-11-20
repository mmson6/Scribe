//
//  UpdateContactDetailRequest.swift
//  Scribe
//
//  Created by Mikael Son on 8/16/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct UpdateContactDetailRequest {
    public let nameEng: String
    public let nameKor: String
    public let district: String
    public let address: JSONObject
    public let phone: String
    public let birthday: String
    public let group: String
    public let teacher: Bool
    public let translator: Bool
    public let choir: Bool
    public let contactId: String

    init(from jsonArray: [String: [String: Any?]], and contactId: String) {
        if let generalInfoData = jsonArray["GeneralInfo"] {
            self.nameEng = generalInfoData["Name (Eng)"] as? String ?? ""
            self.nameKor = generalInfoData["Name (Kor)"] as? String ?? ""
            self.phone = generalInfoData["Phone"] as? String ?? ""
            self.district = generalInfoData["District"] as? String ?? ""
        } else {
            self.nameEng = ""
            self.nameKor = ""
            self.phone = ""
            self.district = ""
        }
        
        if let addressData = jsonArray["Address"], let addressModel = addressData["Address"] as? AddressDM {
            self.address = addressModel.asJSON()
        } else {
            self.address = [:]
        }
        
        if let birthdayInfoData = jsonArray["Birthday"] {
            self.birthday = birthdayInfoData["Birthday"] as? String ?? ""
        } else {
            self.birthday = ""
        }
        
        if let groupInfoData = jsonArray["ChurchGroup"] {
            self.group = groupInfoData["Group"] as? String ?? ""
        } else {
            self.group = ""
        }
        
        if let serviceInfoData = jsonArray["ChurchServices"] {
            self.teacher = serviceInfoData["Teacher"] as? Bool ?? false
            self.translator = serviceInfoData["Translator"] as? Bool ?? false
            self.choir = serviceInfoData["Choir"] as? Bool ?? false
        } else {
            self.teacher = false
            self.translator = false
            self.choir = false
        }
        
        self.contactId = contactId
    }
    
    public func asJSON() -> JSONObject {
        var json: JSONObject = [:]
        json["nameEng"] = self.nameEng
        json["nameKor"] = self.nameKor
        json["district"] = self.district
        json["address"] = self.address
        json["phone"] = self.phone
        json["birthday"] = self.birthday
        json["group"] = self.group
        json["teacher"] = self.teacher
        json["translator"] = self.translator
        json["choir"] = self.choir
        json["contactId"] = self.contactId
        return json
    }
}
