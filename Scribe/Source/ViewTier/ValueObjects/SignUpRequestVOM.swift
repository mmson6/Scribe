//
//  SignUpRequestVOM.swift
//  Scribe
//
//  Created by Mikael Son on 7/31/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct SignUpRequestVOM {
    public let email: String
    public let church: String
    public let firstName: String
    public let lastName: String
    public let password: String
    
    public init?(model: SignUpRequestDM) {
        self.email = model.email
        self.church = model.church
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.password = model.password
    }
}
