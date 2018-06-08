//
//  UIView.swift
//  Vaco
//
//  Created by Param on 04/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func addGradientBackgroundColor() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let topColor = UIColor.colorFromHexString(hexString: "#05456b", withAlpha: 1.0).cgColor
        let topColor1 = UIColor.colorFromHexString(hexString: "#05456b", withAlpha: 1.0).cgColor
        let bottomColor = UIColor.colorFromHexString(hexString: "#dedede", withAlpha: 1.0).cgColor
        let bottomColor1 = UIColor.colorFromHexString(hexString: "#dedede", withAlpha: 1.0).cgColor
        gradient.colors = [topColor, topColor1, bottomColor, bottomColor1]
        gradient.locations = [0.0, 0.3, 0.3, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.colorFromHexString(hexString: "#000000", withAlpha: 0.3).cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3.0
    }
}
