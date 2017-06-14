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
import FirebaseDatabase


public typealias ScribeClientCallback<T> = (AsyncResult<T>) -> Void

internal protocol ScribeClient {
    func fetchContactDetail(_ request: FetchContactDetailRequest, callback: @escaping ScribeClientCallback<ContactInfoDM>)
    func fetchContactGroups(callback: @escaping ScribeClientCallback<[ContactGroupDM]>)
    func fetchContacts(callback: @escaping ScribeClientCallback<[ContactDM]>)
    func fetchGroupContacts(_ request: FetchGroupContactsRequest, callback: @escaping ScribeClientCallback<[ContactDM]>)
}

internal class NetworkScribeClient: ScribeClient {
    
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
        
        
    }
    
    internal func fetchContactDetail(_ request: FetchContactDetailRequest, callback: @escaping ScribeClientCallback<ContactInfoDM>) {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactRef = ref.child("contacts")
        let query = contactRef.queryOrderedByKey().queryEqual(toValue: "\(request.id)")
        
        query.observeSingleEvent(of: .value, with: { snap in
            if let dataSnap = snap.children.allObjects as? [DataSnapshot] {
                guard let json = dataSnap.last else { return }
                if let jsonData = json.value as? JSONObject {
                    let dm = ContactInfoDM(from: jsonData)
//                    let dms = jsonData.flatMap({ (key, value) -> ContactInfoDM? in
//                        let dm = ContactInfoDM(from: ["label": key, "value": value])
//                        return dm
//                    })
                    callback(.success(dm))
                }
            }
        })
    }
    
    internal func fetchContactGroups(callback: @escaping ScribeClientCallback<[ContactGroupDM]>) {
        var contactGroupArray = [ContactGroupDM]()
        let obj1 = ContactGroupDM(from: ["groupType": "Young Adult"])
        let obj2 = ContactGroupDM(from: ["groupType": "Mothers Group"])
        let obj3 = ContactGroupDM(from: ["groupType": "Fathers Group"])
        let obj4 = ContactGroupDM(from: ["groupType": "Teachers"])
        let obj5 = ContactGroupDM(from: ["groupType": "Choir"])
        
        contactGroupArray.append(obj1)
        contactGroupArray.append(obj2)
        contactGroupArray.append(obj3)
        contactGroupArray.append(obj4)
        contactGroupArray.append(obj5)
        
        callback(.success(contactGroupArray))
    }
    
    internal func fetchContacts(callback: @escaping ScribeClientCallback<[ContactDM]>) {
        let rootRef = Database.database().reference(fromURL: self.baseURL)
        let contactRef = rootRef.child("contacts")
        let query = contactRef.queryOrdered(byChild: "name_eng")
        
        query.observeSingleEvent(of: .value, with: { (snap) in
            if let snapArray = snap.children.allObjects as? [DataSnapshot] {
                
                let models = snapArray.map({ (snapData) -> ContactDM in
                    guard
                        let jsonData = snapData.value as? JSONObject,
                        let intId = Int(snapData.key)
                        else {
                            return ContactDM(from: [:], with: 0)
                    }
                    
                    let int64Id = Int64(intId)
                    let dm = ContactDM(from: jsonData, with: int64Id)
                    return dm
                })
                
                callback(.success(models))
            }
        })
    }
    
    internal func fetchGroupContacts(_ request: FetchGroupContactsRequest, callback: @escaping ScribeClientCallback<[ContactDM]>) {
        let key = self.contactGroupToString(request.lookupKey)
        let rootRef = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactRef = rootRef.child("contacts")
        let query = contactRef.queryOrdered(byChild: "group").queryEqual(toValue: key)
        
        query.observeSingleEvent(of: .value, with: { (snap) in
            if let snapArray = snap.children.allObjects as? [DataSnapshot] {
                let models = snapArray.map({ (snapData) -> ContactDM in
                    guard
                        let jsonData = snapData.value as? JSONObject,
                        let intId = Int(snapData.key)
                        else {
                            return ContactDM(from: [:], with: 0)
                    }
                    
                    let int64Id = Int64(intId)
                    let dm = ContactDM(from: jsonData, with: int64Id)
                    return dm
                })
                
                callback(.success(models))
            }
        })
    }
    
    // MARK: Helper Functions
    
    private func contactGroupToString(_ value: ContactGroups) -> String {
        switch value {
        case .Choir:
            return "Choir"
        case .Fathers:
            return "Fathers"
        case .Mothers:
            return "Mothers"
        case .Teachers:
            return "Teachers"
        case .YoungAdults:
            return "Young Adult"
        }
    }
 }








