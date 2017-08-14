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
    public let address: String?
    public let phone: String?
    public let group: String?
    public let teacher: Bool
    public let translator: Bool
    public let choir: Bool
    
    private let originalJSON: JSONObject
    
    public init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.nameEng = json["name_eng"].string
        self.nameKor = json["name_kor"].string
        self.district = json["district"].string
        self.address = json["address"].string
        self.phone = json["phone"].string
        self.group = json["group"].string
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
