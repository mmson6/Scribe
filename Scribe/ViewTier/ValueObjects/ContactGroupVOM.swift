//
//  ContactGroupVOM.swift
//  Scribe
//
//  Created by Mikael Son on 5/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct ContactGroupVOM {
    public let type: ContactGroups
    
    public init?(model: ContactGroupDM) {
        self.type = model.type
    }
}
