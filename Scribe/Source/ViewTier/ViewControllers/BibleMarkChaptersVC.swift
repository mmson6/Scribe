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

class BibleMarkChaptersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var engTitleLabel: UILabel!
    @IBOutlet weak var korTitleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var layoutView: UIView!
    
    var min: Int = 999
    var max: Int = -1
    var selectedCellDict: [Int: Bool] = [:]
    var selectedChapters: [Int] = [] {
        didSet {
            var oldItems: [IndexPath] = []
            if self.min != self.max && self.max - self.min > 1 {
                for i in self.min+1...self.max-1 {
                    oldItems.append(IndexPath(item: i-1, section: 0))
                }
            }
            
            self.min = 999
            self.max = -1
//            if self.selectedChapters.count == 0 {
            
//            }
            for number in selectedChapters {
                if number < min {
                    min = number
                }
                if number > max {
                    max = number
                }
            }
            
            var newItems: [IndexPath] = []
            if self.min != self.max && self.max - self.min > 1 {
                for i in self.min+1...self.max-1 {
                    newItems.append(IndexPath(item: i-1, section: 0))
                }
            }
            
            if oldItems.count > newItems.count {
                self.collectionView.reloadItems(at: oldItems)
            } else {
                self.collectionView.reloadItems(at: newItems)
            }
            

//            if self.min != self.max && self.max - self.min > 1 {
//                var items: [IndexPath] = []
//                for i in self.min+1...self.max-1 {
//                    items.append(IndexPath(item: i-1, section: 0))
//                }
//                if self.selectedChapters.count == 1 {
//                    self.min = self.selectedChapters[0]
//                    self.max = self.selectedChapters[0]
//                }
//                
//                self.collectionView.reloadItems(at: items)
//            }
        }
    }
    
    var bookModel: BibleVOM?
    weak var delegate: BibleMarkChaptersVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    // MARK: Helper Functions
    
    func commonInit() {
        self.layoutView.layer.cornerRadius = 15
        self.engTitleLabel.text = self.bookModel?.engName
        self.korTitleLabel.text = self.bookModel?.korName
        self.applyButton.layer.cornerRadius = self.applyButton.frame.height / 2
//        self.applyButton.layer.cornerRadius = 20
        self.selectAllButton.layer.cornerRadius = self.selectAllButton.frame.height / 2
//        self.selectAllButton.layer.cornerRadius = 20
        self.selectAllButton.layer.borderColor = UIColor.rgb(red: 150, green: 150, blue: 150).cgColor
        self.selectAllButton.layer.borderWidth = 1
    }
    
    // MARK: CollectionView Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let model = self.bookModel else { return 0 }
        print(model.chapters)
        return model.chapters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkChapterCell", for: indexPath) as? MarkChapterCell
        else {
            return UICollectionViewCell()
        }
        
        print(indexPath.row)
        if let _ = self.selectedCellDict[indexPath.row] {
            cell.commonInit()
        }
        
        
        cell.chapterNumberLabel.text = "\(indexPath.row + 1)"
        let chapterNumber = indexPath.row + 1
        if chapterNumber > self.min && chapterNumber < self.max {
            print("chapter: \(chapterNumber)")
            cell.highlightPossibleSelection()
        } else {
            cell.unhighlightPossibleSelection()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 10 * (itemsPerRow - 1)
        let availableWidth = self.layoutView.frame.width - paddingSpace - 40
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? MarkChapterCell
        else {
            return
        }
        
        
        
        if let _ = self.selectedCellDict[indexPath.row] {
//        if cell.selectionStatus { // Deselect
            cell.selectionStatus = false
            cell.cellTapped()
            var selectedArray = self.selectedChapters
            selectedArray = selectedArray.filter { $0 != indexPath.row + 1}
//            selectedArray.remove(at: indexPath.row + 1)
            self.selectedCellDict.removeValue(forKey: indexPath.row)
            self.selectedChapters = selectedArray
        } else { // Select
            cell.selectionStatus = true
            cell.cellTapped()
            var selectedArray = self.selectedChapters
            selectedArray.append(indexPath.row + 1)
            self.selectedCellDict[indexPath.row] = true
            self.selectedChapters = selectedArray
        }
        
//        cell.cellTapped()
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
    
    @IBAction func outsideTapped(_ sender: UITapGestureRecognizer) {
        print("Tap tap")
        self.delegate?.backgroundTappedToDismiss()
    }
    
}
