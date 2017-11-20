//
//  ChapterHolderCell.swift
//  Scribe
//
//  Created by Mikael Son on 8/29/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ChapterHolderCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topSeparatorView: UIView!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int) {
        
        //        print("rowww----- : \(row)")
        self.collectionView.delegate = dataSourceDelegate
        self.collectionView.tag = row
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
