//
//  Spinner.swift
//  MyCounty
//
//  Created by DEFTeam on 16/12/17.
//  Copyright © 2017 Rapid. All rights reserved.
//

import Foundation
import UIKit
//import MBProgressHUD

class Spinner: NSObject {
    
    class func show(controller : UIViewController){
        MBProgressHUD.showAdded(to: controller.view, animated: true)
    }
    
    class func hide(controller : UIViewController){
        MBProgressHUD.hide(for: controller.view, animated: true)
    }
    
}
