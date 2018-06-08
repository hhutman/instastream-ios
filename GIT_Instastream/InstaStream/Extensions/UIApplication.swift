//
//  UIApplication.swift
//  Vaco
//
//  Created by Param on 10/08/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
