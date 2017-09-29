//
//  HandleSignOutCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class HandleSignOutCommand: ScribeCommand<Bool> {
    
    public override func main() {
        self.accessor.clear()
    }
}
