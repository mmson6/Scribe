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
    
    // MARK: Bible Planner Related Functions
    
    internal func loadBiblePlannerData() -> JSONArray? {
        let key = "bible_planner_data"
        let array = self.loadJSONArray(forKey: key)
        return array
    }
    internal func save(plannerData: JSONArray?) {
        let key = "bible_planner_data"
        self.save(value: plannerData, forKey: key)
    }
    
    internal func loadPlannerActivities(with ID: Int) -> JSONArray? {
        let key = "bible_planner_activities_\(ID)"
        let array = self.loadJSONArray(forKey: key)
        return array
    }
    internal func save(plannerActivities: JSONArray?, with ID: Int) {
        let key = "bible_planner_activities_\(ID)"
        self.save(value: plannerActivities, forKey: key)
    }
    
    internal func loadPlannerGoal(with ID: Int) -> JSONObject? {
        let key = "bible_planner_goals_\(ID)"
        let object = self.loadJSONObject(forKey: key)
        return object
    }
    internal func save(plannerGoal: JSONObject?, with ID: Int) {
        let key = "bible_planner_goals_\(ID)"
        self.save(value: plannerGoal, forKey: key)
    }
    
    internal func loadReadingPlanners() -> JSONArray? {
        let key = "bible_reading_planners"
        let array = self.loadJSONArray(forKey: key)
        return array
    }
    internal func save(readingPlanners: JSONArray?) {
        let key = "bible_reading_planners"
        self.save(value: readingPlanners, forKey: key)
    }
    
    // MARK: Contact List Related Functions
    
    internal func loadContacts() -> JSONArray? {
        let key = "contacts"
        let array = self.loadJSONArray(forKey: key)
        return array
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
            let array = value as? JSONArray
        else {
            return nil
        }
        
        return array
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
