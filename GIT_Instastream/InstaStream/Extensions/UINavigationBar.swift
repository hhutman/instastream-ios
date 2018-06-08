//
//  UINavigationBar.swift
//  Vaco
//
//  Created by RadhaKrishna on 10/09/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    
    func setTitle(title:String, subtitle:String) {
        
        let one = UILabel()
        one.text = title
        one.font = UIFont(name: "Helvetica", size: 17.0)
        one.textColor = UIColor.white
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont(name: "Helvetica", size: 12.0)
        two.textColor = UIColor.lightGray
        two.textAlignment = .center
        two.sizeToFit()
        
        
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        
        
        self.titleView = stackView
    }
}
