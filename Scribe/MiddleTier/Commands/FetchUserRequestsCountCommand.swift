//
//  FetchUserRequestsCountCommand.swift
//  Scribe
//
//  Created by Mikael Son on 8/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchUserRequestsCountCommand: ScribeCommand<Int64> {
    
    public override func main() {
        self.accessor.loadUserRequestsCount { result in
            switch result {
            case .success(let count):
                self.completedWith(value: count)
            case .failure:
                break
            }
        }
    }
}
