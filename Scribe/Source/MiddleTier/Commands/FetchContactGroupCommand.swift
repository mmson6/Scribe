//
//  FetchContactsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/2/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactGroupCommand: ScribeCommand<ObjectDataSource<Any>> {
    
    public override func main() {
        self.accessor.loadContactGroups { result in
            switch result {
            case .success(let dmArray):
                let models = dmArray.flatMap({ (contactGroupDM) -> ContactGroupVOM? in
                    let model = ContactGroupVOM(model: contactGroupDM)
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
