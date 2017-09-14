//
//  BibleReadingPlannerVC.swift
//  Scribe
//
//  Created by Mikael Son on 9/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

class BibleReadingPlannerVC: UITableViewController, BibleMarkChaptersVCDelegate {
    
    var bibleDataSource = [BibleVOM]()
    var markChapterWindow: UIWindow?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Helper Functions
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateReadChapters), name: bibleChaptersUpdated, object: nil)
    }
    
    private func commonInit() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.separatorStyle = .none
        
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 1)
        bottomView.backgroundColor = UIColor.bookCellSeparatorColor
        self.tableView.tableFooterView = bottomView
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.bibleDataSource = BibleFactory.getAllList()
        }
    }
    
    @objc private func updateReadChapters(notification: Notification) {
        guard let dict = notification.object as? [Int: Bool] else { return }
        print(dict)
    }
    
    private func presentMarkingWindow(with model: BibleVOM) {
        let storyboard = UIStoryboard(name: "BibleReadingPlanner", bundle: nil)
        
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: "BibleMarkChaptersVC") as? BibleMarkChaptersVC
        else {
            return
        }
        vc.delegate = self
        vc.bookModel = model
        
        let window = UIWindow()
        window.windowLevel = window.windowLevel + 10
        window.backgroundColor = .clear
        window.rootViewController = vc
        window.makeKeyAndVisible()
        window.alpha = 0
        self.markChapterWindow = window
        UIView.animate(withDuration: 0.3) {
            window.alpha = 1
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bibleDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.bibleDataSource[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell
            else {
                return UITableViewCell()
        }
        
        cell.populate(with: model)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.bibleDataSource[indexPath.row]
        
        guard
            let cell = tableView.cellForRow(at: indexPath) as? BookCell
        else {
            return
        }
        
        self.presentMarkingWindow(with: model)
//        cell.updateCircle()
    }
    
    
    // MARK: IBAction Functions
    
    func backgroundTappedToDismiss() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.markChapterWindow?.alpha = 0
        }) { (_) in
            self.markChapterWindow = nil
        }
        
    }
}
