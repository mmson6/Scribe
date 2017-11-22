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
    
    struct Scribe {
        static let navigation = UIColor(red: 84.0/255.0, green: 193.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        static let navigationBlue = UIColor(red: 84.0/255.0, green: 193.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        static let backgroundBeige = UIColor(red: 242.0/255.0, green: 239.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        static let grey1 = UIColor(white: 70.0/255.0, alpha: 1.0)
        static let gray = UIColor(white: 110.0 / 255.0, alpha: 1.0)
        static let darkGray = UIColor(white: 80.0 / 255.0, alpha: 1.0)
        
        struct ReadingPlanner {
            static let bookCellTitleViewColor = rgb(red: 240, green: 245, blue: 248)
            static let bookCellSeparatorColor = rgb(red: 204, green: 204, blue: 204)
            static let bookChapterTextColor = rgb(red: 102, green: 102, blue: 102)
            static let bookChapterSelectedGreenColor = rgb(red: 71, green: 152, blue: 105)
            static let bookChapterPossiblySelectedGreenColor = rgb(red: 214, green: 238, blue: 227)
            static let bookChapterSelectedRedColor = rgb(red: 237, green: 93, blue: 87)
            static let bookChapterPossiblySelectedRedColor = rgb(red: 250, green: 221, blue: 221)
            static let topPlanTrackerAverageGreenColor = UIColor.rgb(red: 211, green: 251, blue: 206)
            static let topPlanTrackerAveragePurpleColor = rgb(red: 203, green: 204, blue: 248)
            static let bottomPlanTrackerChapterGreenColor = UIColor.rgb(red: 78, green: 244, blue: 66)
            static let bottomPlanTrackerChapterBlueColor = UIColor.rgb(red: 68, green: 188, blue: 250)
        }
        struct Design2 {
            static let readingPlannerSelectionBlue = rgb(red: 216, green: 232, blue: 241)
            static let lightBlue = rgb(red: 166, green: 182, blue: 191)
            static let background = rgb(red: 240, green: 242, blue: 241)
            static let darkBlue = rgb(red: 36, green: 75, blue: 97)
            static let darkBlueDisabled = rgb(red: 36, green: 75, blue: 97, alpha: 0.5)
            static let blue = rgb(red: 78, green: 136, blue: 168)
            static let gray = rgb(red: 166, green: 182, blue: 191)
            static let green = rgb(red: 138, green: 224, blue: 131)
            static let red = rgb(red: 247, green: 68, blue: 68)
        }
        struct Design1 {
            static let tabbarColor = UIColor(red: 85.0/255.0, green: 192.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            static let cellColor = UIColor(red: 245.0/255.0, green: 248.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            static let navBarColor = UIColor(red: 251.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            static let navBarItemColor = UIColor(red: 110.0/255.0, green: 132.0/255.0, blue: 155.0/255.0, alpha: 1.0)
            static let infoTitleColor = UIColor(red: 153.0/255.0, green: 168.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        }
        struct ContactGroup {
            static let green = UIColor(red: 153.0 / 255.0, green: 195.0 / 255.0, blue: 85.0 / 255.0, alpha: 1)
            static let blueGreen = UIColor(red: 133.0 / 255.0, green: 190.0 / 255.0, blue: 174.0 / 255.0, alpha: 1)
            static let blue = UIColor(red: 74.0 / 255.0, green: 135.0 / 255.0, blue: 190.0 / 255.0, alpha: 1)
            static let yellow = UIColor(red: 231.0 / 255.0, green: 229.0 / 255.0, blue: 76.0 / 255.0, alpha: 1)
            static let red = UIColor(red: 239.0 / 255.0, green: 114.0 / 255.0, blue: 107.0 / 255.0, alpha: 1)
            static let purple = UIColor(red: 175.0 / 255.0, green: 116.0 / 255.0, blue: 185.0 / 255.0, alpha: 1)
            static let orange = UIColor(red: 244.0 / 255.0, green: 159.0 / 255.0, blue: 59.0 / 255.0, alpha: 1)
        }
        struct ContactDetail {
            static let imageBackground = UIColor(red: 208.0 / 255.0, green: 81.0 / 255.0, blue: 75.0 / 255.0, alpha: 1)
            static let navBarBackground = UIColor(red: 214.0 / 255.0, green: 103.0 / 255.0, blue: 99.0 / 255.0, alpha: 1)
            static let cellBackground = UIColor(red: 247.0/255.0, green: 244.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            static let mapBorder = UIColor(red: 104.0/255.0, green: 182.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        }
        struct Xo {
            static let primaryDark = UIColor(red: 192.0 / 255.0, green: 58.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
            static let primary = UIColor(red: 251.0 / 255.0, green: 82.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
            static let action = UIColor(red: 238.0 / 255.0, green: 142.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
            static let missing = UIColor(red: 87.0 / 255.0, green: 173.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
            static let notification = UIColor(red: 118.0 / 255.0, green: 191.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
            static let facebook = UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
            static let google = UIColor(red: 66.0 / 255.0, green: 133.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
            static let grey1 = UIColor(white: 136.0 / 255.0, alpha: 1.0)
            static let grey2 = UIColor(white: 170.0 / 255.0, alpha: 1.0)
            static let grey3 = UIColor(red: 230.0 / 255.0, green: 227.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
            static let grey4 = UIColor(white: 244.0 / 255.0, alpha: 1.0)
            static let white54 = UIColor(white: 255.0 / 255.0, alpha: 0.54)
            static let black = UIColor(white: 0.0, alpha: 1.0)
            static let white = UIColor(white: 255.0 / 255.0, alpha: 1.0)
            static let primary8 = UIColor(red: 251.0 / 255.0, green: 81.0 / 255.0, blue: 84.0 / 255.0, alpha: 0.08)
            static let black36 = UIColor(white: 0.0, alpha: 0.36)
        }
    }
}
