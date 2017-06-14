//
//  ScribeCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

internal let sharedDataAccessor = DataAccessor()

public class ScribeCommand<T>: AsyncCommand<T> {
    
    internal let accessor: DataAccessor
    
    init(accessor: DataAccessor = sharedDataAccessor) {
        self.accessor = accessor
    }
}
