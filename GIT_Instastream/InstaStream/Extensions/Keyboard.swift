//
//  Keyboard.swift
//  Vaco
//
//  Created by Param on 01/08/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addKeyboardListener() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    func removeKeyboardListener() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
    }
}
