//
//  ContactSearchController.swift
//  Scribe
//
//  Created by Mikael Son on 7/7/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

protocol ContactSearchControllerDelegate {
    func didStartSearching()
    
    func didTapOnSearchButton()
    
    func didTapOnCancelButton()
    
    func didChangeSearchText(searchText: String)
}

class ContactSearchController: UISearchController, UISearchBarDelegate {

    var contactSearchBar: ContactSearchBar!
    var customDelegate: ContactSearchControllerDelegate!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor)
    }
    
    private func commonInit() {
        hidesNavigationBarDuringPresentation = true
    }
    
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor) {
        
        self.contactSearchBar = ContactSearchBar(frame: frame, font: font, textColor: textColor)
        
        contactSearchBar.barTintColor = bgColor
        contactSearchBar.tintColor = textColor
        contactSearchBar.showsBookmarkButton = false
        contactSearchBar.showsCancelButton = true
        contactSearchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.customDelegate.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.contactSearchBar.resignFirstResponder()
        self.customDelegate.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.contactSearchBar.resignFirstResponder()
        self.customDelegate.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.customDelegate.didChangeSearchText(searchText: searchText)
    }
}
