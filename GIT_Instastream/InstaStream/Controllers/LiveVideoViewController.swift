//
//  LiveVideoViewController.swift
//  InstaStream
//
//  Created by prasanth inavolu on 05/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit
//import LFLiveKit
//import FBSDKLoginKit
import Photos
import AVKit

class LiveVideoViewController: UIViewController {
    
    @IBOutlet weak var liveStreamingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playAndPaseView : UIView!
    @IBOutlet weak var finishButton : UIButton!
    @IBOutlet weak var playLiveButton : UIButton!
    @IBOutlet weak var stopLiveButton : UIButton!
    @IBOutlet weak var pauseBtn : UIButton!
    @IBOutlet weak var lblMessage : UILabel?
    
    var fbStreamingId : String!
    var reqUrl : URL?
    //    var livePrivacy: FBLivePrivacy = .everyone
    var livePrivacy: FBLivePrivacy!
    
    let imagesCount = BaseClass.sharedInstance.selectedImages
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var pictureInput : GPUImagePicture!
    var streamImagesHelper : StreamImagesHelper!
    var moviewWriter : GPUImageMovieWriter!
    var timerObj : Timer!
    var commentsTimerObj : Timer!
    var fbCommentsModelObj : FBCommentsModel!
    var fbCommentsModelArr : [FBCommentsModel]!
    var currentTime : String = ""
    //  var session : LFLiveSession!
    var alertResult : ((Bool) -> Void)?
    var timeEnded : Bool = false
    var uploadFailed : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCornerRadius()
        self.playLiveButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        //        if !FBSDKAccessToken.current().hasGranted("publish_actions") {
        //            fbLogin()
        //        }else{
        //            loadLFLiveKitView()
        //        }
        updateUserInterface()
        startLiveVideoTimer()
        self.playLiveButton.isUserInteractionEnabled = false
        self.finishButton.isUserInteractionEnabled = false
        self.pauseBtn.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationBarTransparent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Spinner.hide(controller: self)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    func backTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            self.showToastWithMessage(strMessage: "please check your internet connection")
            self.moveToPreviousScreen()
        case .wifi:
            print("connected")
        case .wwan:
            print("check wwan")
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
    
