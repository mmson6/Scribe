//
//  SavePlannerGoalsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SavePlannerGoalsCommand: ScribeCommand<Bool> {
    
    var plannerGoalsData: PlannerGoalsVOM?
    
    public override func main() {
        guard let model = self.plannerGoalsData else { return }
        let dm = PlannerGoalsDM(from: model.asJSON())
        self.accessor.savePlannerGoals(dm: dm) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
