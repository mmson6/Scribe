//
//  RemoveBiblePlannerDataCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class RemoveBiblePlannerDataCommand: ScribeCommand<Bool> {
    
    var plannerActivityData: PlannerActivityVOM?
    var selectedPlanner: ReadingPlannerVOM?
    
    public override func main() {
        guard
            let model = self.plannerActivityData,
            let selectedPlanner = self.selectedPlanner
        else {
            return
        }
        
        let activityDM = PlannerActivityDM(from: model)
        let plannerDM = ReadingPlannerDM(from: selectedPlanner)
        
        self.accessor.removeBiblePlannerData(dm: activityDM, with: plannerDM) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure:
                break
            }
        }
    }
}
