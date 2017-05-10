//
//  ScribeCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

internal let sharedScribeClient = NetworkScribeClient()

public class ScribeCommand<T>: AsyncCommand<T> {
    
    internal let client: ScribeClient
    
    init(client: ScribeClient = sharedScribeClient) {
        self.client = client
    }
}
