//
//  MessagesHelper.swift
//  MyCounty
//
//  Created by DEFTeam on 14/11/17.
//  Copyright © 2017 Rapid. All rights reserved.
//

import Foundation
import UIKit
//import SwiftMessages

class Messages: NSObject {
    static var sharedInstance: Messages!
    class func shared() -> Messages
    {
        if sharedInstance == nil {
            sharedInstance = Messages()
        }
        return sharedInstance
    }
    
    func showErrorMessage(message : String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: "Error", body: message)
        SwiftMessages.show(view: view)
    }
    
    func showWarningMessage(message : String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: "Warning", body: message)
        SwiftMessages.show(view: view)
    }
}

