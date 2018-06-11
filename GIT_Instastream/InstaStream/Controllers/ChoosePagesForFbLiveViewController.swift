//
//  ChoosePagesForFbLiveViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 04/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit
//import FBSDKLoginKit


class ChoosePagesForFbLiveViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fbProfileImageView: AsyncImageView!
    @IBOutlet weak var fbProfileUserName: UILabel!
    @IBOutlet weak var checkBoxActiveImageView: UIImageView!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var lblMessage : UILabel?
//    @IBOutlet weak var selectFbPagesLabel : UILabel!
//    @IBOutlet weak var selectFbPagesLine : UILabel!
//    @IBOutlet weak var noteForPages : UILabel!
//    @IBOutlet weak var noteLbl : UILabel!

    var isSelected : Bool = false //based on selection list shown i.e checkbox
    var checkBoxTapped : Any?
    var fbPagesModelObj : FBPagesModel!
    var fbPagesModelArr : [FBPagesModel]!
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var privacySelected : FBLivePrivacy = .closed
    var pageToken : String = ""
    var alertResult : ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNav()
    }
    
    func loadNav() {
        fbPagesModelArr = BaseClass.shared().fbPageModelArr
        let back = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(ChoosePagesForFbLiveViewController.backTapped))
        self.navigationItem.leftBarButtonItem = back
        addCustomTitleForNavigationBar(titleStr: "Your Facebook Pages")
        displayPersonImageOnBarButton()
        makeCornerRadius()
        nextButton.isUserInteractionEnabled = false
        nextButton.backgroundColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 0.2)
    }
    
    func makeCornerRadius() {
        fbProfileImageView.layer.cornerRadius = fbProfileImageView.layer.frame.height/2
        fbProfileImageView.clipsToBounds = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let push = UIStoryboard.logOut()
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fbProfileUserName.text = BaseClass.shared().fbProfileUserName
        fbProfileImageView.imageURL  = URL(string: BaseClass.shared().fbProfileImgUrl)
        //self.navigationController?.navigationBar.isHidden = false
        //loadNav()
    }
    
    @objc func backTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func checkBoxSelected() {
        nextButton.isUserInteractionEnabled = true
        nextButton.backgroundColor = UIColor.colorFromHexString(hexString: "#FF0076", withAlpha: 1.0)
    }
    
    @IBAction func timelineBtnTapped(_ sender: Any) {
        if isSelected {
            isSelected = false
        }else{
            checkBoxActiveImageView.image = UIImage(named: "CheckBoxActive")
            isSelected = true
            //appDelegate.accessTokenFBPage = nil
            pageToken = ""
        }
        checkBoxSelected()
        tableView.reloadData()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
       // showPrivacyOptions()
        self.privacySelected = .everyone
        self.moveToLivePage()

    }
    
    func moveToLivePage() {
        nextButton.isUserInteractionEnabled = false
        nextButton.backgroundColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let goToLiveVideoView = UIStoryboard.liveVideoView()
            goToLiveVideoView.livePrivacy = self.privacySelected
            if self.pageToken.count > 0 {
                self.appDelegate.accessTokenFBPage = self.pageToken
            }else{
                self.appDelegate.accessTokenFBPage = nil
            }
            print("selected privacy is \(self.privacySelected)")
            self.navigationController?.pushViewController(goToLiveVideoView, animated: true)
        }
    }
    
    func showPrivacyOptions() {
        let actionSheet = UIAlertController(title: "Select Privacy", message: "", preferredStyle: .actionSheet)
        let me = UIAlertAction(title: "me", style: UIAlertActionStyle.default) {(action) in
            self.privacySelected = .closed
            self.moveToLivePage()
        }
        let everyone = UIAlertAction(title : "everyone", style : UIAlertActionStyle.default) {(action) in
            self.privacySelected = .everyone
            self.moveToLivePage()
        }
        let friends = UIAlertAction(title : "friends", style : UIAlertActionStyle.default) {(action) in
            self.privacySelected = .allFriends
            self.moveToLivePage()
        }
        let friendsOfFriends = UIAlertAction(title : "friendsOfFriends", style : UIAlertActionStyle.default) {(action) in
            self.privacySelected = .friendsOfFriends
            self.moveToLivePage()
        }
        let cancel = UIAlertAction(title : "Cancel", style : UIAlertActionStyle.cancel)
        self.dismiss(animated: true, completion: nil)
        
        actionSheet.addAction(me)
        actionSheet.addAction(everyone)
        actionSheet.addAction(friends)
        actionSheet.addAction(friendsOfFriends)
        actionSheet.addAction(cancel)
        self.present(actionSheet,animated: true)
    }
    
    func displayPersonImageOnBarButton() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imgView:AsyncImageView = AsyncImageView(frame: CGRect(x: 0,y: 0,width: 40, height: 40))
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        imgView.layer.masksToBounds = true
        imgView.image = UIImage(named: "avtar")
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.imageURL = URL(string: BaseClass.shared().fbProfileImgUrl)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(imgView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
    }

    fileprivate func showEmptyMessage(count : Int){
        lblMessage?.text = ""
        if count == 0{
            lblMessage?.text = ""
            checkBoxSelected()
            pageToken = ""
//            selectFbPagesLabel.isHidden = true
//            selectFbPagesLine.isHidden = true
//            noteForPages.isHidden = true
//            noteLbl.isHidden = true
            checkBoxActiveImageView.image = UIImage(named: "CheckBoxActive")
        }
    }
}

extension ChoosePagesForFbLiveViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = self.fbPagesModelArr else{
            return 0
        }
        showEmptyMessage(count: arr.count)
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fbPagesModelObj = self.fbPagesModelArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ChoosePagesForFbTableViewCell
        cell.fbPageName.text = fbPagesModelObj.name
        cell.fbPagesImageView.imageURL = URL(string: fbPagesModelObj.url!)
        cell.checkBoxActive.image = UIImage(named: "CheckBoxInActive")
        cell.selectionStyle = .none
        cell.fbPagesImageView.layer.cornerRadius = fbProfileImageView.layer.frame.height/2
        cell.fbPagesImageView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fbPagesModelObj = self.fbPagesModelArr[indexPath.row]
        //appDelegate.accessTokenFBPage = fbPagesModelObj.accessToken!
        pageToken = fbPagesModelObj.accessToken!
        print(appDelegate.accessTokenFBPage as Any)
        let cell : ChoosePagesForFbTableViewCell = tableView.cellForRow(at: indexPath) as! ChoosePagesForFbTableViewCell
        cell.checkBoxActive.image = UIImage(named: "CheckBoxActive")
        self.checkBoxActiveImageView.image = UIImage(named: "CheckBoxInActive")
        isSelected = false
        checkBoxSelected()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell : ChoosePagesForFbTableViewCell = tableView.cellForRow(at: indexPath) as! ChoosePagesForFbTableViewCell
        cell.checkBoxActive.image = UIImage(named: "CheckBoxInActive")
    }
    
}





