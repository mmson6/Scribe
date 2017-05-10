//
//  ScribeClient.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

internal protocol ScribeClient {
    func performFetchContacts(_ request: FetchContactsRequest, completion: @escaping (AsyncResult<Any>) -> Void)
    func performFetchContactDetail(_ request: FetchContactDetailRequest, completion: @escaping (AsyncResult<Any>) -> Void)
}

internal class NetworkScribeClient: ScribeClient {
    
    internal func performFetchContacts(_ request: FetchContactsRequest, completion: @escaping (AsyncResult<Any>) -> Void) {
        
        completion(.success(true))
//        let url = ""
    }
    
    internal func performFetchContactDetail(_ request: FetchContactDetailRequest, completion: @escaping (AsyncResult<Any>) -> Void) {
        
        completion(.success(true))
    }
}
