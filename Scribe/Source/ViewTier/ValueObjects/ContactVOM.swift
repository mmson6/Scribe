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
    
    public init?(model: ContactDM) {
        self.id = model.id as Any
        self.name = model.name
    }
}
