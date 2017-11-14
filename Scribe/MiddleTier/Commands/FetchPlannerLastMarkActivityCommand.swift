//
//  FetchPlannerLastMarkActivityCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchPlannerLastMarkActivityCommand: ScribeCommand<PlannerActivityVOM> {
    
    var plannerID: Int?
    
    public override func main() {
        guard let ID = self.plannerID else { return }
        
        self.accessor.loadPlannerLastActivity(with: ID) { result in
            switch result {
            case .success(let dm):
                let model = PlannerActivityVOM(from: dm)
                self.completedWith(value: model)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}
