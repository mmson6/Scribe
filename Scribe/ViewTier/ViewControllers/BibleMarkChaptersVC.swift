//
//  BibleMarkChaptersVC.swift
//  Scribe
//
//  Created by Mikael Son on 9/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

fileprivate let itemsPerRow: CGFloat = 5

protocol BibleMarkChaptersVCDelegate: class {
    func backgroundTappedToDismiss()
}

class BibleMarkChaptersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var closeIconLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var engTitleLabel: UILabel!
    @IBOutlet weak var korTitleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var layoutView: UIView!
    
    var plannerID: Int?
    var bookIdentifier: Int?
    var bookModel: BibleVOM?
    var plannerDataVOM: PlannerDataVOM?
    
    var previousMin: Int = 999
    var previousMax: Int = -1
    var min: Int = 999
    var max: Int = -1
    var selectedCellDict = JSONObject() {
        didSet {
            if self.selectedCellDict.count > 0 {
                self.applyButton.isEnabled = true
                self.applyButton.alpha = 1
            } else {
                self.applyButton.isEnabled = false
                self.applyButton.alpha = 0.5
            }
        }
    }
    
    weak var delegate: BibleMarkChaptersVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.layoutView.layer.cornerRadius = 15
        self.engTitleLabel.text = self.bookModel?.engName
        self.korTitleLabel.text = self.bookModel?.korName
        self.applyButton.layer.cornerRadius = self.applyButton.frame.height / 2
        self.applyButton.isEnabled = false
        self.applyButton.alpha = 0.5
        self.selectAllButton.layer.cornerRadius = self.selectAllButton.frame.height / 2
        self.selectAllButton.layer.borderColor = UIColor.rgb(red: 150, green: 150, blue: 150).cgColor
        self.selectAllButton.layer.borderWidth = 1
        self.closeIconLabel.text = "\u{f00d}"
    }
    
    private func updateCells() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = self.bookModel else { return }
            let chapters = model.chapters
            if self.selectedCellDict.count == 0 {
                self.previousMin = 999
                self.previousMax = -1
                self.min = 999
                self.max = -1
                
                for i in 0...chapters-1 {
                    let indexPath = IndexPath(item: i, section: 0)
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? MarkChapterCell {
                        DispatchQueue.main.async {
                            cell.didDeselect()
                        }
                    }
                }
            } else {
                let sorted = self.selectedCellDict.sorted(by: { (x, y) -> Bool in
                    guard let xKey = Int(x.key), let yKey = Int(y.key) else { return false }
                    return xKey < yKey
                })
                
                guard
                    let sortedFirst = sorted.first,
                    var min = Int(sortedFirst.key),
                    let sortedLast = sorted.last,
                    var max = Int(sortedLast.key)
                else {
                    return
                }
                
                self.min = min
                self.max = max
                
                if self.previousMin < min {
                    min = self.previousMin
                }
                if self.previousMax > max {
                    max = self.previousMax
                }

                self.previousMin = min
                self.previousMax = max
                
                for i in min...max {
                    let indexPath = IndexPath(item: i, section: 0)
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? MarkChapterCell {
                        DispatchQueue.main.async {
                            if self.selectedCellDict["\(indexPath.row)"] != nil {
                                cell.didSelect()
                            } else {
                                if i > self.min && i < self.max {
                                    cell.selectBackgroundView.backgroundColor = UIColor.Scribe.ReadingPlanner.bookChapterPossiblySelectedGreenColor
                                    cell.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
                                } else {
                                    cell.selectBackgroundView.backgroundColor = .white
                                    cell.chapterNumberLabel.textColor = UIColor.Scribe.ReadingPlanner.bookChapterTextColor
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                if self.selectedCellDict.count == chapters {
                    self.selectAllButton.setTitle("Deselect All", for: .normal)
                } else {
                    self.selectAllButton.setTitle("Select All", for: .normal)
                }
            }
        }
    }
    
    private func createMarkChaptersAlert() -> UIAlertController? {
        let alertController = UIAlertController(
            title: nil,
            message: MarkChaptersMessage,
            preferredStyle: .alert
        )
        
        let applySelectedOnlyAction = UIAlertAction(
            title: "Selected Only",
            style: .destructive,
            handler: { action in
                self.applyChapters()
        })
        
        let startingChapter = self.min + 1
        let endingChapter = self.max + 1
        let title = "Chapters \(startingChapter)~\(endingChapter)"
        let applyAllAction = UIAlertAction(
            title: title,
            style: .default,
            handler: { action in
                for i in self.min...self.max {
                    self.selectedCellDict["\(i)"] = true
                }
                self.applyChapters(isConsecutive: true)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(applySelectedOnlyAction)
        alertController.addAction(applyAllAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    private func applyChapters(isConsecutive: Bool = false) {
        isConsecutive ? self.saveMarkActivity() : self.saveMarkActivities()
        
        let userInfo: [String: Any] = ["identifier": self.bookIdentifier as Any]
        NotificationCenter.default.post(name: bibleChaptersUpdated, object: self.selectedCellDict, userInfo: userInfo)
        self.delegate?.backgroundTappedToDismiss()
    }
    
    private func saveMarkActivity() {
        guard let bookModel = self.bookModel else { return }
        let time = self.getTimeString()
        let model = PlannerActivityVOM(bookName: bookModel.engName,
                                       isConsecutive: true,
                                       chapterDict: self.selectedCellDict,
                                       min: self.min,
                                       max: self.max,
                                       time: time)
        
        let cmd = SavePlannerMarkActivityCommand()
        cmd.plannerID = self.plannerID
        cmd.plannerActivityData = model
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("Save MarkActivity returned with success")
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func saveMarkActivities() {
        guard let bookModel = self.bookModel else { return }
        let time = self.getTimeString()
        
        var array = [PlannerActivityVOM]()
        let sorted = self.selectedCellDict.sorted(by: { (x, y) -> Bool in
            guard let xKey = Int(x.key), let yKey = Int(y.key) else { return false }
            return xKey < yKey
        })
        
        var patternDict = JSONObject()
        var min = 999
        var foundPattern = false
        for (i, json) in sorted.enumerated() {
            if i < sorted.count - 1 {
                let next = sorted[i + 1]
                guard
                    let currentChapter = Int(json.key),
                    let nextChapter = Int(next.key)
                else {
                    continue
                }
                
                if nextChapter == currentChapter + 1 {
                    foundPattern = true
                    if min > currentChapter {
                        min = currentChapter
                    }
                    patternDict["\(currentChapter)"] = true
                    continue
                } else if foundPattern {
                    patternDict["\(currentChapter)"] = true
                    let model = PlannerActivityVOM(bookName: bookModel.engName,
                                                   isConsecutive: true,
                                                   chapterDict: patternDict,
                                                   min: min,
                                                   max: currentChapter,
                                                   time: time)
                    array.append(model)
                    min = 999
                    foundPattern = false
                    patternDict = [:]
                } else {
                    let dict: JSONObject = [json.key: true]
                    let model = PlannerActivityVOM(bookName: bookModel.engName,
                                                   isConsecutive: false,
                                                   chapterDict: dict,
                                                   min: currentChapter,
                                                   max: currentChapter,
                                                   time: time)
                    array.append(model)
                }
            } else {
                if foundPattern {
                    guard
                        let currentChapter = Int(json.key)
                    else {
                        continue
                    }
                    patternDict["\(currentChapter)"] = true
                    let model = PlannerActivityVOM(bookName: bookModel.engName,
                                                   isConsecutive: true,
                                                   chapterDict: patternDict,
                                                   min: min,
                                                   max: currentChapter,
                                                   time: time)
                    array.append(model)
                    min = 999
                    foundPattern = false
                    patternDict = [:]
                } else {
                    guard let chapter = Int(json.key) else { continue }
                    let dict: JSONObject = [json.key: true]
                    let model = PlannerActivityVOM(bookName: bookModel.engName,
                                                   isConsecutive: false,
                                                   chapterDict: dict,
                                                   min: chapter,
                                                   max: chapter,
                                                   time: time)
                    array.append(model)
                }
            }
        }
        
        let cmd = SavePlannerMarkActivitiesCommand()
        cmd.plannerID = self.plannerID
        cmd.plannerActivityDataSource = array
        cmd.onCompletion { result in
            switch result {
            case .success:
                NSLog("Save MarkActivities returned with success")
            case .failure:
                break
            }
        }
        cmd.execute()
    }
    
    private func getTimeString() -> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm"
        let dateString = dateFormatter.string(from: now)
        
        return dateString
        
        //https://stackoverflow.com/questions/45163271/swift-3-how-to-display-time-as-string-each-5-minutes
        //https://stackoverflow.com/questions/43199635/get-current-time-as-string-swift-3-0
    }
    
    // MARK: CollectionView Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = self.bookModel else { return 0 }
        return model.chapters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkChapterCell", for: indexPath) as? MarkChapterCell
        else {
            return UICollectionViewCell()
        }
        
        cell.commonInit()
        cell.drawCellRect(with: self.plannerDataVOM, index: indexPath.row)
        cell.selectionStatus = self.selectedCellDict["\(indexPath.row)"] != nil
        cell.updateCell(with: indexPath.row, min: self.min, max: self.max, and: self.selectedCellDict)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let chapterCell = cell as? MarkChapterCell
        else {
            return
        }
        chapterCell.selectionStatus = self.selectedCellDict["\(indexPath.row)"] != nil
        chapterCell.updateCell(with: indexPath.row, min: self.min, max: self.max, and: self.selectedCellDict)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 5 * (itemsPerRow - 1)
        let availableWidth = self.layoutView.frame.width - paddingSpace - 40
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? MarkChapterCell
        else {
            return true
        }
        
        if self.selectedCellDict["\(indexPath.row)"] != nil {
            cell.selectionStatus = false
            cell.cellTapped()
            self.selectedCellDict.removeValue(forKey: "\(indexPath.row)")
        } else {
            cell.selectionStatus = true
            cell.cellTapped()
            self.selectedCellDict["\(indexPath.row)"] = true
        }
        
        self.updateCells()
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? MarkChapterCell
        else {
            return
        }
        
        cell.didHighlight()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? MarkChapterCell
            else {
                return
        }
        
        cell.didUnhighlight()
    }
    
    // MARK: IBAction Functions
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        if ((self.max - self.min) + 1) != self.selectedCellDict.count {
            if let alertController = self.createMarkChaptersAlert() {
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            self.selectedCellDict.count > 1 ? self.applyChapters(isConsecutive: true) : self.applyChapters()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.backgroundTappedToDismiss()
    }
    
    @IBAction func outsideTapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.backgroundTappedToDismiss()
    }
    
    @IBAction func selectAllTapped(_ sender: UIButton) {
        guard let model = self.bookModel else { return }
        let chapters = model.chapters
        
        if self.selectedCellDict.count == chapters {
            print("ALL SELECTED")
            for i in 0...chapters - 1 {
                self.selectedCellDict.removeValue(forKey: "\(i)")
            }
        } else {
            for i in 0...chapters - 1 {
                self.selectedCellDict["\(i)"] = true
            }
        }

        self.updateCells()
    }
}
