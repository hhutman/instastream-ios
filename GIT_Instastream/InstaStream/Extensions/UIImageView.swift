//
//  UIImageView.swift
//  Vaco
//
//  Created by Param on 02/08/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    //Make circle
    func makeCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
