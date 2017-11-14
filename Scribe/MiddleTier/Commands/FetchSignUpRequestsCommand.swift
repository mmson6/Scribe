//
//  FetchSignUpRequestsCommand.swift
//  Scribe
//
//  Created by Mikael Son on 7/31/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public class FetchSignUpRequestsCommand: ScribeCommand<[SignUpRequestVOM]> {
    
    public override func main() {
        self.accessor.loadSignUpRequests { result in
            switch result {
            case .success(let dmArray):
                let models = dmArray.flatMap({ (signUpRequestDM) -> SignUpRequestVOM? in
                    let model = SignUpRequestVOM(model: signUpRequestDM)
                    return model
                })
                self.completedWith(value: models)
            case .failure(let error):
                print(error)
            }
        }
    }
}
