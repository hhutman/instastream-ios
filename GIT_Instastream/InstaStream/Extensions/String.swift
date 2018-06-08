//
//  String.swift
//  Vaco
//
//  Created by Param on 04/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation


extension String
{
    static func giveMeProperString(str : Any?) -> String {
        if ((str as? String) != nil){
            return str as! String
        }
        else if ((str as? NSNumber) != nil){
            return "\(str!)"
        }
        else{
            return String()
        }
    }
    
    func emailWithOutSplChars() -> String{
        if let emailStr = self as? String {
            return emailStr.replacingOccurrences(of: ".", with: "**").replacingOccurrences(of: "@", with: "***")
        }
        else {
            return ""
        }
    }
    
    func emailWithSplChars() -> String{
        if let emailStr = self as? String {
            return emailStr.replacingOccurrences(of: "***", with: "@").replacingOccurrences(of: "**", with: ".")
        }
        else {
            return ""
        }
    }
}
