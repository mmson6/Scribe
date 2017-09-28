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
    
    internal func loadBiblePlannerData(callback: @escaping DataAccessorDMCallback<[PlannerDataDM]>) {
        let store = self.dataStore
//        var modelArray = [PlannerDataDM]()
        if let jsonArray = store.loadBiblePlannerData() {
            let modelArray = jsonArray.map({ (json) -> PlannerDataDM in
                let dm = PlannerDataDM(json: json)
                return dm
            })
            callback(.success(modelArray))
        } else {
            let modelArray = [PlannerDataDM]()
            callback(.success(modelArray))
        }
    }
    
    internal func loadContactDetails(_ request: FetchContactDetailRequest, callback: @escaping DataAccessorDMCallback<ContactInfoDM>) {
        let loadFromDataStore = { (store: LevelDBStore) -> JSONObject? in
            let id = request.id as Any
            return store.loadContact(with: id)
        }
        let loadFromScribeClient = { (client: ScribeClient, resultHandler: @escaping DataAccessorDMCallback<ContactInfoDM>) in
            client.fetchContactDetail(request, callback: resultHandler)
        }
        let save = { (store: LevelDBStore, object: JSONObject?) in
            store.save(contact: object)
        }
        
        self.loadDomainModelObject(
            loadFromDataStore: loadFromDataStore,
            loadFromScribeClient: loadFromScribeClient,
            save: save,
            callback: callback
        )
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
    
    internal func loadContacts(with ver: Int64 ,callback: @escaping DataAccessorDMCallback<[ContactDM]>) {
        let loadFromDataStore = { (store: LevelDBStore) -> JSONArray? in
            let defaultsStore = UserDefaultsStore()
            if defaultsStore.contactsNeedUpdate(ver) {
                return nil
            } else {
                return store.loadContacts()
            }
        }
        let loadFromScribeClient = { (client: ScribeClient, resultHandler: @escaping DataAccessorDMCallback<[ContactDM]>) in
            client.fetchContacts(callback: resultHandler)
        }
        let save = { (store: LevelDBStore, array: JSONArray?) in
            if let array = array {
                for object in array {
                    store.save(contact: object)
                }
            }
            store.save(contacts: array)
            
            // Update Local ContactsVer
            let defaultsStore = UserDefaultsStore()
            defaultsStore.saveContactsVer(ver)
        }

        self.loadDomainModelArray(
            loadFromDataStore: loadFromDataStore,
            loadFromScribeClient: loadFromScribeClient,
            save: save,
            callback: callback
        )
    }
    
    internal func loadContactsVersion(callback: @escaping DataAccessorDMCallback<Int64>) {
        let client = self.scribeClient
        client.fetchContactsVersion { result in
            switch result {
            case.success(let ver):
                callback(.success(ver))
            case .failure(let error):
                NSLog("Error occurred while fetching contactsVer:: \(error)")
                callback(.success(0))
            }
        }
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
    }
    
    internal func loadSignUpRequests(callback: @escaping DataAccessorDMCallback<[SignUpRequestDM]>) {
        let client = self.scribeClient
        client.fetchSignUpRequests { result in
            switch result {
            case.success(let array):
                callback(.success(array))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    internal func loadUserRequestsCount(callback: @escaping DataAccessorDMCallback<Int64>) {
        let client = self.scribeClient
        client.fetchUserRequestsCount { result in
            switch result {
            case.success(let count):
                callback(.success(count))
            case .failure:
                break
            }
        }
    }
    
    internal func saveBiblePlannerData(dmArray: [PlannerDataDM], callback: @escaping DataAccessorDMCallback<Bool>) {
        let store = self.dataStore
        let jsonArray = dmArray.map { (dm) -> JSONObject in
            let jsonObj = dm.asJSON()
            return jsonObj
        }
        store.save(plannerData: jsonArray)
        callback(.success(true))
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
    
    private func loadDomainModelObject<T: JSONTransformable>(
        loadFromDataStore: (LevelDBStore) -> JSONObject?,
        loadFromScribeClient: (ScribeClient, @escaping DataAccessorDMCallback<T>) -> Void,
        save: @escaping (LevelDBStore, JSONObject) -> Void,
        callback: @escaping (AsyncResult<T>) -> Void
        ) {
        let store = self.dataStore
        let client = self.scribeClient
        if let jsonObject = loadFromDataStore(store) {
            let domainModel = T(from: jsonObject)
            callback(AsyncResult.success(domainModel))
        } else {
            loadFromScribeClient(client) { result in
                switch result {
                case .success(let modelObject):
                    let jsonObject = modelObject.asJSON()
                    save(store, jsonObject)
                    callback(AsyncResult.success(modelObject))
                case .failure(let error):
                    callback(AsyncResult.failure(error))
                }
            }
        }
    }
}
