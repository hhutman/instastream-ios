//
//  Toast.swift
//  Vaco
//
//  Created by Param on 04/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit
//import Toast_Swift

extension UIViewController
{
    func showToastWithMessage(strMessage : String)  {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.black
        toastStyle.messageColor = UIColor.white
        toastStyle.messageFont = UIFont (name: "Arial-BoldMT", size: 15)!
            //UIFont(name: Constants.FONT_REGULAR, size: 15.0)!
        self.view.makeToast(strMessage, duration: Constants.TOAST_DURATION, position: .center, style: toastStyle)
    }
}
