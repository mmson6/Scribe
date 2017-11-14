//
//  FetchBiblePlannerDataCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchBiblePlannerDataCommand: ScribeCommand<[PlannerDataVOM]> {
    
    var plannerID: Int?
    
    public override func main() {
        guard let ID = self.plannerID else { return }
        
        self.accessor.loadBiblePlannerData(with: ID) { result in
            switch result {
            case .success(let array):
                let modelArray = array.map({ (dm) -> PlannerDataVOM in
                    let model = PlannerDataVOM(model: dm)
                    return model
                })
                self.completedWith(value: modelArray)
            case .failure:
                break
            }
        }
    }
}
