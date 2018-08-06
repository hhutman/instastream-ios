//
//  ConnectWithFacebookViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 23/04/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit

//import FacebookLogin
//import FBSDKLoginKit

class ConnectWithFacebookViewController: UIViewController {
    
    @IBOutlet weak var fbButton : UIButton?
    var dict : [String : AnyObject]!

    var fbPagesModelObj : FBPagesModel!
    var fbPagesModelArr : [FBPagesModel]?
    var loginManager = FBSDKLoginManager()

    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbButton?.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
        navigationBarTransparent()
    }
    
    func callFBApi(){
//        moveToFBProfileDetailsView()
//        return
        let dict = [
            "facebook_id" : self.dict["id"]!
            ] as [String : Any]
        //self.dict["id"]!//"1553398501437567"
        let strUrl = Constants.URL_FB_SIGN_IN
        let apiName = Constants.API_NAME_FB_SIGN_IN
        
        APIHelper.shared().apiForBodyDataAndBlock(URL: strUrl, APIName: apiName, MethodType: Constants.POST, ContentType: Constants.CONTENT_TYPE_JSON, BodyData: dict,isLoading: true, controller: self, successblock: { (result) -> Void in
            if result != nil{
                let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                if(status == Constants.VALUE_STATUS_OK){
                    let userDetails = result as! Dictionary<String, Any>
                    DispatchQueue.main.async(execute: {
                        DataBaseHelper.shared().addOrUpdaeUserObject(userDetails: userDetails["user"] as! Dictionary<String, Any>)
                        BaseClass.shared().setBaseUserObject()
                        self.showToastWithMessage(strMessage: "Login success")
                        //to view the toast message
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                          //  self.moveToFBProfileDetailsView()
                            self.fbLoginWrite()
                        }
                    })
                }
                else{
                    var error = String.giveMeProperString(str: result?[Constants.KEY_MESSAGE]!)
                    if error.isEmpty{
                        error = Constants.MSG_ERROR
                    }
//                    if String.giveMeProperString(str: self.dict["email"]) == "" {
//                        self.showAlertForFbUser()
//                    }else{
                        DispatchQueue.main.async(execute: {
                            self.signUp()
                        })
                   // }
                }
            }
        })
        { (error) -> Void in
            DispatchQueue.main.async(execute: {
                self.showToastWithMessage(strMessage: (error?.localizedDescription)!)
            })
        }        
    }
    
    private func signUp(){
        let bodyDict = ["email" : String.giveMeProperString(str: self.dict["email"]) as Any, "password" : "" as Any, "name" : String.giveMeProperString(str:self.dict["name"]) as Any, "phone" : "" as Any, "facebook_id" : String.giveMeProperString(str:self.dict["id"]) as Any, "location" : ""] as [String : Any]
        
        let strUrl = Constants.URL_SIGN_UP
        let apiName = Constants.API_NAME_SIGN_UP
        APIHelper.shared().apiForBodyDataAndBlock(URL: strUrl, APIName: apiName, MethodType: Constants.POST, ContentType: Constants.CONTENT_TYPE_JSON, BodyData: bodyDict,isLoading: true, controller: self, successblock: { (result) -> Void in
            if result != nil{
                let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                if(status == Constants.VALUE_STATUS_OK){
                    let userDetails = result as! Dictionary<String, Any>
                    DispatchQueue.main.async(execute: {
                        DataBaseHelper.shared().addOrUpdaeUserObject(userDetails: userDetails["user"] as! Dictionary<String, Any>)
                        BaseClass.shared().setBaseUserObject()
                        self.showToastWithMessage(strMessage: "Registration success")
                        //to view the toast message
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                           // self.moveToFBProfileDetailsView()
                            self.fbLoginWrite()
                        }
                    })
                }
                else{
                    var error = String.giveMeProperString(str: result?[Constants.KEY_MESSAGE]!)
                    if error.isEmpty{
                        error = Constants.MSG_ERROR
                    }
                    DispatchQueue.main.async(execute: {
                        self.showToastWithMessage(strMessage: error)
                    })
                }
            }
        })
        { (error) -> Void in
            DispatchQueue.main.async(execute: {
                self.showToastWithMessage(strMessage: (error?.localizedDescription)!)
            })
        }
    }
    
    private func showAlertForFbUser(){
        let alertController = UIAlertController(title: "Alert", message: "You are not register with us", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Register", style: .default) { (action) in
        }
        alertController.addAction(btnOk)
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(btnCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func moveToFBProfileDetailsView() {
        let goToFbDetails = UIStoryboard.fbProfileDetails()
        self.navigationController?.pushViewController(goToFbDetails, animated: true)
    }
    
    @IBAction func fbButtonTapped(_ sender: Any) {
//        fbLoginWrite()
//        return
        //if the user is already logged in
        if (FBSDKAccessToken.current()) != nil {
            if BaseClass.shared().userId != nil {
                if !FBSDKAccessToken.current().hasGranted("publish_actions") || !FBSDKAccessToken.current().hasGranted("publish_video") {
                    self.fbLoginWrite()
                }
                else{
                    self.moveToFBProfileDetailsView()
                }
            }else{
                self.getFBUserData()
            }
        }
        else {
//        let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self){ (result, error) in
                if error != nil {
                    print("Error")
                } else if result?.isCancelled == true {
                    print("Cancelled")
                } else {
                    print("Logged in")
                    
                    self.getFBUserData()
//                    DispatchQueue .main.async(execute:{
//                        loginManager.logOut()
//                    })
                }
            }
//        loginManager.logIn(readPermissions: [.publicProfile, .pagesShowList, .pagesManageCta, .pagesManageInstantArticles], viewController : self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                self.getFBUserData()
//            }
//        }
    }
}
    
    func fbLoginWrite() {
        if FBSDKAccessToken.current().hasGranted("publish_actions") || FBSDKAccessToken.current().hasGranted("publish_video") {
            self.moveToFBProfileDetailsView()
        }else{
        let loginManager = FBSDKLoginManager() //"publish_actions",
        loginManager.logIn(withPublishPermissions: ["manage_pages","publish_pages","publish_video"], from: self)  { (result, error) in
            if error != nil {
                print("Error")
            } else if result?.isCancelled == true {
                print("Cancelled")
            } else {
                print("Logged in for write")
            //    self.getFBUserData()
                     if FBSDKAccessToken.current().hasGranted("publish_actions") || FBSDKAccessToken.current().hasGranted("publish_video"){
                        self.moveToFBProfileDetailsView()
                }
                //self.startLiveStreaming()
            }
        }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result as Any)
                    BaseClass.shared().faceBookDict = result as! [String : AnyObject]
                    self.dict = result as! [String : AnyObject]
                    BaseClass.shared().loadFBProfileDetails()
                    self.fetchFBPages()
                    self.callFBApi()
                   // self.fbLoginWrite()
                }
            })
        }
    }
    
    func fetchFBPages(){
        FBSDKGraphRequest(graphPath: "/me/accounts/access_token", parameters: ["fields": "id, name, picture.type(large), email,access_token"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let res = result as! [String : AnyObject]
                print(res)
                let temp = res["data"] as! Array<Dictionary<String, AnyObject>>
                self.fbPagesModelArr = FBPagesModel.parseMultipleFBPages(array:temp)
                BaseClass.shared().fbPageModelArr = self.fbPagesModelArr
            }
        })
    }
    
}
