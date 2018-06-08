//
//  LogOutViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 07/06/18.
//  Copyright © 2018 Orbysol. All rights reserved.
//

import UIKit

class LogOutViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profilePicImageView: AsyncImageView!
    @IBOutlet weak var fbDetailsView: UIView!
    @IBOutlet weak var fbUserName: UILabel!
    @IBOutlet weak var fbmailId: UILabel!
    @IBOutlet weak var fbAddress: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomTitleForNavigationBar(titleStr: "Profile")
        self.profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width/2
        profilePicImageView.layer.masksToBounds = true
        self.fbDetailsView.layer.cornerRadius = 10
        self.logOutButton.layer.cornerRadius = 5
        self.logOutButton.layer.borderWidth = 1
        self.logOutButton.layer.borderColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 1.0).cgColor
        profileDetails()
        
        let back = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(LogOutViewController.backTapped))
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc func backTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func profileDetails() {
        profilePicImageView.imageURL = URL(string:BaseClass.shared().fbProfileImgUrl)
        fbUserName.text = BaseClass.shared().userName
        fbmailId.text = BaseClass.shared().userEmail
      //  fbAddress.text = BaseClass.shared().userObject.location
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        BaseClass.shared().userObject = nil
        BaseClass.shared().userId = ""
        BaseClass.shared().userEmail = ""
        BaseClass.shared().avatarUrl = ""
        DataBaseHelper.shared().deleteUserDetailsObject()
        self.appDelegate.accessTokenFBPage = nil
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: UIStoryboard.connectWthFb())
    }
    
    
}
