//
//  FetchContactDetailCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactDetailCommand: ScribeCommand<[ContactInfoVOM]> {
    
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
                
                    let sortedModels =  self.populate(dm: dm)
                    self.completedWith(value: sortedModels)
                
                
//                let models = dmArray.flatMap({ (contactDM) -> ContactInfoVOM? in
//                    let model = ContactInfoVOM(model: contactDM)
//                    return model
//                })
//                let ods = ArrayObjectDataSource<Any>(objects: models)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func populate(dm: ContactInfoDM) -> [ContactInfoVOM] {
        var sortedModels: [ContactInfoVOM] = []
        
        if let nameEng = dm.nameEng, let nameKor = dm.nameKor {
            let model = ContactInfoVOM(jsonObj: ["label": "NAME", "value": nameEng], nameKor)
            sortedModels.append(model)
        }
        if let phone = dm.phone, phone != "" {
            let model = ContactInfoVOM(jsonObj: ["label": "PHONE", "value": phone])
            sortedModels.append(model)
        }
        if let address = dm.address {
            let fullAddress = "\(address.addressLine), \(address.city), \(address.state) \(address.zipCode)"
            let model = ContactInfoVOM(jsonObj: ["label": "ADDRESS", "value": fullAddress])
            sortedModels.append(model)
        }
        let birthday = dm.birthday
        if birthday != "" {
            let model = ContactInfoVOM(jsonObj: ["label": "BIRTHDAY", "value": birthday])
            sortedModels.append(model)
        }
//        if let address = dm.address, address != "" {
//            let model = ContactInfoVOM(jsonObj: ["label": "ADDRESS", "value": address])
//            sortedModels.append(model)
//        }
        if let group = dm.group, group != "" {
            let model = ContactInfoVOM(jsonObj: ["label": "GROUP", "value": group])
            sortedModels.append(model)
        }
        if let district = dm.district, district != "" {
            let model = ContactInfoVOM(jsonObj: ["label": "DISTRICT", "value": district])
            sortedModels.append(model)
        }

        return sortedModels
    }
}
