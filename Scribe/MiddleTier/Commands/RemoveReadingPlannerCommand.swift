//
//  RemoveReadingPlannerCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/26/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class RemoveReadingPlannerCommand: ScribeCommand<Bool> {
    
    var plannerModel: ReadingPlannerVOM?
    
    public override func main() {
        guard let model = self.plannerModel else { return }
        
        self.accessor.removeReadingPlanner(model: model) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}

