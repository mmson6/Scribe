//
//  UIColor+ScribeAdditions.swift
//  Scribe
//
//  Created by Mikael Son on 5/12/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // MARK: Bible Reading Planner Colors
    
    class var bookCellSeparatorColor: UIColor {
        return rgb(red: 204, green: 204, blue: 204)
    }
    
    class var bookChapterTextColor: UIColor {
        return rgb(red: 102, green: 102, blue: 102)
    }
    
    class var bookChapterSelectedGreenColor: UIColor {
        return rgb(red: 100, green: 184, blue: 143)
    }
    
    class var bookChapterPossiblySelectedGreenColor: UIColor {
        return rgb(red: 214, green: 238, blue: 227)
    }
    
    class var bookChapterSelectedRedColor: UIColor {
        return rgb(red: 237, green: 93, blue: 87)
    }
    
    class var bookChapterPossiblySelectedRedColor: UIColor {
        return rgb(red: 250, green: 221, blue: 221)
    }
    
    // MARK: Pinterest Design 2
    
    class var scribeDesignTwoLightBlue: UIColor {
        return rgb(red: 166, green: 182, blue: 191)
    }
    
    class var scribeDesignTwoBackground: UIColor {
        return rgb(red: 240, green: 242, blue: 241)
    }
    
    class var scribeDesignTwoDarkBlue: UIColor {
        return rgb(red: 36, green: 75, blue: 97)
    }
    
    class var scribeDesignTwoBlue: UIColor {
        return rgb(red: 78, green: 136, blue: 168)
    }
    
    class var scribeDesignTwoGray: UIColor {
        return rgb(red: 166, green: 182, blue: 191)
    }
    
    class var scribeDesignTwoGreen: UIColor {
        return rgb(red: 138, green: 224, blue: 131)
    }
    
    class var scribeDesignTwoRed: UIColor {
        return rgb(red: 247, green: 68, blue: 68)
    }
    
    // MARK: Pinterest Design 1
    
    class var scribePintTabbarColor: UIColor {
        return UIColor(red: 85.0/255.0, green: 192.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    class var scribePintCellColor: UIColor {
        return UIColor(red: 245.0/255.0, green: 248.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    class var scribePintNavBarColor: UIColor {
        return UIColor(red: 251.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    }
    
    class var scribePintNavBarItemColor: UIColor {
        return UIColor(red: 110.0/255.0, green: 132.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    }
    
    class var scribePintInfoTitleColor: UIColor {
        return UIColor(red: 153.0/255.0, green: 168.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    }
    
    // MARK: Colors
    
    class var scribeColorNavigation: UIColor {
        return UIColor(red: 84.0/255.0, green: 193.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    class var scribeColorNavigationBlue: UIColor {
//        return UIColor(red: 92.0/255.0, green: 160.0/255.0, blue: 204.0/255.0, alpha: 1.0)
//        return UIColor(red: 97.0/255.0, green: 187.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        return UIColor(red: 84.0/255.0, green: 193.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    class var scribeColorBackgroundBeige: UIColor {
        return UIColor(red: 242.0/255.0, green: 239.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    }
    
    class var scribeGrey1: UIColor {
        return UIColor(white: 70.0/255.0, alpha: 1.0)
//        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaPrimaryDark: UIColor {
        return UIColor(red: 192.0 / 255.0, green: 58.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaPrimary: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 82.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaAction: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 142.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaMissing: UIColor {
        return UIColor(red: 87.0 / 255.0, green: 173.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaNotification: UIColor {
        return UIColor(red: 118.0 / 255.0, green: 191.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaFacebook: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaGoogle: UIColor {
        return UIColor(red: 66.0 / 255.0, green: 133.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaGrey1: UIColor {
        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaGrey2: UIColor {
        return UIColor(white: 170.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaGrey3: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 227.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaGrey4: UIColor {
        return UIColor(white: 244.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaWhite54: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 0.54)
    }
    
    class var xoobaBlack: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    class var xoobaWhite: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var xoobaPrimary8: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 81.0 / 255.0, blue: 84.0 / 255.0, alpha: 0.08)
    }
    
    class var xoobaBlack36: UIColor { 
        return UIColor(white: 0.0, alpha: 0.36)
    }

    // MARK: Contact Group Color
    
    class var scribeColorGroup1: UIColor { // green
        return UIColor(red: 153.0 / 255.0, green: 195.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup2: UIColor { // bluish green
        return UIColor(red: 133.0 / 255.0, green: 190.0 / 255.0, blue: 174.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup3: UIColor { // blue
        return UIColor(red: 74.0 / 255.0, green: 135.0 / 255.0, blue: 190.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup4: UIColor { // yellow
//        return UIColor(red: 222.0 / 255.0, green: 182.0 / 255.0, blue: 70.0 / 255.0, alpha: 1)
//        return UIColor(red: 228.0 / 255.0, green: 223.0 / 255.0, blue: 70.0 / 255.0, alpha: 1)
        return UIColor(red: 231.0 / 255.0, green: 229.0 / 255.0, blue: 76.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup5: UIColor { // red
//        return UIColor(red: 251.0 / 255.0, green: 122.0 / 255.0, blue: 92.0 / 255.0, alpha: 1)
        return UIColor(red: 239.0 / 255.0, green: 114.0 / 255.0, blue: 107.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup6: UIColor { // purple
        return UIColor(red: 175.0 / 255.0, green: 116.0 / 255.0, blue: 185.0 / 255.0, alpha: 1)
    }
    class var scribeColorGroup7: UIColor { // orange
//        return UIColor(red: 244.0 / 255.0, green: 123.0 / 255.0, blue: 40.0 / 255.0, alpha: 1)
        return UIColor(red: 244.0 / 255.0, green: 159.0 / 255.0, blue: 59.0 / 255.0, alpha: 1)
    }
    
    // MARK: Contact Detail VC Color
    
    class var scribeColorCDImageBackground: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 81.0 / 255.0, blue: 75.0 / 255.0, alpha: 1)
    }
    class var scribeColorCDNavBarBackground: UIColor {
        return UIColor(red: 214.0 / 255.0, green: 103.0 / 255.0, blue: 99.0 / 255.0, alpha: 1)
    }
    class var scribeColorCDCellBackground: UIColor {
        return UIColor(red: 247.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    class var scribeColorCDMapBorder: UIColor {
        return UIColor(red: 104.0/255.0, green: 182.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    }
    
    // MARK: Gray Color
    
    class var scribeGray: UIColor {
        return UIColor(white: 110.0 / 255.0, alpha: 1.0)
    }
    class var scribeDarkGray: UIColor {
        return UIColor(white: 80.0 / 255.0, alpha: 1.0)
    }
    
//    class var scribeColorGroup1: UIColor {
//        return UIColor(red: 153.0 / 255.0, green: 195.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
//    }
}
