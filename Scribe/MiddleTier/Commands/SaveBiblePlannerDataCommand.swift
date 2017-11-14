//
//  SaveBiblePlannerDataCommand.swift
//  Scribe
//
//  Created by Mikael Son on 9/27/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class SaveBiblePlannerDataCommand: ScribeCommand<Bool> {

    var plannerDataSource: [PlannerDataVOM]?
    
    public override func main() {
        guard let modelArray = self.plannerDataSource else { return }
        
        let dmArray = modelArray.map { (model) -> PlannerDataDM in
            let dm = PlannerDataDM(bookName: model.bookName, chaptersReadCount: model.chaptersReadCount)
            return dm
        }
        
        self.accessor.saveBiblePlannerData(dmArray: dmArray) { result in
            switch result {
            case .success:
                self.completedWith(value: true)
            case .failure:
                break
            }
        }
    }
}
