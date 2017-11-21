//
//  SelectReadingPlannerCommand.swift
//  Scribe
//
//  Created by Mikael Son on 11/14/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SelectReadingPlannerCommand: ScribeCommand<Bool> {
    
    var readingPlannerModel: ReadingPlannerVOM?
    var new: Bool = false
    
    public override func main() {
        guard let readingPlannerModel = self.readingPlannerModel else { return }
        let dm = ReadingPlannerDM(from: readingPlannerModel.asJSON())
        
        self.accessor.selectReadingPlanner(dm: dm, isNew: self.new) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        }
    }
}

