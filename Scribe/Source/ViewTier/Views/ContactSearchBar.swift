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
}
