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
        guard let model = self.plannerActivityData else { return }
        let dm = PlannerActivityDM(from: model)
        
        self.accessor.savePlannerActivity(dm: dm) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure:
                break
            }
        }
    }
}
