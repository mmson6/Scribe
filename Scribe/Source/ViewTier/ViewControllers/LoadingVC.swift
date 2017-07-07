//
//  LoadingVC.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FirebaseAuth


class LoadingVC: UIViewController {

    public var contactDataSource = [ContactVOM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.runLifeCycle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchContactDataSource() {
//        
//        let ctd: [[String: Any]] = 	[
//            [
//                "name_kor": "안명숙",
//                "name_eng": "Myungsook Ahn",
//                "phone": "8476368041",
//                "address": "10373 Dearlove Road #3E, Glenview, IL 60025",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "11"
//            ],
//            [
//                "name_kor": "백중현",
//                "name_eng": "John Baek",
//                "phone": "6309949989",
//                "address": "23801 Tallgrass Drive, Plainfield, IL 60658",
//                "group": "Fathers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "11"
//            ],
//            [
//                "name_kor": "김경민",
//                "name_eng": "Ace Bowling",
//                "phone": "8478262343",
//                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
//                "group": "Young Adults",
//                "teacher": true,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "",
//                "name_eng": "Ryan Bowling",
//                "phone": "8478264755",
//                "address": "265 Washington Boulevard, Hoffman Estates, IL 60169",
//                "group": "Young Adults",
//                "teacher": true,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "변영희",
//                "name_eng": "Younghee Byun",
//                "phone": "2246228329",
//                "address": "1509 Summerhill Lane, Cary IL 60013",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "21"
//            ],
//            [
//                "name_kor": "장혜숙",
//                "name_eng": "Hazel Chang",
//                "phone": "6308809345",
//                "address": "2426 North Kennicott Drive #2B, Arlington Heights, IL 60004",
//                "group": "Mothers",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "31"
//            ],
//            [
//                "name_kor": "지시현",
//                "name_eng": "Anna Chee",
//                "phone": "2244028225",
//                "address": "813 West Springfied Avenue APT 101, Urbana, IL 61801",
//                "group": "Young Adults",
//                "teacher": false,
//                "choir": false,
//                "translator": false,
//                "district": "21"
//            ]
//        ]
//    
//        let models = ctd.enumerated().flatMap({ (index, jsonObj) -> ContactVOM? in
//            let index64 = Int64(index)
//            let dm = ContactDM(from: jsonObj, with: index64)
//            let model = ContactVOM(model: dm)
//            return model
//        })
//            
//        self.contactDataSource = models
//        self.performSegueToMain()
        let cmd = FetchContactsCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                self.contactDataSource = array
                self.performSegueToMain()
                break
            case .failure(let error):
                NSLog("error occurred: \(error)")
            }
        }
        cmd.execute()
    }
    
    // MARK: - Navigation
    
    private func performSegueToLogin() {
        self.performSegue(withIdentifier: "loadingToLogin", sender: nil)
    }
    
    private func performSegueToMain() {
        self.performSegue(withIdentifier: "loadingToMain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loadingToMain" {
            guard
                let vc = segue.destination as? MainTabBarVC
                else {
                    return
            }
            guard
                let navController = vc.viewControllers?[0] as? UINavigationController,
                let contactVC = navController.topViewController as? ContactsCoordinatorVC
                else {
                    return
            }
            
            contactVC.contactDataSource = self.contactDataSource
        }
    }
    
    private func runLifeCycle() {
//        if Auth.auth().currentUser != nil {
            self.fetchContactDataSource()
//        } else {
//            self.performSegueToLogin()
//        }
    }
    
    @IBAction func unwindToLandingView(segue: UIStoryboardSegue) {
        
    }
    
}
