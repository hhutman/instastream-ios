//
//  UIButton.swift
//  Vaco
//
//  Created by Param on 04/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    func actionHandle(controlEvents control :UIControlEvents, ForAction action:@escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: control)
    }
}
