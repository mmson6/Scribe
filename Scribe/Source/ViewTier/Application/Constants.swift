//
//  Constants.swift
//  Scribe
//
//  Created by Mikael Son on 5/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation


public typealias JSONObject = [String: Any]

fileprivate let pBaseURL = "https://scribe-4ed24.firebaseio.com/"

// MARK: Contacts Group Names

internal struct GroupName {
    static let YA_Group = "Young Adults"
    static let Fathers_Group = "Fathers Group"
    static let Mothers_Group = "Mothers Group"
    static let Teachers_Group = "Teachers"
    static let Choir_Group = "Choir"
}
//public typealias YA_Group = "Young Adults"
//public typealias Fathers_Group = "Fathers Group"
//public typealias Mothers_Group = "Mothers Group"
//public typealias Teachers_Group = "Teachers"
//public typealias Choir_Group = "Choir"




struct AppConfiguration {
    static let baseURL = pBaseURL
}
