//
//  ContactGroupViewController.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit


fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
fileprivate let itemsPerRow: CGFloat = 2

public struct contactGroupVO {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

public class EmptyContactGroups: ObjectDataSource<Any> {
    
    var objArray = [contactGroupVO]()
    
    override init() {
        let obj1 = contactGroupVO(name: "Young Adult Group")
        let obj2 = contactGroupVO(name: "Mothers Group")
        let obj3 = contactGroupVO(name: "Fathers Group")
        let obj4 = contactGroupVO(name: "Choir")
        let obj5 = contactGroupVO(name: "Teachers")
        objArray.append(obj1)
        objArray.append(obj2)
        objArray.append(obj3)
        objArray.append(obj4)
        objArray.append(obj5)
    }
    
    public override func numberOfObjects(inSection section: Int) -> Int {
        return objArray.count
    }
    
    public override func numberOfSections() -> Int {
        return 1
    }
    
    public override func object(at indexPath: IndexPath) throws -> Any {
        //        let obj1 = EmptyODSIndicator(name: "Mike")
        //        let obj2 = EmptyODSIndicator(name: "Daniel")
        //        let obj3 = EmptyODSIndicator(name: "Roy")
        //        let obj4 = EmptyODSIndicator(name: "Paul")
        //        let obj5 = EmptyODSIndicator(name: "Andrew")
        //        objArray.append(obj1)
        //        objArray.append(obj2)
        //        objArray.append(obj3)
        //        objArray.append(obj4)
        //        objArray.append(obj5)
        //        let obj = [EmptyODSIndicator]()
        print(indexPath.row)
        return objArray[indexPath.row]
    }
}

class ContactGroupViewController: SPRCollectionViewController, UICollectionViewDelegateFlowLayout {

    public override func viewDidLoad() {
        
    }
    
    override public func loadObjectDataSource(_ callback: @escaping (AsyncResult<ObjectDataSource<Any>>) -> Void) {
        let cmd = FetchContactsCommand()
        cmd.onCompletion(do: callback)
        cmd .execute()
        //        let cmd = FetchContactsCommand()
        //        cmd.onCompletion(do: callback)
        //        cmd.execute()
//        let ods = EmptyContactGroups()
//        
//        callback(.success(ods))
    }
    
    override func renderCell(inCollectionView collectionView: UICollectionView, withModel model: Any, at indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactGroupCell", for: indexPath) as? ContactGroupCell,
            let contactGroupModel = model as? contactGroupVO
        else {
            return UICollectionViewCell()
        }
        
        cell.populateCell(with: contactGroupModel)
//        cell.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2)
        self.resizeCellSize(cell)
        
        return cell
    }
    
    
    // MARK: Private Cell Method
    
    private func resizeCellSize(_ cell: ContactGroupCell) {
        
    }
    
    
    // MARK: UICollectionViewDelegateLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    // MARK: UICollectionViewDelegate

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

}
