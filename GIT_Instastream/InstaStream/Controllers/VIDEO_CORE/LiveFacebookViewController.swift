////
////  LiveVideoViewController.swift
////  InstaStream
////
////  Created by prasanth inavolu on 05/05/18.
////  Copyright © 2018 prasanth inavolu. All rights reserved.
////
//
//import UIKit
////import LFLiveKit
////import FBSDKLoginKit
//import Photos
//import AVKit
//
//class LiveFacebookViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var playAndPaseView : UIView!
//    @IBOutlet weak var finishButton : UIButton!
//    @IBOutlet weak var startLiveButton : UIButton!
//    @IBOutlet weak var stopLiveButton : UIButton!
//    @IBOutlet weak var pauseBtn : UIButton!
//
//    var reqUrl : URL?
//    var livePrivacy: FBLivePrivacy = .everyone
//    let imagesCount = BaseClass.sharedInstance.selectedImages
//    var timerObj : Timer!
//
//    @IBOutlet var contentView: UIView!
//    @IBOutlet var imgView: UIImageView!
//
//    var session : VCSimpleSession!
//
//    var arrImages : [UIImage]!
//    var count = 0
//    var previewLayer:AVCaptureVideoPreviewLayer!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        arrImages = imagesCount
//        makeCornerRadius()
//        //LFLIVEKIT START
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
//        let foo : NSInteger = NSInteger(round(ct))
//        //NSInteger(round(ct))//5
//        //NSInteger(round(ct))//movie978307200.mov
//        let toAppend = "movie\(foo).mov"
//        //"movie\(foo).mov"
//        //"Documents/Movie.m4v"
//        let fileUrl = NSURL(fileURLWithPath:documentsPath)
//        reqUrl = fileUrl.appendingPathComponent(toAppend)
//        print("view did load")
//        print(reqUrl as Any)
//        session1.saveLocalVideo = true
//        session1.saveLocalVideoPath = reqUrl
//        //LFLIVEKIT CLOSE
//        loadVideoKitView()
//    }
//    //LFLIVEKIT
//    var session1: LFLiveSession = {
//        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
//        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
//
//        let session1 = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
//        //        session?.delegate = self
//        //        session?.preView = self.view
//        //        session.saveLocalVideo = true
//        //        session.saveLocalVideoPath = reqUrl
//        return session1!
//    }()
//
//
//    func checkFileExists() {
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
//        let foo : NSInteger = NSInteger(round(ct))
//        let toAppend = "movie\(foo).mov"
//        //"Documents/Movie.m4v"
//        //"movie\(foo).mov"
//        //        let fileUrl = NSURL(string: documentsPath)
//        let fileUrl = NSURL(fileURLWithPath:documentsPath)
//        // reqUrl = fileUrl.appendingPathComponent(toAppend)
//        if let pathComponent = fileUrl.appendingPathComponent(toAppend) {
//            let filePath = pathComponent.path
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
//                self.checkStatus()
//            } else {
//                print("FILE NOT AVAILABLE")
//                self.checkStatus()
//            }
//        } else {
//            print("FILE PATH NOT AVAILABLE")
//        }
//    }
//
//
//    func checkStatus() {
//        // Get the current authorization state.
//        let status = PHPhotoLibrary.authorizationStatus()
//
//        if (status == PHAuthorizationStatus.authorized) {
//            // Access has been granted.
//            self.saveVideoToGallery()
//        }
//
//        else if (status == PHAuthorizationStatus.denied) {
//            // Access has been denied.
//        }
//
//        else if (status == PHAuthorizationStatus.notDetermined) {
//
//            // Access has not been determined.
//            PHPhotoLibrary.requestAuthorization({ (newStatus) in
//
//                if (newStatus == PHAuthorizationStatus.authorized) {
//                    self.saveVideoToGallery()
//                }
//
//                else {
//
//                }
//            })
//        }
//
//        else if (status == PHAuthorizationStatus.restricted) {
//            // Restricted access - normally won't happen.
//        }
//    }
//
//    func saveVideoToGallery() {
//
//        PHPhotoLibrary.shared().performChanges({() -> Void in
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.reqUrl!)
//        }, completionHandler: { (saved, error) -> Void in
//            do {
//                try FileManager.default.removeItem(at: self.reqUrl!)
//            } catch let error {
//                print(error)
//            }
//            if saved {
//                let alertController = UIAlertController(title: "SAVED", message: nil, preferredStyle: .alert)
//                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        })
//
//        return
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.reqUrl!)
//            }) { saved, error in
//                if saved {
//                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//        }
//    }
//    //LFLIVEKIT
//    func backTapped() {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func finishTapped(_ sender: Any) {
//
//        let alertViewCo = UIStoryboard.alertView()
//        alertViewCo.alertResult = { (result) in
//            if result {
//                self.dismiss(animated: true, completion: nil)
//                self.endFBLive()
//                self.moveToBroadcastsScreen()
//            }else{
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//        self.navigationController?.present(alertViewCo, animated: true, completion: nil)
//    }
//
//    func moveToBroadcastsScreen() {
//        let broadCastViewCo = UIStoryboard.broadScreen()
//      //  broadCastViewCo.videoURL = self.reqUrl! as NSURL //use  for lflivekit
//        self.navigationController?.pushViewController(broadCastViewCo, animated: true)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated:true);
//        self.navigationBarTransparent()
//    }
//
//    func makeCornerRadius() {
//        self.playAndPaseView.layer.cornerRadius = 25
//        self.playAndPaseView.clipsToBounds = true
//        self.finishButton.layer.cornerRadius = 10
//        self.finishButton.clipsToBounds = true
//    }
//
//    //VIDEOCORE code
//    func loadVideoKitView() {
//       // arrImages = ["photography","jobs-1","Pets","shopping"]
//       // arrImages  = [UIImage(named:"photography")!,UIImage(named:"jobs-1")!,UIImage(named:"Pets")!,UIImage(named:"shopping")!]
////        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
////            self.count = self.count + 1
////            if (self.count%2 as Int) == 0 {
////                //                        self.view.backgroundColor = UIColor.red
////                //self.imgView.image = UIImage(named:"instabg")
////            }
////            else {
////                // self.view.backgroundColor = UIColor.green
////                //   self.imgView.image = UIImage(named:"logo_launch")
////
////            }
////        }
//        // loadNavButton()
//
//        // session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: false)
//        session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: false, cameraState: .back, aspectMode: .ascpectModeFill)
//        session.previewView.sizeToFit()
//        contentView.addSubview(session.previewView)
//        session.previewView.frame = contentView.bounds
//        session.delegate = self
//        self.view.addSubview(stateLabel)
//      //  fbLogin()
//        startLiveStreaming()
//    }
//
//    func startLiveStreaming() {
//        if FBSDKAccessToken.current() != nil {
//            FBLiveAPI.shared.startLive(privacy: livePrivacy) { result in
//                guard let streamUrlString = (result as? NSDictionary)?.value(forKey: "stream_url") as? String else {
//                    return
//                }
//                let streamUrl = URL(string: streamUrlString)
//
//                guard let lastPathComponent = streamUrl?.lastPathComponent,
//                    let query = streamUrl?.query else {
//                        return
//                }
//
//                self.session.startRtmpSession(
//                    withURL: "rtmp://rtmp-api.facebook.com:80/rtmp/",
//                    andStreamKey: "\(lastPathComponent)?\(query)")
//                print("STARTED LIVE STREAMING in code")
//
//
//                //                self.session.addPixelBufferSource(UIImage(named:"App-Icon-1024px"), with: CGRect(x:180,y:0,width:self.session.previewView.frame.size.width*6,height:200)) // working may18 11:21 am //aspect fit
//
//
//
//              //  self.session.addPixelBufferSource(UIImage(named:"winery_tour"), with: CGRect(x:0,y:10,width:self.contentView.frame.size.width,height:100))
//
//                self.timerObj =  Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
//                    print(" NUMBER is \n \(self.count)")
//                    if self.count >= 4 {
//                        self.count = 0
//                    }
//                    if let img = self.arrImages[self.count] as? UIImage {
//                        self.session.addPixelBufferSource(img, with: self.contentView.bounds)
//                        self.count = self.count + 1
//                    }
//
////                        self.session.addPixelBufferSource(UIImage(named:"steve-jobs-original-iphone-apple-sign"), with: self.contentView.bounds)
//
//
//                }
//            }
//        } else {
//            fbLogin()
//        }
//    }
//
//    func endFBLive() {
//        if FBSDKAccessToken.current() != nil {
//            FBLiveAPI.shared.endLive { _ in
//                DispatchQueue.main.async {
//                    self.session.endRtmpSession()
//                    if self.timerObj != nil {
//                        self.timerObj.invalidate()
//                    }
//                    self.checkFileExists()
//
//                }
//
//            }
//        } else {
//            fbLogin()
//        }
//    }
//    //MARK: - Events
//
//    @IBAction func startLiveBtnTapped(_sender : UIButton) {
//
//
//    }
//
//    @IBAction func pauseBtnTapped(_sender : UIButton) {
//
//    }
//
//    func fbLogin() {
//        let loginManager = FBSDKLoginManager()
//        loginManager.logIn(withPublishPermissions: ["publish_actions","manage_pages","publish_pages"], from: self) { (result, error) in
//            if error != nil {
//                print("Error")
//            } else if result?.isCancelled == true {
//                print("Cancelled")
//            } else {
//                print("Logged in")
//                self.startLiveStreaming()
//            }
//        }
//        //        loginManager.logIn(withPublishPermissions: ["publish_actions/manage_pages/publish_pages"], from: self) { (result, error) in
//        //            if error != nil {
//        //                print("Error")
//        //            } else if result?.isCancelled == true {
//        //                print("Cancelled")
//        //            } else {
//        //                print("Logged in")
//        //            }
//        //        }
//    }
//
//    var stateLabel: UILabel = {
//        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 180, height: 40))
//        stateLabel.text = "not connected"
//        stateLabel.textColor = UIColor.red
//        stateLabel.font = UIFont.systemFont(ofSize: 14)
//        return stateLabel
//    }()
//
//}
//
//extension LiveFacebookViewController : UICollectionViewDelegate,UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imagesCount.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! LiveVideoCollectionViewCell
//        cell.selectedImages.image = imagesCount[indexPath.row]
//        return cell
//    }
//}
//
//extension LiveFacebookViewController : UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tableView", for: indexPath) as! LiveVideoTableViewCell
//        return cell
//    }
//}
//
//
//extension LiveFacebookViewController : VCSessionDelegate {
//    func connectionStatusChanged(_ sessionState: VCSessionState) {
//        switch session.rtmpSessionState {
//        case .starting:
//            stateLabel.text = "Connecting"
//           // stateLabel.backgroundColor = UIColor.orange
//        case .started:
//            stateLabel.text = "Disconnect"
//          //  stateLabel.backgroundColor = UIColor.red
//        default:
//            stateLabel.text = "Live"
//           // stateLabel.backgroundColor = UIColor.green
//        }
//    }
//
//}
//
//
