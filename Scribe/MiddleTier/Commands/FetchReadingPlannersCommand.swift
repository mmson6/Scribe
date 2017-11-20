//
//  FetchReadingPlannersCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchReadingPlannersCommand: ScribeCommand<[ReadingPlannerVOM]> {
    
    public override func main() {
        
        self.accessor.loadReadingPlanners { result in
            switch result {
            case .success(let array):
                let modelArray = array.map({ dm -> ReadingPlannerVOM in
                    let model = ReadingPlannerVOM(model: dm)
                    return model
                })
                self.completedWith(value: modelArray)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
