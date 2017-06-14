//
//  FetchContactsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/22/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactsCommand: ScribeCommand<ObjectDataSource<Any>> {

    public override func main() {
        self.accessor.loadContacts { result in
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
