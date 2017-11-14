//
//  ContactSearchBar.swift
//  Scribe
//
//  Created by Mikael Son on 7/24/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
    
    private func getSearchBarTextField() -> UITextField? {
        let searchTextField = self.value(forKey: "searchField") as? UITextField
        return searchTextField
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "Search by name", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let imageView = button.imageView{
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            }
//            button.tintColor = UIColor.rgb(red: 166, green: 182, blue: 191)
//            textField.tintColor = UIColor.rgb(red: 166, green: 182, blue: 191)
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
}
