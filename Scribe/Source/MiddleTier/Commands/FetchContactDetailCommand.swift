//
//  FetchContactDetailCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactDetailCommand: ScribeCommand<ObjectDataSource<Any>> {
    
    public override func main() {
        let contactVer: Int64 = 1
        let fetchContactDetailRequest = FetchContactDetailRequest(contactVer: contactVer)
        
        let completionHandler = self.handleFetchContactDetailResult(_:)
        self.client.performFetchContactDetail(fetchContactDetailRequest, completion: completionHandler)
    }
    
    private func handleFetchContactDetailResult(_ result: AsyncResult<Any>) {
        switch result {
        case .failure(let error):
            break;
        case .success:
            var models:JSONObject = [:]
            models["spiritual birthday"] = "May 15, 2010"
            models["birthday"] = "February 18, 1991"
            models["address"] = "507 Yosemite Trail \nRoselle IL 60172 \nUnited States"
            models["mobile"] = "(618) 977-2661"
            models["Name"] = "Mike Son"
            
            
            
            
            let arrayModels = Array(models)
            let ods: ObjectDataSource<Any> = ArrayObjectDataSource(objects: arrayModels)
            self.completedWith(value: ods)
            break;
        }
    }
    
    private func saveContacts() {
        
    }
    
    
}
