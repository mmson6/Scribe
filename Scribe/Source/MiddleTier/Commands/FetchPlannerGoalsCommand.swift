//
//  FetchPlannerGoalsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchPlannerGoalsCommand: ScribeCommand<PlannerGoalsVOM> {
    
    public override func main() {

        self.accessor.loadPlannerGoals { result in
            switch result {
            case .success(let dm):
                let model = PlannerGoalsVOM(from: dm.asJSON())
                self.completedWith(value: model)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
