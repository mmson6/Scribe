//
//  MainVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    public var contactDataSource: ObjectDataSource<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}