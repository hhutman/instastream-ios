//
//  DateFormatter.swift
//  Vaco
//
//  Created by DEFTeam on 17/08/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter{
    
    internal class func dayFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE,dd"
        return formatter
    }
    
    internal class func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    internal class func monthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM,yyyy"
        return formatter
    }
    
    internal class func dateTimeFormatter() -> DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    internal class func dateTimeFormatter1() -> DateFormatter
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm a"
        return formatter
    }
    
    internal class func timeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "HH:mm a"
        return formatter
    }
    
    internal class func dayMonthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd, yyyy"
        return formatter
    }

}
