//
//  LevelDBStore.swift
//  Scribe
//
//  Created by Mikael Son on 7/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

import Objective_LevelDB


class LevelDBStore {
    
    private let queue = DispatchQueue(label: "scribe-datastore-" + UUID().uuidString, qos: .userInitiated)
    private let levelDB: LevelDB?
    
    // MARK: Lifecycle
    
    init() {
        let name = "scribe-cache.ldb"
        
        var options = LevelDBOptions()
        options.compression = true
        options.createIfMissing = true
        
        let appSupportURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        self.levelDB = LevelDB(path: appSupportURL.path, name: name, andOptions: options)
    }
    
    deinit {
        self.levelDB?.close()
    }
    
    // MARK: Public API
    
    // MARK: Global
    
    func clear() {
        self.levelDB?.removeAllObjects()
    }
    
    // MARK: Contact List Related Functions
    
    internal func loadContacts() -> JSONArray? {
        let key = "contacts"
        let object = self.loadJSONArray(forKey: key)
        return object
    }
    internal func save(contacts: JSONArray?) {
        let key = "contacts"
        self.save(value: contacts, forKey: key)
    }
    
    // MARK: Contact Detail Related Functions
    
    internal func loadContact(with id: Any) -> JSONObject?{
        let key = "contact_\(id)"
        let object = self.loadJSONObject(forKey: key)
        return object
    }
    internal func save(contact: JSONObject?) {
        guard
            let contactJSON = contact,
            let id = contactJSON["id"]
        else {
            return
        }
        
        let key = "contact_\(id)"
        self.save(value: contact, forKey: key)
    }
    
    
    // MARK: Private Helper Functions
    
    private func loadJSONArray(forKey key: String) -> JSONArray? {
        guard
            let value = loadValue(forKey: key),
            let object = value as? JSONArray
            else {
                return nil
        }
        
        return object
    }
    
    private func loadJSONObject(forKey key: String) -> JSONObject? {
        guard
            let value = loadValue(forKey: key),
            let object = value as? JSONObject
            else {
                return nil
        }
        
        return object
    }
    
    private func loadValue(forKey key: String) -> Any? {
        guard let ldb = self.levelDB else {
            NSLog("Error: Unable to load \(key): LevelDB is nil")
            return nil
        }
        
        var result: Any? = nil
        
        let valueKey = "value/\(key)"
        
        self.queue.sync {
            
            result = ldb.object(forKey: valueKey)
        }
        
        return result
    }
    
    private func save(value: Any?, forKey key: String) -> Void {
        guard let ldb = self.levelDB else {
            NSLog("Error: Unable to save \(key): LevelDB is nil")
            return
        }
        
        let valueKey = "value/\(key)"
        
        self.queue.async {
            
            guard let batch = ldb.newWritebatch() else {
                NSLog("Error: Unable to save \(key): cannot create atomic operation")
                return
            }
            
            if let safeValue = value {
                batch.setObject(safeValue, forKey: valueKey)
            } else {
                batch.removeObject(forKey: valueKey)
            }
            
            batch.apply()
        }
    }
}
