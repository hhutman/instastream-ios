//
//  UIColor.swift
//  InstaStream
//
//  Created by Rapid Dev on 03/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    class func colorFromHexString(hexString: String?, withAlpha alpha : CGFloat) -> UIColor {
        if hexString!.isEmpty {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexString!)
        scanner.scanLocation = 1
        // bypass '#' character
        scanner.scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