    func moveToPreviousScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let viewcontrollers = self.navigationController?.viewControllers else{return}
            for controller in viewcontrollers {
                if  let galleryVC = controller as? GalleryViewController {
                    self.navigationController?.popToViewController(galleryVC, animated: true)
                }
            }
            //            let viewcontrollers = self.navigationController?.viewControllers
            //            viewcontrollers?.forEach({ (vc) in
            //                if  let galleryVC = vc as? GalleryViewController {
            //                    self.navigationController!.popToViewController(galleryVC, animated: true)
            //                }
            //            })
        }
    }
    
    func startLiveVideoTimer()
    {
        //        self.view.alpha = 0.3
        //        let liveStartViCo = UIStoryboard.liveStreamTimer()
        //        liveStartViCo.timerResult = { (result) in
        //            if result {
        //                self.dismiss(animated: true, completion: nil)
        //                self.view.alpha = 1
        //                if !FBSDKAccessToken.current().hasGranted("publish_actions") {
        //                    self.fbLogin()
        //                }else{
        //                    self.loadLFLiveKitView()
        //                }
        //            }
        //        }
        //        self.navigationController?.present(liveStartViCo, animated: true, completion: nil)
        
        if !FBSDKAccessToken.current().hasGranted("publish_actions") {
            self.fbLogin()
        }else{
            //            self.loadLFLiveKitView()
            self.moveToLiveViewTimer()
        }
        
    }
    
    func moveToLiveViewTimer() {
        self.view.alpha = 0.3
        let liveStartViCo = UIStoryboard.liveStreamTimer()
        self.navigationController?.present(liveStartViCo, animated: true, completion: nil)
        self.loadLFLiveKitView()
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        
        let alertViewCo = UIStoryboard.alertView()
        alertViewCo.alertResult = { (result) in
            if result {
                self.dismiss(animated: true, completion: nil)
                self.stopLiveStreaming()
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.navigationController?.present(alertViewCo, animated: true, completion: nil)
    }
    
    func stopLiveStreaming() {
        if self.timerObj != nil {
            self.timerObj.invalidate()
        }
        if self.commentsTimerObj != nil {
            self.commentsTimerObj.invalidate()
        }
        self.session.stopLive()
        self.session.running = false
        self.session.preView = nil
        self.session.saveLocalVideo = false
        self.session.saveLocalVideoPath = nil
        self.streamImagesHelper.shouldStopStream()
        self.streamImagesHelper = nil
        self.appDelegate.accessTokenFBPage = nil
        //      self.moviewWriter.finishRecording()
        // self.session = nil
        uploadVideo(videoUrl: self.reqUrl!)
        //self.showAlertForUser()
        
        // self.moveToBroadcastsScreen()
        //        let fileSize = BaseClass.shared().getFileSizeWithUrl(url: self.reqUrl)
        //        print("file size is \(fileSize)")
    }
    
    func uploadVideo(videoUrl : URL) {
        let size = BaseClass.shared().getFileSizeWithUrl(url: videoUrl)
        print("FILE SIZE from uploadvideo is \(size)")
        self.view.alpha = 0.3
        var bodyDict = [String : Any]()
        currentTime = "\(BaseClass.shared().userName!)\(BaseClass.shared().getCurrentTime())"
        bodyDict = ["title" : currentTime,"tags_list" : ["Education","Computer Science","Dev"]]
        APIHelper.shared().uploadImageWithBlock(bodyDict: bodyDict, imagesArray: [], videoUrl: videoUrl, url: "\(Constants.APP_URL)\( Constants.URL_TO_UPLOAD)", filename: "", isLoading: true, controller: self.navigationController) { (result, error) in
            if result != nil
            {
                print(result as Any)
                let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                if(status == Constants.VALUE_STATUS_OK){
                    DispatchQueue.main.async {
                        self.showToastWithMessage(strMessage: "Broadcast Video added succesfully")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let controller2 = self.navigationController {
                            Spinner.hide(controller: controller2)
                        }
                        //                        if self.timeEnded {
                        //                            self.showAlertForUser()
                        //                        }else{
                        self.moveToBroadcastsScreen()
                        //   }
                    }
                }
            }
            else if((error) != nil) || (error == nil) {
                
                DispatchQueue.main.async {
                    if let controller2 = self.navigationController {
                        Spinner.hide(controller: controller2)
                    }
                }
                var error = String.giveMeProperString(str: result?[Constants.KEY_MESSAGE]!)
                if error.isEmpty{
                    error = Constants.MSG_ERROR
                    DispatchQueue.main.async(execute: {
                        self.showAlertForSizeExcess()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.showToastWithMessage(strMessage: error)
                    })
                }
            }
        }
    }
    
    func showAlertForUser() {
        let alertCo = UIAlertController(title: "LIVE UPDATE", message: "Live streaming time has ended", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default) { (_) in
            self.stopLiveStreaming()
            // self.moveToBroadcastsScreen()
        }
        alertCo.addAction(btnOk)
        self.present(alertCo, animated: true, completion: nil)
    }
    
    func showAlertForSizeExcess() {
        self.view.alpha = 0.3
        uploadFailed = true
        let size = BaseClass.shared().getFileSizeWithUrl(url: self.reqUrl!)
        print("FILE SIZE from showAlertForSizeExcess is \(size)")
        let alertCo = UIAlertController(title: "Error", message: "Video file size exceeded", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "OK", style: .default) { (_) in
            
            
            self.moveToBroadcastsScreen()
            // let viewcontrollers = self.navigationController?.viewControllers
//            guard let viewcontrollers = self.navigationController?.viewControllers else{return}
//            for controller in viewcontrollers {
//                if  let galleryVC = controller as? GalleryViewController {
//                    self.navigationController?.popToViewController(galleryVC, animated: true)
//                }
//            }
            //            viewcontrollers?.forEach({ (vc) in
            //                if  let galleryVC = vc as? GalleryViewController {
            //                    self.navigationController!.popToViewController(galleryVC, animated: true)
            //                }
            //            })
        }
        alertCo.addAction(btnOk)
        self.present(alertCo, animated: true, completion: nil)
    }
    
    func postVideoToPage() {
        var pathURL: NSURL
        // var videoData: NSData
        pathURL = self.reqUrl! as NSURL
        guard let videoData = try? Data(contentsOf: pathURL as URL) as NSData else{return}
        
        let videoObject: [String : AnyObject] = ["title" : "InstaStream-\(BaseClass.shared().getCurrentTime())" as AnyObject, "description": "" as AnyObject, pathURL.absoluteString!: videoData]
        let uploadRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "295356941001509/videos", parameters: videoObject, httpMethod: "POST")
        // self.view!.userInteractionEnabled = false
        _ = uploadRequest.start { (_, result, error) in
            if error == nil {
                //self.liveVideoId = (result as? NSDictionary)?.value(forKey: "id") as? String
                print(result as Any)
                //callback(result)
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func moveToBroadcastsScreen() {
        postVideoToPage()
        let broadCastViewCo = UIStoryboard.broadScreen()
        broadCastViewCo.videoURL = self.reqUrl! as NSURL
        broadCastViewCo.uploadFailed = uploadFailed
        broadCastViewCo.streamUrlTime = String.giveMeProperString(str: self.currentTime)
        print("video url is \(self.reqUrl!)")
        self.reqUrl = nil
        self.navigationController?.pushViewController(broadCastViewCo, animated: true)
    }
    
    func getCommentsFromFB(id : String) {
        var accessToken : String = ""
        if self.appDelegate.accessTokenFBPage != nil {
            accessToken = self.appDelegate.accessTokenFBPage!
        }else{
            accessToken = FBSDKAccessToken.current().tokenString
        }
        let path = "\(id)/comments"
        
        let params = ["fields":"from,message,name","access_token": accessToken]
        let request = FBSDKGraphRequest(
            graphPath: path,
            parameters: params,
            tokenString: accessToken,
            version : "v3.0",
            httpMethod: "GET"
        )
        
        _ = request?.start { (_, result, error) in
            if error == nil {
                let dict = result as! [String : AnyObject]
                print("COMMENTSRESPONSE")
                print(dict)
                let temp = dict["data"] as! Array<Dictionary<String,Any>>
                self.fbCommentsModelArr = FBCommentsModel.parseMultipleFBComments(array: temp)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }else{
                print(error?.localizedDescription as Any)
                //callback(error as Any)
            }
        }
    }
    
    func makeCornerRadius() {
        self.playAndPaseView.layer.cornerRadius = 25
        self.playAndPaseView.clipsToBounds = true
        self.finishButton.layer.cornerRadius = 10
        self.finishButton.clipsToBounds = true
    }
    
    //LFLIVEKIT code
    func loadLFLiveKitView() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
        let foo : NSInteger = NSInteger(round(ct))//movie978307200.mov
        let toAppend = "movie\(foo).mov"
        //"Documents/Movie.m4v"
        let fileUrl = NSURL(fileURLWithPath:documentsPath)
        reqUrl = fileUrl.appendingPathComponent(toAppend)
        print("view did load")
        print(reqUrl as Any)
        do {
            try FileManager.default.removeItem(at: self.reqUrl!)
            print("File removed")
        }catch{
            print("Not Removed")
        }
        
        session.saveLocalVideo = true
        session.saveLocalVideoPath = reqUrl
        session.delegate = self
        session.preView = liveStreamingView
        //        self.session.running = false
        self.streamImagesHelper = StreamImagesHelper.init(session: session, images: BaseClass.shared().selectedImages)
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        // session.saveLocalVideo = true
        //        session.saveLocalVideoPath = reqUrl
        liveStreamingView.addSubview(containerView)
        containerView.addSubview(stateLabel)
        // DispatchQueue.main.async {
        //            self.startLiveStreaming()
        //}
        // fbLogin()
    }
    
    func saveSession() {
        session.saveLocalVideo = true
        session.saveLocalVideoPath = reqUrl
    }
    
    func startLiveStreaming() {
        if FBSDKAccessToken.current() != nil {
            print("selected privacy in live \(self.livePrivacy)")
            FBLiveAPI.shared.startLive(privacy: livePrivacy) { result in
                print(result)
                self.playLiveButton.isUserInteractionEnabled = true
                self.finishButton.isUserInteractionEnabled = true
                self.pauseBtn.isUserInteractionEnabled = true
                //                if let _ = (((result as? NSDictionary)?.value(forKey: "body") as AnyObject).value(forKey: "error") as AnyObject).value(forKey: "message") as? String {
                //                    self.showToastWithMessage(strMessage: "problem occured while streaming")
                //                    return
                //                }
                guard let streamUrlString = (result as? NSDictionary)?.value(forKey: "stream_url") as? String else {
                    self.showToastWithMessage(strMessage: "problem occured while streaming")
                    return
                }
                let streamUrl = URL(string: streamUrlString)
                guard let lastPathComponent = streamUrl?.lastPathComponent,
                    let query = streamUrl?.query else {
                        return
                }
                print(lastPathComponent,query)
                // self.startLiveButton.setTitle("End live", for: UIControlState())
                let stream = LFLiveStreamInfo()
                let reqUrl = "rtmp://rtmp-api.facebook.com:80/rtmp/\(lastPathComponent)?\(query)"
                stream.url = reqUrl
                print(stream.url)
                self.session.startLive(stream)
                self.fbStreamingId = (result as? NSDictionary)?.value(forKey: "id") as? String
                self.getCommentsFromFB(id: self.fbStreamingId)
                self.timerObj = Timer.scheduledTimer(withTimeInterval: 75, repeats: false, block: { (_) in
                    self.timeEnded = true
                    // self.stopLiveStreaming()
                    self.showAlertForUser()
                })
                self.commentsTimerObj = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (_) in
                    self.getCommentsFromFB(id: self.fbStreamingId)
                })
            }
        } else {
            fbLogin()
        }
    }
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                        self.startLiveStreaming()
                    }
                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            DispatchQueue.main.async {
                self.session.running = true
                self.startLiveStreaming()
            }
            break;
        case AVAuthorizationStatus.denied:
            self.moveToPreviousScreen()
            break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
            })
            break;
        case AVAuthorizationStatus.authorized:
            break;
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    @IBAction func playBtnTapped(_sender : UIButton) {
        self.streamImagesHelper.pauseChanged(false)
        self.pauseBtn.isHidden = false
        self.playLiveButton.isHidden = true
        self.showToastWithMessage(strMessage: "Resumed")
    }
    
    @IBAction func pauseBtnTapped(_sender : UIButton) {
        self.streamImagesHelper.pauseChanged(true)
        self.pauseBtn.isHidden = true
        self.playLiveButton.isHidden = false
        self.showToastWithMessage(strMessage: "Paused")
    }
    
    func checkFileExists() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
        let foo : NSInteger = NSInteger(round(ct))
        let toAppend = "movie\(foo).mov"
        //"Documents/Movie.m4v"
        let fileUrl = NSURL(fileURLWithPath:documentsPath)
        if let pathComponent = fileUrl.appendingPathComponent(toAppend) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                self.checkStatus()
            } else {
                print("FILE NOT AVAILABLE")
                self.checkStatus()
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    func checkStatus() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            self.saveVideoToGallery()
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.saveVideoToGallery()
                }
                    
                else {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    func saveVideoToGallery() {
        
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.reqUrl!)
        }, completionHandler: { (saved, error) -> Void in
            do {
                try FileManager.default.removeItem(at: self.reqUrl!)
            } catch let error {
                print(error)
            }
            if saved {
                let alertController = UIAlertController(title: "Video successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func fbLogin() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withPublishPermissions: ["publish_actions","manage_pages","publish_pages"], from: self) { (result, error) in
            if error != nil {
                print("Error")
            } else if result?.isCancelled == true {
                print("Cancelled")
            } else {
                print("Logged in")
                // self.startLiveStreaming()
                //self.loadLFLiveKitView()
                self.moveToLiveViewTimer()
            }
        }
    }
    
    //MARK: - Getters and Setters
    
    //  Default resolution 368 * 640 Audio: 44.1 iphone6 ​​above 48 channels stereo vertical screen
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low2)
        videoConfiguration?.videoSize = CGSize(width:640,height:640)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_WIDTH - 90.5))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 180, height: 40))
        stateLabel.text = "not connected"
        stateLabel.textColor = UIColor.red
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    fileprivate func showEmptyMessage(count : Int){
        lblMessage?.text = ""
        if count == 0{
            lblMessage?.text = "No comments yet"
        }
    }
    
}

