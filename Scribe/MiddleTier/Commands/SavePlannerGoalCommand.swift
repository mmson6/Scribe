//
//  SavePlannerGoalCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SavePlannerGoalCommand: ScribeCommand<Bool> {
    
    var plannerGoalData: PlannerGoalVOM?
    var selectedPlanner: ReadingPlannerVOM?
    
    public override func main() {
        guard
            let plannerGoalData = self.plannerGoalData,
            let selectedPlanner = self.selectedPlanner
        else {
            return
        }
        
        let dm = PlannerGoalDM(from: plannerGoalData.asJSON())
        let selectedPlannerDM = ReadingPlannerDM(from: selectedPlanner.asJSON())
        self.accessor.savePlannerGoal(dm: dm, with: selectedPlannerDM) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
