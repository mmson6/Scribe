//
//  SavePlannerGoalCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SavePlannerGoalCommand: ScribeCommand<Bool> {
    
    var plannerID: Int?
    var plannerGoalData: PlannerGoalVOM?
    
    public override func main() {
        guard let model = self.plannerGoalData, let ID = self.plannerID else { return }
        
        let dm = PlannerGoalDM(from: model.asJSON())
        self.accessor.savePlannerGoal(dm: dm, with: ID) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
