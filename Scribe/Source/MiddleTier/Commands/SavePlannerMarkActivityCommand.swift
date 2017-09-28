//
//  SavePlannerMarkActivityCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SavePlannerMarkActivityCommand: ScribeCommand<Bool> {
    
    var plannerActivityData: PlannerActivityVOM?
    
    public override func main() {
//        guard let modelArray = self.plannerActivityDataSource else { return }
        guard let model = self.plannerActivityData else { return }
        let dm = PlannerActivityDM(from: model)
        
        self.accessor.savePlannerActivity(dm: dm) { result in
            switch result {
            case .success:
                NSLog("SavePlannerMarkActivityCommand called")
            case .failure:
                break
            }
        }
//        let dmArray = modelArray.map { (model) -> PlannerActivityDM in
//            let dm = PlannerActivityDM(from: model)
//            return dm
//        }
//        
//        self.accessor.savePlannerActivities(dmArray: dmArray) { result in
//            switch result {
//            case .success:
//                NSLog("SavePlannerMarkActivityCommand called")
//            case .failure:
//                break
//            }
//        }
    }
}
