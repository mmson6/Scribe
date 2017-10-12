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
    
    @IBOutlet var topPlanTrackerView: TopPlanTrackerView!
    @IBOutlet var bottomPlanTrackerView: BottomPlanTrackerView!
    var planTrackerViewsHidden = false
    var showPlanTrackerDueToUpdate = false
    var bibleDataSource = [BibleVOM]()
    var plannerDataSource = [PlannerDataVOM]()
    var plannerGoalModel: PlannerGoalsVOM?
    var markChapterWindow: UIWindow?
    var planTrackerTimer: Timer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.showPlanTrackerDueToUpdate {
            self.displayPlanTrackerViewsWithTimer()
        }
        self.bottomPlanTrackerView.isHidden = false
        self.topPlanTrackerView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bottomPlanTrackerView.isHidden = true
        self.topPlanTrackerView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Helper Functions
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateReadChapters), name: bibleChaptersUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchUpdatedBiblePlannerData), name: biblePlannerDataUpdatedFromSettings, object: nil)
    }
    
    private func commonInit() {
        
        // Initialize TopPlanTrackerView
        guard
            let navController = self.navigationController,
            let tabBarController = self.tabBarController
            else {
                return
        }
        navController.view.addSubview(self.topPlanTrackerView)
        navController.view.insertSubview(self.topPlanTrackerView, belowSubview: navController.navigationBar)
        var topFrame = self.topPlanTrackerView.frame
        topFrame.size.width = navController.view.frame.width
        topFrame.origin.y = navController.navigationBar.frame.height + navController.navigationBar.frame.origin.y
        self.topPlanTrackerView.frame = topFrame
        self.topPlanTrackerView.initAttributes()
        
        // Initialize BottomPlanTrackerView
        
        navController.view.addSubview(self.bottomPlanTrackerView)
        self.bottomPlanTrackerView.center.x = self.tableView.center.x
        var bottomFrame = self.bottomPlanTrackerView.frame
        bottomFrame.origin.y = navController.view.frame.height - self.bottomPlanTrackerView.frame.height - tabBarController.tabBar.frame.height + 22
        self.bottomPlanTrackerView.frame = bottomFrame
        
        self.bottomPlanTrackerView.initAttributes()
        
        
        // Initialize Table View
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 440
        self.tableView.separatorStyle = .none
        
        // Initialize Table View Bottom View
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 33))
        bottomView.backgroundColor = UIColor.rgb(red: 223, green: 223, blue: 223)
        let bottomViewSeparator = UIView(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 1))
        bottomViewSeparator.backgroundColor = UIColor.bookCellSeparatorColor
        bottomView.addSubview(bottomViewSeparator)
        bottomViewSeparator.topAnchor.constraint(equalTo: bottomViewSeparator.topAnchor).isActive = true
        self.tableView.tableFooterView = bottomView
    }
    
    private func fetchData() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bibleDataSource = BibleFactory.getAllList()
            self.fetchPlannerDataSource()
        }
    }
    
    private func fetchPlannerDataSource() {
        let cmd = FetchBiblePlannerDataCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let array):
                if array.count > 0 {
                    self.plannerDataSource = array
                } else {
                    var fetchingData = [PlannerDataVOM]()
                    for model in self.bibleDataSource {
                        var json: JSONObject = [:]
                        for i in 0...model.chapters - 1 {
                            json["\(i)"] = 0
                        }
                        fetchingData.append(PlannerDataVOM(bookName: model.engName, chaptersReadCount: json))
                    }
                    self.plannerDataSource = fetchingData
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                break
            }
            self.fetchBiblePlannerGoals()
        }
        cmd.execute()
    }
    
    // Fetch data for PlanTrackerViews
    private func fetchBiblePlannerGoals() {
        let cmd = FetchPlannerGoalsCommand()
        cmd.onCompletion { result in
            switch result {
            case .success(let model):
                NSLog("FetchPlannerGoalsCommand returned with success")
                self.plannerGoalModel = model
                self.fetchPlanTrackers(with: model)
            case .failure:
                NSLog("FetchPlannerGoalsCommand returned with failure")
                self.setPlannerInitialGoal()
            }
            if !self.showPlanTrackerDueToUpdate {
                self.displayPlanTrackerViewsWithTimer()
            }
        }
        cmd.execute()
    }
    
    private func setPlannerInitialGoal() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let startDate = dateFormatter.string(from: Date())
        var endDate = ""
        if let last = Date.lastDayOfYear() {
            endDate = dateFormatter.string(from: last)
        }
        
        var json = JSONObject()
        json["startDate"] = startDate
        json["endDate"] = endDate
        json["OTGoal"] = 1
        json["NTGoal"] = 1
        
        let model = PlannerGoalsVOM(from: json)
        self.plannerGoalModel = model
        self.savePlannerGoalsToDB(with: model)
        self.fetchPlanTrackers(with: model)
    }
    
    private func savePlannerGoalsToDB(with model: PlannerGoalsVOM) {
        let cmd = SavePlannerGoalsCommand()
        cmd.plannerGoalsData = model
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("SavePlannerGoalCommand returned with success")
            case .failure:
                NSLog("SavePlannerGoalCommand returned with failure")
            }
        }
        cmd.execute()
    }
    
    private func savePlannerDataSource() {
        let cmd = SaveBiblePlannerDataCommand()
        cmd.plannerDataSource = self.plannerDataSource
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("SaveBiblePlannerDataCommand returned with success")
                if let goalModel = self.plannerGoalModel {
                    self.fetchPlanTrackers(with: goalModel)
                }
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    @objc private func fetchUpdatedBiblePlannerData(notification: Notification) {
        // Show plan tracker views for 5 sec with flag
        self.showPlanTrackerDueToUpdate = true
        
        DispatchQueue.global(qos: .default).async {
            self.fetchPlannerDataSource()
        }
    }
    
    @objc private func updateReadChapters(notification: Notification) {
        // Show plan tracker views for 5 sec
        self.displayPlanTrackerViewsWithTimer()
        
        guard
            let dict = notification.object as? JSONObject,
            let userInfo = notification.userInfo as? [String: Int],
            let identifier = userInfo["identifier"]
        else {
            return
        }
        
        var plannerDataVOM = self.plannerDataSource[identifier]
        var json = plannerDataVOM.chaptersReadCount
        
        for object in dict {
            guard let count = json["\(object.key)"] as? Int else { return }
            json["\(object.key)"] = count + 1
        }
        
        plannerDataVOM.chaptersReadCount = json
        self.plannerDataSource[identifier] = plannerDataVOM
        self.savePlannerDataSource()
        
        let indexPath = IndexPath(row: identifier, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    private func presentMarkingWindow(with bookModel: BibleVOM, plannerDataVOM: PlannerDataVOM, identifier: Int) {
        let storyboard = UIStoryboard(name: "BibleReadingPlanner", bundle: nil)
        
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: "BibleMarkChaptersVC") as? BibleMarkChaptersVC
        else {
            return
        }
        vc.delegate = self
        vc.bookModel = bookModel
        vc.bookIdentifier = identifier
        vc.plannerDataVOM = plannerDataVOM
        
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
    
    private func displayPlanTrackerViewsWithTimer() {
        self.showPlanTrackerDueToUpdate = false
        self.planTrackerTimer?.invalidate()
        self.showPlanTrackerViews()
        self.planTrackerTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            self.hidePlanTrackerViews()
            timer.invalidate()
        })
    }
    
    private func showPlanTrackerViews() {
        self.showTopPlanTrackerView()
        self.showBottomPlanTrackerView()
    }
    
    private func hidePlanTrackerViews() {
        self.hideTopPlanTrackerView()
        self.hideBottomPlanTrackerView()
    }
    
    private func hideBottomPlanTrackerView() {
        self.planTrackerViewsHidden = true
        
        let translationHeight = self.bottomPlanTrackerView.frame.height - self.bottomPlanTrackerView.targetPeriodLabel.frame.height - 14 - 25
        let animateHide = CGAffineTransform(translationX: 0, y: translationHeight)
        
        UIView.beginAnimations("animateHideBottom", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.7)
        UIView.setAnimationCurve(.easeInOut)
        self.bottomPlanTrackerView.transform = animateHide
        UIView.commitAnimations()
    }
    
    private func hideTopPlanTrackerView() {
        let animateHide = CGAffineTransform(translationX: 0, y: -self.topPlanTrackerView.frame.height)
        
        UIView.beginAnimations("animateHideTop", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.7)
        UIView.setAnimationCurve(.easeInOut)
        self.topPlanTrackerView.transform = animateHide
        UIView.commitAnimations()
    }
    
    private func showTopPlanTrackerView() {
        UIView.beginAnimations("animateShowTop", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.7)
        UIView.setAnimationCurve(.easeInOut)
        self.topPlanTrackerView.transform = CGAffineTransform.identity
        UIView.commitAnimations()
    }
    
    private func showBottomPlanTrackerView() {
        self.planTrackerViewsHidden = false
        
        UIView.beginAnimations("animateShowBottom", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.7)
        UIView.setAnimationCurve(.easeInOut)
        self.bottomPlanTrackerView.transform = CGAffineTransform.identity
        UIView.commitAnimations()
    }
    
    private func fetchPlanTrackers(with model: PlannerGoalsVOM) {
        self.topPlanTrackerView.update(with: model, and: self.plannerDataSource)
        self.bottomPlanTrackerView.update(with: model, and: self.plannerDataSource, and: self.bibleDataSource)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bibleDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            self.bibleDataSource.count > 0,
            self.plannerDataSource.count > 0
        else {
            return UITableViewCell()
        }
        
        let model = self.bibleDataSource[indexPath.row]
        let chapterCounter = self.plannerDataSource[indexPath.row]
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell
            else {
                return UITableViewCell()
        }
        UITableViewCell.applyScribePlannerCellAttributes(to: cell)
        cell.populate(with: model, and: chapterCounter)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let bookModel = self.bibleDataSource[indexPath.row]
        let chapterCounterModel = self.plannerDataSource[indexPath.row]
        self.presentMarkingWindow(with: bookModel, plannerDataVOM: chapterCounterModel, identifier: indexPath.row)
    }
    
    
    // MARK: IBAction Functions
    
    func backgroundTappedToDismiss() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.markChapterWindow?.alpha = 0
        }) { (_) in
            self.markChapterWindow = nil
        }
    }
    
    @IBAction func handlePlanTrackerTapped(_ sender: UITapGestureRecognizer) {
        self.planTrackerTimer?.invalidate()
        self.planTrackerViewsHidden ? self.showPlanTrackerViews() : self.hidePlanTrackerViews()
    }
}
