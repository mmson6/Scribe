//
//  RemovePlannerMarkActivityCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class RemovePlannerMarkActivityCommand: ScribeCommand<Bool> {
    
    var plannerActivityDataSource: [PlannerActivityVOM]?
    
    public override func main() {
        guard let modelArray = self.plannerActivityDataSource else { return }
        
        let dmArray = modelArray.map { (model) -> PlannerActivityDM in
            let dm = PlannerActivityDM(from: model)
            return dm
        }
        self.accessor.removePlannerActivity(dmArray: dmArray) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure:
                break
            }
        }
    }
}
