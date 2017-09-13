//
//  ReadingPlannerVC.swift
//  Scribe
//
//  Created by Mikael Son on 8/29/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit


fileprivate let itemsPerRow: CGFloat = 10

class ReadingPlannerVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

    var bibleDataSource = [BibleVOM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }

    // MARK: Helper Functions
    
    private func commonInit() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bibleDataSource = BibleFactory.getAllList()
        }
        
        self.collectionView?.prefetchDataSource = self
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 100 {
            return 132
        } else {
            let rowCount = collectionView.tag
            let bibleModel = self.bibleDataSource[rowCount]
            return bibleModel.chapters
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 100 {
            let index = indexPath.row == 0 ? 0 : ceil(Double(indexPath.row - 1) / 2)
            let bibleModel = self.bibleDataSource[Int(index)]
            
            if indexPath.row % 2 == 0 {
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookTitleCell", for: indexPath) as? BookTitleCell
                    else {
                        return UICollectionViewCell()
                }
                
                
                indexPath.row == 0 ? (cell.topSeparatorView.isHidden = false) : (cell.topSeparatorView.isHidden = true)
                cell.titleLabel.text = bibleModel.name
                return cell
            } else {
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterHolderCell", for: indexPath) as? ChapterHolderCell
                    else {
                        return UICollectionViewCell()
                }
                
                indexPath.row == 1 ? (cell.topSeparatorView.isHidden = false) : (cell.topSeparatorView.isHidden = true)
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: (indexPath.row - 1)/2)
                
                return cell
            }
        } else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterCell", for: indexPath) as? ChapterCell
            else {
                return UICollectionViewCell()
            }
            
            cell.chapterNumberLabel.text = "\(indexPath.row)"
            
            return cell
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout Functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 100 {
            // Calculate number of rows of chapter
            let index = indexPath.row == 0 ? 0 : ceil(Double(indexPath.row - 1) / 2)
            let bibleModel = self.bibleDataSource[Int(index)]
            let numberOfRow = ceil(Double(bibleModel.chapters) / 10)
            
            var width: CGFloat = 0
            if indexPath.row % 2 == 0 {
                width = collectionView.frame.width * 0.3
            } else {
                width = collectionView.frame.width * 0.7
            }
            
            // Calculate width of the chapter item
            let paddingSpace = (5 * (itemsPerRow + 1)) + 20
            var chapterWidth: CGFloat = 0
            if let windowWidth = UIApplication.shared.keyWindow?.frame.width {
                chapterWidth = windowWidth * 0.7
            }
            let availableWidth = chapterWidth - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            let itemSpace = (numberOfRow - 1) * 7
            
            return CGSize(width: width, height: (widthPerItem * CGFloat(numberOfRow) + 26 + CGFloat(itemSpace)))
            
        } else {
            let paddingSpace = (5 * (itemsPerRow + 1)) + 20
            var width: CGFloat = 0
            if let windowWidth = UIApplication.shared.keyWindow?.frame.width {
                width = windowWidth * 0.7
            }
            let availableWidth = width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print(indexPath.row)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor = UIColor.red
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor = UIColor.white
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let bgview = UIView(frame: cell.bounds)
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        bgview.backgroundColor = .clear
        bgview.alpha = 0
        bgview.addSubview(someView)
        someView.center = bgview.center
        someView.layer.cornerRadius = someView.frame.width / 2
        someView.backgroundColor = .red

        cell.addSubview(bgview)
        
        UIView.animate(withDuration: 0.2, animations: {
            bgview.alpha = 1
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, animations: {
                    bgview.alpha = 0
                }) { (_) in
                    bgview.removeFromSuperview()
                }
            }
        }
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    struct BibleVOM {
        public let name: String
        public let chapters: Int
    }
    
    class BibleFactory: NSObject {
        
        static func getAllList() -> [BibleVOM] {
            var chapterList = [BibleVOM]()
            chapterList.append(BibleVOM(name: "Genesis", chapters: 50))
            chapterList.append(BibleVOM(name: "Exodus", chapters: 40))
            chapterList.append(BibleVOM(name: "Leviticus", chapters: 27))
            chapterList.append(BibleVOM(name: "Numbers", chapters: 36))
            chapterList.append(BibleVOM(name: "Deuteronomy", chapters: 34))
            chapterList.append(BibleVOM(name: "Joshua", chapters: 24))
            chapterList.append(BibleVOM(name: "Judges", chapters: 21))
            chapterList.append(BibleVOM(name: "Ruth", chapters: 4))
            chapterList.append(BibleVOM(name: "1 Samuel", chapters: 31))
            chapterList.append(BibleVOM(name: "2 Samuel", chapters: 24))
            chapterList.append(BibleVOM(name: "1 Kings", chapters: 22))
            chapterList.append(BibleVOM(name: "2 Kings", chapters: 25))
            chapterList.append(BibleVOM(name: "1 Chronicles", chapters: 29))
            chapterList.append(BibleVOM(name: "2 Chronicles", chapters: 36))
            chapterList.append(BibleVOM(name: "Ezra", chapters: 10))
            chapterList.append(BibleVOM(name: "Nehemiah", chapters: 13))
            chapterList.append(BibleVOM(name: "Esther", chapters: 10))
            chapterList.append(BibleVOM(name: "Job", chapters: 42))
            chapterList.append(BibleVOM(name: "Psalms", chapters: 150))
            chapterList.append(BibleVOM(name: "Proverbs", chapters: 31))
            chapterList.append(BibleVOM(name: "Ecclesiastes", chapters: 12))
            chapterList.append(BibleVOM(name: "Song of Solomon", chapters: 8))
            chapterList.append(BibleVOM(name: "Isaiah", chapters: 66))
            chapterList.append(BibleVOM(name: "Jeremiah", chapters: 52))
            chapterList.append(BibleVOM(name: "Lamentations", chapters: 5))
            chapterList.append(BibleVOM(name: "Ezekiel", chapters: 48))
            chapterList.append(BibleVOM(name: "Daniel", chapters: 12))
            chapterList.append(BibleVOM(name: "Hosea", chapters: 14))
            chapterList.append(BibleVOM(name: "Joel", chapters: 3))
            chapterList.append(BibleVOM(name: "Amos", chapters: 9))
            chapterList.append(BibleVOM(name: "Obadiah", chapters: 1))
            chapterList.append(BibleVOM(name: "Jonah", chapters: 4))
            chapterList.append(BibleVOM(name: "Micah", chapters: 7))
            chapterList.append(BibleVOM(name: "Nahum", chapters: 3))
            chapterList.append(BibleVOM(name: "Habakkuk", chapters: 3))
            chapterList.append(BibleVOM(name: "Zephaniah", chapters: 3))
            chapterList.append(BibleVOM(name: "Haggai", chapters: 2))
            chapterList.append(BibleVOM(name: "Zechariah", chapters: 14))
            chapterList.append(BibleVOM(name: "Malachi", chapters: 4))
            chapterList.append(BibleVOM(name: "Matthew", chapters: 28))
            chapterList.append(BibleVOM(name: "Mark", chapters: 16))
            chapterList.append(BibleVOM(name: "Luke", chapters: 24))
            chapterList.append(BibleVOM(name: "John", chapters: 21))
            chapterList.append(BibleVOM(name: "Acts", chapters: 28))
            chapterList.append(BibleVOM(name: "Romans", chapters: 16))
            chapterList.append(BibleVOM(name: "1 Corinthians", chapters: 16))
            chapterList.append(BibleVOM(name: "2 Corinthians", chapters: 13))
            chapterList.append(BibleVOM(name: "Galatians", chapters: 6))
            chapterList.append(BibleVOM(name: "Ephesians", chapters: 6))
            chapterList.append(BibleVOM(name: "Philippians", chapters: 4))
            chapterList.append(BibleVOM(name: "Colossians", chapters: 4))
            chapterList.append(BibleVOM(name: "1 Thessalonians", chapters: 5))
            chapterList.append(BibleVOM(name: "2 Thessalonians", chapters: 3))
            chapterList.append(BibleVOM(name: "1 Timothy", chapters: 6))
            chapterList.append(BibleVOM(name: "2 Timothy", chapters: 4))
            chapterList.append(BibleVOM(name: "Titus", chapters: 3))
            chapterList.append(BibleVOM(name: "Philemon", chapters: 1))
            chapterList.append(BibleVOM(name: "Hebrews", chapters: 13))
            chapterList.append(BibleVOM(name: "James", chapters: 5))
            chapterList.append(BibleVOM(name: "1 Peter", chapters: 5))
            chapterList.append(BibleVOM(name: "2 Peter", chapters: 3))
            chapterList.append(BibleVOM(name: "1 John", chapters: 5))
            chapterList.append(BibleVOM(name: "2 John", chapters: 1))
            chapterList.append(BibleVOM(name: "3 John", chapters: 1))
            chapterList.append(BibleVOM(name: "Jude", chapters: 1))
            chapterList.append(BibleVOM(name: "Revelation", chapters: 22))
            return chapterList
        }
    }
}
