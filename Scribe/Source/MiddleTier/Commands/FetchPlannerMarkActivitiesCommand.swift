//
//  FetchPlannerMarkActivitiesCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/28/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchPlannerMarkActivitiesCommand: ScribeCommand<[PlannerActivityVOM]> {
    
    public override func main() {
        
        self.accessor.loadPlannerActivities { result in
            switch result {
            case .success(let array):
                let modelArray = array.map({ (dm) -> PlannerActivityVOM in
                    let model = PlannerActivityVOM(from: dm)
                    return model
                })
                self.completedWith(value: modelArray)
            case .failure:
                break
            }
        }
    }
}
