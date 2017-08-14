//
//  FetchContactDetailEditCommand.swift
//  Scribe
//
//  Created by Mikael Son on 8/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactDetailEditCommand: ScribeCommand<ContactDetailVOM> {
    
    var lookupKey: Any?
    var contactsVer: Any = 0 as Any
    
    public override func main() {
        guard
            let id = self.lookupKey as? String,
            let ver = self.contactsVer as? Int64
            else {
                return
        }
        
        let request = FetchContactDetailRequest(id: id, contactVer: ver)
        self.accessor.loadContactDetails(request) { result in
            switch result {
            case .success(let dm):
                if let model = ContactDetailVOM(model: dm) {
                    self.completedWith(value: model)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
