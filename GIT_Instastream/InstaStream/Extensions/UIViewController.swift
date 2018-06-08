//
//  UIViewController.swift
//  InstaStream
//
//  Created by prasanth inavolu on 03/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func showAlertView(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigationBarColorChange() {
        let navController = self.navigationController
//        let navBackgroundImage:UIImage! = UIImage(named: "appBar")
//        navController?.navigationBar.setBackgroundImage(navBackgroundImage,
//                                                        for: .default)
        navController?.navigationBar.barTintColor = Constants.COLOR_NAV
        navController?.navigationBar.isTranslucent = false
        navController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: Constants.FONT_REGULAR, size: 18.0) as Any]
        navController?.navigationBar.tintColor = UIColor.white
        navController?.navigationBar.barStyle = UIBarStyle.black
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    func navigationBarTransparent(){
        let navController = self.navigationController
        navController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: Constants.FONT_REGULAR, size: 18.0) as Any]
        navController?.navigationBar.shadowImage = UIImage()
        navController?.navigationBar.tintColor = UIColor.white
        navController?.navigationBar.isTranslucent = true
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    func addCustomTitleForNavigationBar(titleStr : String) {
        let navFrame = self.navigationController?.navigationBar.frame
        let lblTitle = UILabel()
        lblTitle.frame =  CGRect(x: 0, y: -5, width: (navFrame?.size.width)!, height: 40.0)
        lblTitle.text = titleStr
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: Constants.FONT_REGULAR, size: 17.0)
        self.navigationItem.titleView = lblTitle
    }
    
    class func topMostController() -> UIViewController?
    {
        let topWndow = UIApplication.shared.keyWindow!
        var topController = topWndow.rootViewController
        
        if (topController == nil)
        {
            // The windows in the array are ordered from back to front by window level; thus,
            // the last window in the array is on top of all other app windows.
            for aWndow in UIApplication.shared.windows.reversed()
            {
                topController = aWndow.rootViewController!
                if (topController != nil) {
                    break
                }
            }
        }
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController!
        }
        return topController!;
    }
    
}
