//
//  FetchContactsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactsCommand: ScribeCommand<ObjectDataSource<Any>> {
    
    public override func main() {
        
        
        let contactVer: Int64 = 1
        let fetchContactRequest = FetchContactsRequest(contactVer: contactVer)
        
        let completionHandler = self.handleFetchContactsResult(_:)
        self.client.performFetchContacts(fetchContactRequest, completion: completionHandler)
    }
    
    private func handleFetchContactsResult(_ result: AsyncResult<Any>) {
        switch result {
        case .failure(let error):
            break;
        case .success:
            var models:JSONObject = [:]
            models["mike1"] = "1"
            models["mike2"] = "1"
            models["mike3"] = "1"
            models["mike4"] = "1"
            models["mike5"] = "1"
            let arrayModels = Array(models)
            let ods: ObjectDataSource<Any> = ArrayObjectDataSource(objects: arrayModels)
            self.completedWith(value: ods)
            break;
        }
    }
    
    private func saveContacts() {
    
    }
    
    
}
