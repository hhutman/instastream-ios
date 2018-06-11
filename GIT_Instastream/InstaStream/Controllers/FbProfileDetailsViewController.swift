//
//  FbProfileDetailsViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 30/04/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit
import Photos

class FbProfileDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: AsyncImageView!
    @IBOutlet weak var fbProfileUserName: UILabel!
    @IBOutlet weak var startInstaStream : UIButton?
    
    var fbDict : [String : AnyObject]?
    var pictureUrl : String?
    var fbUserName : String?
    var fbPagesModelObj : FBPagesModel!
    var fbPagesModelArr : [FBPagesModel]?
    var connectionError : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Spinner.show(controller: self)
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        getFBUserData()
        BaseClass.shared().setBaseUserObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTransparent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Spinner.hide(controller: self)
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            self.startInstaStream?.alpha = 0.5
            self.startInstaStream?.isUserInteractionEnabled = false
        case .wifi:
            self.getFBUserData()
            self.startInstaStream?.alpha = 1
            self.startInstaStream?.isUserInteractionEnabled = true
        case .wwan:
            print("")
            //view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    @objc func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(normal), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result as Any)
                    BaseClass.shared().faceBookDict = result as! [String : AnyObject]
                    // self.dict = result as! [String : AnyObject]
                    BaseClass.shared().loadFBProfileDetails()
                    self.fetchFBPages()
                    DispatchQueue.main.async {
                        self.loadImage()
                    }
                    //  self.loadImage()
                    // self.callFBApi()
                    // self.fbLoginWrite()
                }else{
                    print("\n")
                    print(error as Any)
                    self.connectionError = true
                    self.showToastWithMessage(strMessage: (error?.localizedDescription)!)
                    self.profileImageView.image = UIImage(named:"avtar")
                    MBProgressHUD.hide(for: self.view, animated: true)
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
            else{
                self.connectionError = true
                self.showToastWithMessage(strMessage: (error?.localizedDescription)!)
                self.profileImageView.image = UIImage(named:"avtar")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
    }
    
    func loadImage() {
        profileImageView.image = UIImage(named:"avtar")
        profileImageView.imageURL = URL(string:BaseClass.shared().fbProfileImgUrl)
        fbProfileUserName.text = BaseClass.shared().fbProfileUserName
        makeImageCircle()
        startInstaStream?.layer.cornerRadius = 5
        //        DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
        MBProgressHUD.hide(for: self.view, animated: true)
        //        }
    }
    
    @IBAction func startInstaStreamTappped(_ sender: Any) {
        //        if connectionError {
        //            self.showToastWithMessage(strMessage: "please check your internet connection")
        //            return
        //        }
        
        Spinner.show(controller: self)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                //                let fetchOptions = PHFetchOptions()
                //                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                //                print("Found \(allPhotos.count) assets")
                
                DispatchQueue.main.async {
                    self.moveToGalleryView()
                }
            case .denied, .restricted:
                print("Not allowed")
                DispatchQueue.main.async {
                    self.showToastWithMessage(strMessage: "allow photos for this app in settings")
                }
                self.requestForPhotos()
            case .notDetermined:
                print("Not determined yet")
            }
        }
        Spinner.hide(controller: self)
        
    }
    
    func moveToGalleryView() {
        
        let goToGalleryView = UIStoryboard.galleryView()
        //  goToGalleryView.grabImages()
        goToGalleryView.isFrom = self
        self.navigationController?.pushViewController(goToGalleryView, animated: true)
    }
    
    func requestForPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Not allowed")
                
                //                let fetchOptions = PHFetchOptions()
                //                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                //                print("Foundjkhfkhfhf \(allPhotos.count) assets")
            // self.grabImages()
            case .denied, .restricted:
                print("Not allowed")
            //_ = self.navigationController?.popViewController(animated: true)
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            }
        }
    }
    
    
    func makeImageCircle() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height/2
    }
    
}


