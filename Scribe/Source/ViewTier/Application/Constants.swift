//
//  Constants.swift
//  Scribe
//
//  Created by Mikael Son on 5/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public typealias JSONArray = [JSONObject]
public typealias JSONObject = [String: Any]

fileprivate let pBaseURL = "https://scribe-4ed24.firebaseio.com/"

// MARK: Contacts Group Names

internal struct GroupName {
    static let YA_Group = "Young Adult"
    static let Fathers_Group = "Fathers"
    static let Mothers_Group = "Mothers"
    static let Teachers_Group = "Teachers"
    static let Choir_Group = "Choir"
    static let Church_School = "Church School"
    static let Translators_Group = "Translator"
}
//public typealias YA_Group = "Young Adults"
//public typealias Fathers_Group = "Fathers Group"
//public typealias Mothers_Group = "Mothers Group"
//public typealias Teachers_Group = "Teachers"
//public typealias Choir_Group = "Choir"


// MARK: Notifications

let mainLanguageChanged = Notification.Name("MainLanguageChanged")


struct AppConfiguration {
    static let baseURL = pBaseURL
}
