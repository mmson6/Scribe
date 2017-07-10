//
//  DataAccessor.swift
//  Scribe
//
//  Created by Mikael Son on 5/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import FirebaseDatabase


public typealias DataAccessorDMCallback<T> = (AsyncResult<T>) -> Void

public final class DataAccessor {
    
    private let scribeClient = NetworkScribeClient(baseURL: AppConfiguration.baseURL)
    private let dataStore = LevelDBStore()
    var rootRef: DatabaseReference!
    
    internal func loadContactDetails(_ request: FetchContactDetailRequest, callback: @escaping DataAccessorDMCallback<ContactInfoDM>) {
        let client = self.scribeClient
        client.fetchContactDetail(request) { result in
            switch result {
            case .success(let array):
                callback(.success(array))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    internal func loadContactGroups(callback: @escaping DataAccessorDMCallback<[ContactGroupDM]>) {
        let client = self.scribeClient
        client.fetchContactGroups { result in
            switch result {
            case .success(let array):
                callback(.success(array))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    internal func loadContacts(callback: @escaping DataAccessorDMCallback<[ContactDM]>) {
        let loadFromDataStore = { (store: LevelDBStore) -> JSONArray? in
            return store.loadContacts()
        }
        let loadFromScribeClient = { (client: ScribeClient, resultHandler: @escaping DataAccessorDMCallback<[ContactDM]>) in
            client.fetchContacts(callback: resultHandler)
        }
        let save = { (store: LevelDBStore, array: JSONArray?) in
            store.save(contacts: array)
        }

        self.loadDomainModelArray(
            loadFromDataStore: loadFromDataStore,
            loadFromScribeClient: loadFromScribeClient,
            save: save,
            callback: callback
        )
        
//        let client = self.scribeClient
//        client.fetchContacts { result in
//            switch result {
//            case .success(let array):
//                callback(.success(array))
//            case .failure(let error):
//                callback(.failure(error))
//            }
//        }
    }
    
    internal func loadGroupContacts(_ request: FetchGroupContactsRequest, callback: @escaping DataAccessorDMCallback<[ContactDM]>) {
        let client = self.scribeClient
        client.fetchGroupContacts(request) { result in
            switch result {
            case .success(let array):
                callback(.success(array))
            case .failure(let error):
                callback(.failure(error))
            }
        }
        //
        ////        var contactArray = [ContactVOM]()
        //
        //        let obj1 = ContactVOM(id: 1, name: "Mike")
        //        let obj2 = ContactVOM(id: 1,name: "Daniel")
        //        let obj3 = ContactVOM(id: 1,name: "Roy")
        //        let obj4 = ContactVOM(id: 1,name: "Paul")
        //        let obj5 = ContactVOM(id: 1,name: "Andrew")
        //        contactArray.append(obj1)
        //        contactArray.append(obj2)
        //        contactArray.append(obj3)
        //        contactArray.append(obj4)
        //        contactArray.append(obj5)
        //        
        //        return contactArray
    }
    
    
    internal func populateDatabase() {
//        var ref: reference
//        var myRootRef = Database
        //        var myRootRef = Firebase(url: "https://scribe-4ed24.firebaseio.com/Core/")
        //
        ////        myRootRef?.setValue("Do you have data? You'll love Firebase.")
        //
        ////        myRootRef.observe
        //
        //        myRootRef?.child(byAppendingPath: "Contacts/Global_Ver").observeSingleEvent(of: .value, with: { snapshot in
        //            if let snapshot = snapshot {
        //                print("\(snapshot)")
        //            }
        //
        //            let value = snapshot?.value as? NSDictionary
        //            print("\(value)")
        //        })
        ////        myRootRef?.observe(.value, with: { snapshot in
        ////            if let snapshot = snapshot {
        ////                print("\(snapshot.key) -> \(snapshot.value)")
        ////            }
        ////        })
    }
    
    // MARK: Private Helper Funcitons
    
    private func loadDomainModelArray<T: JSONTransformable>(
        loadFromDataStore: (LevelDBStore) -> JSONArray?,
        loadFromScribeClient: (ScribeClient, @escaping DataAccessorDMCallback<[T]>) -> Void,
        save: @escaping (LevelDBStore, JSONArray) -> Void,
        callback: @escaping (AsyncResult<[T]>) -> Void
    ) {
        let store = self.dataStore
        let client = self.scribeClient
        if let jsonArray = loadFromDataStore(store) {
            let modelArray: [T] = jsonArray.map({ (jsonObject: JSONObject) -> T in
                let domainModel = T(from: jsonObject)
                return domainModel
            })
            callback(AsyncResult.success(modelArray))
        } else {
            loadFromScribeClient(client) { result in
                switch result {
                case .success(let modelArray):
                    let jsonArray = modelArray.map({ (model: T) -> JSONObject in
                        let jsonObject = model.asJSON()
                        return jsonObject
                    })
                    save(store, jsonArray)
                    callback(AsyncResult.success(modelArray))
                case .failure(let error):
                    callback(AsyncResult.failure(error))
                }
            }
        }
    }
}
