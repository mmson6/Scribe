//
//  SaveSelectedReadingPlannerCommand.swift
//  Scribe
//
//  Created by Mikael Son on 10/13/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation


public class SaveSelectedReadingPlannerCommand: ScribeCommand<Bool> {
    
    var readingPlannerVOM: ReadingPlannerVOM?
    
    public override func main() {
        guard let model = self.readingPlannerVOM else { return }
        
        let dm = ReadingPlannerDM(from: model)
        self.accessor.saveSelectedReadingPlanner(dm: dm, callback: { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure(let error):
                self.completedWith(error: error)
            }
        })
    }
}
