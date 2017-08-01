//
//  MainTabBarController.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

import FontAwesomeKit


class MainTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.commonInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeTabBarItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.showTabs()
    }
    
    private func initializeTabBarItems() {
        let settingsIcon = FAKMaterialIcons.settingsIcon(withSize: 27)
        let contactIcon = FAKIonIcons.iosContactIcon(withSize: 30)
        
        if let tabBarItems = self.tabBar.items {
            tabBarItems[0].image = contactIcon?.image(with: CGSize(width: 30, height: 30))
            tabBarItems[1].image = settingsIcon?.image(with: CGSize(width: 30, height: 30))
            self.view.layoutIfNeeded()
        }
    }

    private func showTabs() {
        guard
            let contactsVC = UIStoryboard.init(name: "Contacts", bundle: nil).instantiateInitialViewController(),
            let settingsVC = UIStoryboard.init(name: "Settings", bundle: nil).instantiateInitialViewController(),
            let adminSettingsVC = UIStoryboard.init(name: "AdminSettings", bundle: nil).instantiateInitialViewController()
        else {
            return
        }

        self.viewControllers = [contactsVC, settingsVC, adminSettingsVC]
        self.selectedIndex = 0
    
    }
}
