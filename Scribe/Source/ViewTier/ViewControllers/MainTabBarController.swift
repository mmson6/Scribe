//
//  MainTabBarController.swift
//  Scribe
//
//  Created by Mikael Son on 6/15/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit
import UserNotifications

import FontAwesomeKit
import FirebaseDatabase


class MainTabBarController: UITabBarController {

    var authorization: Authorization = .none
    var lastSelectedTabBarItem: UITabBarItem?
    
    // Store all firebase database reference obserbers to remove at deinit later
    var fbObserverRefs = [DatabaseReference]()
    
    
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
    
    deinit {
        // Clear all observers
        NotificationCenter.default.removeObserver(self)
        self.fbObserverRefs.forEach({ $0.removeAllObservers() })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.addObservers()
        self.confirmAuthorization()
        self.showTabs(forAuthorization: self.authorization)
    }
    
    private func addObservers() {
        let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
        let contactVerRef = ref.child("users/requests/signup")
        self.fbObserverRefs.append(contactVerRef)
        self.fbObserverRefs.last!.observe(.childAdded, with: { [weak self] snap in
            guard let strongSelf = self else { return }
            strongSelf.checkForUserRequests()
        })
        self.fbObserverRefs.last!.observe(.childRemoved, with: { [weak self] snap in
            guard let strongSelf = self else { return }
            strongSelf.checkForUserRequests()
        })
        self.fbObserverRefs.last!.observe(.childChanged, with: { [weak self] snap in
            guard let strongSelf = self else { return }
            strongSelf.checkForUserRequests()
        })
        
        
        NotificationCenter.default.addObserver(
            forName: openFromSignUpRequest,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }

                let index = strongSelf.selectedIndex
                for vc in strongSelf.viewControllers! {
                    if let vc = vc as? UINavigationController {
                        vc.popToRootViewController(animated: false)
                    }
                }

                strongSelf.selectedIndex = 2
                if let tabBarItems = strongSelf.tabBar.items?[2] {
                    strongSelf.tabBar(strongSelf.tabBar, didSelect: tabBarItems)
                }
            }
        }
    }
    
    private func confirmAuthorization() {
        let store = UserDefaultsStore()
        if store.checkUserAdminStatus() {
            self.authorization = .admin
        } else {
            self.authorization = .none
        }
    }
    
    private func initializeTabBarItems() {
//        let settingsIcon = FAKMaterialIcons.settingsIcon(withSize: 27)
//        let contactIcon = FAKIonIcons.iosContactIcon(withSize: 30)
        
        if let tabBarItems = self.tabBar.items {
//            tabBarItems[0].image = contactIcon?.image(with: CGSize(width: 30, height: 30))
            tabBarItems[1].image = UIImage(named: "Open_Book_Filled_75")
            tabBarItems[2].image = UIImage(named: "Settings_75")
//            tabBarItems[2].image = settingsIcon?.image(with: CGSize(width: 30, height: 30))
            if tabBarItems.count > 3 {
                tabBarItems[3].image = UIImage(named: "Admin_Filled_75")
            }
            self.view.layoutIfNeeded()
        }
    }

    private func showTabs(forAuthorization authorization: Authorization) {
        guard
            let contactsVC = UIStoryboard.init(name: "Contacts", bundle: nil).instantiateInitialViewController(),
            let plannerVC = UIStoryboard.init(name: "BibleReadingPlanner", bundle: nil).instantiateInitialViewController(),
            let settingsVC = UIStoryboard.init(name: "Settings", bundle: nil).instantiateInitialViewController(),
            let adminSettingsVC = UIStoryboard.init(name: "AdminSettings", bundle: nil).instantiateInitialViewController()
        else {
            return
        }

        switch authorization {
        case .none:
            self.viewControllers = [contactsVC, plannerVC, settingsVC]
        case .admin:
            self.viewControllers = [contactsVC, plannerVC, settingsVC, adminSettingsVC]
            self.checkForUserRequests()
        }
        
        self.selectedIndex = 0
    }
    
    private func checkForUserRequests() {
        DispatchQueue.main.async {
            self.fetchUserRequestsCount()
        }
    }
    
    private func fetchUserRequestsCount() {
        let cmd = FetchUserRequestsCountCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let count):
                self.updateTabBarBadge(with: count)
                break
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func updateTabBarBadge(with count: Int64) {
        guard
            let tabArray = self.tabBar.items,
            let tabItem = tabArray.last
        else {
            return
        }
        
        if count > 0 {
            tabItem.badgeValue = "\(count)"
        } else {
            tabItem.badgeValue = nil
        }
        
        if self.selectedIndex == tabArray.count - 1 {
            tabItem.badgeColor = .clear
            
            // Notify AdminSettingsVC to update the badge since the vc only update on ViewWillAppear()
            NotificationCenter.default.post(name: userRequestsCountChanged, object: nil)
        } else {
            tabItem.badgeColor = UIColor.scribeDesignTwoRed
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.lastSelectedTabBarItem?.badgeColor = UIColor.scribeDesignTwoRed
        
        item.badgeColor = .clear
        self.lastSelectedTabBarItem = item
    }
}
