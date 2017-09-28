//
//  PlannerDataVOM.swift
//  Scribe
//
//  Created by Mikael Son on 9/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public struct PlannerDataVOM {
    public let bookName: String
    public var chaptersReadCount: JSONObject
    
    public init(model: PlannerDataDM) {
        self.bookName = model.bookName
        self.chaptersReadCount = model.chaptersReadCount
    }
    
    public init(bookName: String, chaptersReadCount: JSONObject) {
        self.bookName = bookName
        self.chaptersReadCount = chaptersReadCount
    }
}
