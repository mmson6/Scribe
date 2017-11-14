//
//  FetchContactsVersionCommand.swift
//  Scribe
//
//  Created by Mikael Son on 8/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchContactsVersionCommand: ScribeCommand<Int64> {
    
    public override func main() {
        self.accessor.loadContactsVersion { result in
            switch result {
            case .success(let ver):
                self.completedWith(value: ver)
                break
            case .failure(let error):
                NSLog("Error occurred while fetching contactsVer:: \(error)")
                self.completedWith(value: 0)
            }
        }
    }
}
