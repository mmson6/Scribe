//
//  UITableViewCell+ScribeAdditions.swift
//  Scribe
//
//  Created by Mikael Son on 8/11/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static func applyScribeCellAttributes(to cell: UITableViewCell) {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 237, green: 241, blue: 244)
        cell.selectedBackgroundView = view
    }
}
