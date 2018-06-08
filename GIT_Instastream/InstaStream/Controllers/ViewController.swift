////
////  ViewController.swift
////  InstaStream
////
////  Created by Orbysol on 4/2/18.
////  Copyright © 2018 Orbysol. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//     //   getFBUserData()
//       // FBLOgin()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    func FBLOgin() {
//        //if the user is already logged in
//        if (FBSDKAccessToken.current()) != nil{
//            self.getFBUserData()
//            //  fbLoginManager.logOut()
//            
//        }
//        else{
//            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//                if (error == nil){
//                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                    if fbloginresult.grantedPermissions != nil {
//                        if(fbloginresult.grantedPermissions.contains("email"))
//                        {
//                            self.getFBUserData()
//                            DispatchQueue .main.async(execute:{
//                                fbLoginManager.logOut()
//                                
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func getFBUserData(){
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "/me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    let dict = result as! [String : AnyObject]
//                    print(dict)
//                    
//                    // self.showAlert()
//                    //  self.callFBApi()
//                    // FBSDKAccessToken.setCurrent(nil)
//                    //FBSDKProfile.setCurrent(nil)
//                    //print(self.dict)
//                }else{
//                    print(error?.localizedDescription as Any)
//                }
//            })
//        }
//    }
//    
//    @IBAction func goToFBLive(_ sender: Any) {
//     //   let fbView = UIStoryboard.facebookLiveView()
//       // self.navigationController?.pushViewController(fbView, animated: true)
//    }
//    
//
//}
//
