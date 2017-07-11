//
//  UserDefaultsStore.swift
//  Scribe
//
//  Created by Mikael Son on 7/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

class UserDefaultsStore {
    
    let store = UserDefaults.standard
    
    // MARK: Contacts Related Functions
    
    internal func saveContactsVer(_ ver: Int64) {
        self.store.setValue(ver, forKey: "contacts_ver")
        NSLog("ContactsVer updated to \(ver)")
    }
    
    internal func loadContactsVer() -> Int64 {
        let ver = self.store.integer(forKey: "contacts_ver")
        return Int64(ver)
    }
    
    internal func contactsNeedUpdate(_ ver: Int64) -> Bool {
        let localVerInt = self.store.integer(forKey: "contacts_ver")
        let localVer = Int64(localVerInt)
        return localVer >= ver ? false : true
    }
    
    // MARK: Language Related Functions
    
    internal func saveMainLanguage(_ lang: String?) {
        self.store.setValue(lang, forKey: "main_language")
    }
    
    internal func loadMainLanguage() -> String? {
        let lang = self.store.string(forKey: "main_language")
        return lang
    }
    
    // MARK: Helper Functions
    
    internal func clearAll() {
        self.store.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    
}
