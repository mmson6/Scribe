//
//  ScribeCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

internal let sharedScribeClient = NetworkScribeClient()
internal let sharedDataAccessor = DataAccessor()

public class ScribeCommand<T>: AsyncCommand<T> {
    
    internal let client: ScribeClient
    internal let accessor: DataAccessor
    
    init(client: ScribeClient = sharedScribeClient, accessor: DataAccessor = sharedDataAccessor) {
        self.client = client
        self.accessor = accessor
    }
}
