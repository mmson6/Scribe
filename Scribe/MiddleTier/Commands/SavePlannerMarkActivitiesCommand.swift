//
//  SavePlannerMarkActivitiesCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SavePlannerMarkActivitiesCommand: ScribeCommand<Bool> {
    
    var plannerID: Int?
    var plannerActivityDataSource: [PlannerActivityVOM]?
    
    public override func main() {
        guard
            let modelArray = self.plannerActivityDataSource,
            let ID = self.plannerID
        else {
            return
        }
        
        let dmArray = modelArray.map { (model) -> PlannerActivityDM in
            let dm = PlannerActivityDM(from: model)
            return dm
        }
        
        self.accessor.savePlannerActivities(dmArray: dmArray, with: ID) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure:
                break
            }
        }
    }
}
