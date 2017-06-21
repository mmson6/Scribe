//
//  ContactVOM.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct ContactVOM {
    public let id: Any
    public let name: String
    public let group: String
    public let teacher: Bool
    public let choir: Bool
    public let translator: Bool
    
    public init?(model: ContactDM) {
        self.id = model.id as Any
        self.name = model.name
        self.group = model.group
        self.teacher = model.teacher
        self.choir = model.choir
        self.translator = model.translator
    }
}
