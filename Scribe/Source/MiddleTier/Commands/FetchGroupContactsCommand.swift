//
//  FetchGroupContactsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/22/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation


public class FetchGroupContactsCommand: ScribeCommand<ObjectDataSource<Any>> {
    
    public var lookupKey: Any?
    
    public override func main() {
        
        guard let key = self.lookupKey as? ContactGroups else { return }
        let request = FetchGroupContactsRequest(lookupKey: key)
        self.accessor.loadGroupContacts(request) { result in
            switch result {
            case .success(let dmArray):
                let models = dmArray.flatMap({ (contactDM) -> ContactVOM? in
                    let model = ContactVOM(model: contactDM)
                    return model
                })
                let ods = ArrayObjectDataSource<Any>(objects: models)
                self.completedWith(value: ods)
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
