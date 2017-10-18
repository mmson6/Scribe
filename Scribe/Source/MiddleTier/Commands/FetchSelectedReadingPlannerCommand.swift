//
//  FetchSelectedReadingPlannerCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchSelectedReadingPlannerCommand: ScribeCommand<ReadingPlannerVOM> {
    
    public override func main() {
        self.accessor.loadSelectedReadingPlanner { result in
            switch result {
            case .success(let dm):
                let model = ReadingPlannerVOM(model: dm)
                self.completedWith(value: model)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
