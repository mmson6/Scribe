//
//  FetchContactDetailCommand.swift
//  Scribe
//
//  Created by Mikael Son on 5/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactDetailCommand: ScribeCommand<[ContactInfoVOM]> {
    
    public var lookupKey: Any?
    
    public override func main() {
        guard let id = lookupKey as? Int64 else { return }
        let request = FetchContactDetailRequest(id: id, contactVer: 0)
        self.accessor.loadContactDetails(request) { result in
            switch result {
            case .success(let dm):
                let sortedModels =  self.populate(dm: dm)
//                let models = dmArray.flatMap({ (contactDM) -> ContactInfoVOM? in
//                    let model = ContactInfoVOM(model: contactDM)
//                    return model
//                })
//                let ods = ArrayObjectDataSource<Any>(objects: models)
                self.completedWith(value: sortedModels)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func populate(dm: ContactInfoDM) -> [ContactInfoVOM] {
        var sortedModels: [ContactInfoVOM] = []
        
        if let nameEng = dm.nameEng, let nameKor = dm.nameKor {
            if let model = ContactInfoVOM(jsonObj: ["label": "NAME", "value": nameEng], nameKor) {
                sortedModels.append(model)
            }
        }
        if let phone = dm.phone, phone != "" {
            if let model = ContactInfoVOM(jsonObj: ["label": "PHONE", "value": phone]) {
                sortedModels.append(model)
            }
        }
        if let address = dm.address, address != "" {
            if let model = ContactInfoVOM(jsonObj: ["label": "ADDRESS", "value": address]) {
                sortedModels.append(model)
            }
        }
        if let district = dm.district, district != "" {
            if let model = ContactInfoVOM(jsonObj: ["label": "DISTRICT", "value": district]) {
                sortedModels.append(model)
            }
        }
        if let group = dm.group, group != "" {
            if let model = ContactInfoVOM(jsonObj: ["label": "GROUP", "value": group]) {
                sortedModels.append(model)
            }
        }
        return sortedModels
    }
}
