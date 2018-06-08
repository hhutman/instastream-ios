//
//  BaseClass.swift
//  InstaStream
//
//  Created by prasanth inavolu on 04/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit

class BaseClass: NSObject {
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var faceBookDict : [String : AnyObject]!
    var fbProfileImgUrl : String = ""
    var fbProfileUserName : String = ""
    var selectedImages = [UIImage]()
    var fbPageModelArr : [FBPagesModel]!
    static var sharedInstance: BaseClass!
     var userObject : User!
    var userId : String!
    var userToken : String!
    var avatarUrl : String!
    var isUserLoggedIn : Bool!
    var userEmail : String!
    var userName : String!
    
    class func shared() -> BaseClass
    {
        if sharedInstance == nil {
            sharedInstance = BaseClass()
        }
        return sharedInstance
    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    func getFileSizeWithUrl(url:URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    func showRootViewController() {
        if DataBaseHelper.shared().entityIsEmpty(entityName: "User") {
            let splashView = UIStoryboard.splashScreen()
            let nav = UINavigationController(rootViewController: splashView)
            appDelegate.window?.rootViewController = nav
        }
        else{
            setBaseUserObject()
            let fbProfileDetailsView = UIStoryboard.fbProfileDetails()
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: fbProfileDetailsView)
        }
    }
    
    func setBaseUserObject() {
        BaseClass.shared().userObject = DataBaseHelper.shared().getUserObject() as! User
        userId = BaseClass.shared().userObject.userId!
        userToken = BaseClass.shared().userObject.token!
        userEmail = BaseClass.shared().userObject.email!
        userName = String.giveMeProperString(str: BaseClass.shared().userObject.name!)
        avatarUrl = String.giveMeProperString(str: BaseClass.shared().userObject.avatarUrl)
    }

    func loadFBProfileDetails() {
        let dataDict = faceBookDict!["picture"]!["data"] as? [String : AnyObject]
        if let imgUrl = dataDict!["url"] as? String,
            let userName = faceBookDict["name"] as? String {
            fbProfileImgUrl = imgUrl
            fbProfileUserName = userName
        }
    }
    
    
}