extension LiveVideoViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! LiveVideoCollectionViewCell
        cell.selectedImages.image = imagesCount[indexPath.row]
        cell.selectedImages.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.streamImagesHelper.swapImage(imagesCount[indexPath.row])
        self.streamImagesHelper.initTransform()
    }
}

extension LiveVideoViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = self.fbCommentsModelArr else{
            return 0
        }
        showEmptyMessage(count: arr.count)
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableView", for: indexPath) as! LiveVideoTableViewCell
        fbCommentsModelObj = self.fbCommentsModelArr?[indexPath.row]
        cell.commentUserName.text = fbCommentsModelObj.name
        cell.commentsByUser.text = fbCommentsModelObj.message
        cell.commentsByUser.numberOfLines = 0
        return cell
    }
}


extension LiveVideoViewController : LFLiveSessionDelegate {
    
    //MARK: - Callbacks
    
    func liveSessionCapturedFrame(_ session: LFLiveSession?) {
        if (self.streamImagesHelper != nil) {
            //   print("CHECK PRASHANTH is liveSessionCapturedFrame")
            self.streamImagesHelper.transformCurrentImage()
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        //print("CHECK PRASHANTH")
        //print("debugInfo: \(String(describing: debugInfo?.currentBandwidth))")
        //self.pictureInput.processImage()
        //  streamImagesHelper.initFilters(with: <#T##UIImage!#>)
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "not connected"
            break;
        case LFLiveState.pending:
            stateLabel.text = "connecting"
            break;
        case LFLiveState.start:
            stateLabel.text = "connected"
            self.dismiss(animated: true, completion: nil)
            self.view.alpha = 1
            self.showToastWithMessage(strMessage: "Connected")
            break;
        case LFLiveState.error:
            stateLabel.text = "connection error"
            break;
        case LFLiveState.stop:
            stateLabel.text = "not connected"
            break;
        default:
            break;
        }
    }
    
}


