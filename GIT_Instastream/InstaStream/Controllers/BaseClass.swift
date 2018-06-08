//
//  BaseClass.swift
//  InstaStream
//
//  Created by prasanth inavolu on 04/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit

class BaseClass: NSObject {
    var faceBookDict : [String : AnyObject]!
    var fbProfileImgUrl : String = ""
    var fbProfileUserName : String = ""
    var baseClassDisplayImagesArray = [UIImage]()
    var fbPageModelArr : [FBPagesModel]!
    static var sharedInstance: BaseClass!

    class func shared() -> BaseClass
    {
        if sharedInstance == nil {
            sharedInstance = BaseClass()
        }
        return sharedInstance
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
