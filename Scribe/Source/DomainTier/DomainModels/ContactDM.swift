//
//  ContactDM.swift
//  Scribe
//
//  Created by Mikael Son on 6/9/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import SwiftyJSON


public struct ContactDM: JSONTransformable {
    public let id: Int64
    public let nameEng: String
    public let nameKor: String
    public let group: String
    public let teacher: Bool
    public let choir: Bool
    public let translator: Bool
    
    private let originalJSON: JSONObject
    
    init(from jsonObj: JSONObject) {
        let json = JSON(jsonObj)
        self.id = json["id"].int64 ?? 0
        self.nameEng = json["name_eng"].string ?? ""
        self.nameKor = json["name_kor"].string ?? ""
        self.group = json["group"].string ?? ""
        self.teacher = json["teacher"].bool ?? false
        self.choir = json["choir"].bool ?? false
        self.translator = json["translator"].bool ?? false
        self.originalJSON = jsonObj
    }
    
    public init(from jsonObj: JSONObject, with id: Int64) {
        let json = JSON(jsonObj)
        self.id = id
        self.nameEng = json["name_eng"].string ?? ""
        self.nameKor = json["name_kor"].string ?? ""
        self.group = json["group"].string ?? ""
        self.teacher = json["teacher"].bool ?? false
        self.choir = json["choir"].bool ?? false
        self.translator = json["translator"].bool ?? false
        
        var jsonData = jsonObj
        jsonData["id"] = id
        self.originalJSON = jsonData
    }
    
    public func asJSON() -> JSONObject {
        return self.originalJSON
    }
}
