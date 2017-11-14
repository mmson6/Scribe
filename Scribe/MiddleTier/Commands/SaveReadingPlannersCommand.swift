//
//  SaveReadingPlannersCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/25/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SaveReadingPlannersCommand: ScribeCommand<Bool> {
    
    var readingPlannerDS: [ReadingPlannerVOM]?
    
    public override func main() {
        guard let models = self.readingPlannerDS else { return }
        let dmArray = models.map { (model) -> ReadingPlannerDM in
            let dm = ReadingPlannerDM(from: model)
            return dm
        }
        
        self.accessor.saveReadingPlanners(dmArray: dmArray) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}

