//
//  LFLiveKitViewController.swift
//  InstaStream
//
//  Created by Orbysol on 5/16/18.
//  Copyright © 2018 Orbysol. All rights reserved.
//

import UIKit
//import LFLiveKit
//import FBSDKLoginKit
import Photos
import AVKit

class LFLiveKitViewController: UIViewController,LFLiveSessionDelegate {
    
    @IBOutlet weak var obj: AsyncImageView!
    
    var livePrivacy: FBLivePrivacy = .everyone
    var count = 0
    var imgView = UIImageView()
    var reqUrl : URL?
    var playView = AVPlayer()
    var playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imgView.frame = CGRect(x:100,y:100,width:300,height:300)
        //  imgView.image = UIImage(named:"App-Icon-1024px")
        imgView.backgroundColor = UIColor.yellow
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
        let foo : NSInteger = NSInteger(round(ct))//movie978307200.mov
        let toAppend = "movie\(foo).mov"
        //"Documents/Movie.m4v"
        //
        //"Documents/Movie.m4v"
        //        //        let fileUrl = NSURL(string: documentsPath)
        let fileUrl = NSURL(fileURLWithPath:documentsPath)
        reqUrl = fileUrl.appendingPathComponent(toAppend)
        print("view did load")
        print(reqUrl as Any)
        session.saveLocalVideo = true
        session.saveLocalVideoPath = reqUrl
        //  self.checkStatus()
        // self.checkFileExists()
        
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        // self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(beautyButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(startLiveButton)
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        beautyButton.addTarget(self, action: #selector(didTappedBeautyButton(_:)), for: .touchUpInside)
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        
        //        self.view.addSubview(imgView)
        //
        //        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (_) in
        //            self.count = self.count + 1
        //            if (self.count%2 as Int) == 0 {
        //                self.imgView.backgroundColor = UIColor.red
        //            }
        //            else {
        //                self.imgView.backgroundColor = UIColor.green
        //
        //            }
        //   }
    }
    
    
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
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
    
    //MARK: - Events
    
    // 开始直播
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        
        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //                        self.session.saveLocalVideo = true
        //                        self.session.saveLocalVideoPath = self.reqUrl
        //                    })
        
        //  startLiveButton.isSelected = true
        //!startLiveButton.isSelected;
        //        if (startLiveButton.isSelected) {
        if (startLiveButton.tag == 0) {
            
            if FBSDKAccessToken.current() != nil {
                FBLiveAPI.shared.startLive(privacy: livePrivacy) { result in
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    //                        self.session.saveLocalVideo = true
                    //                        self.session.saveLocalVideoPath = self.reqUrl
                    //                    })
                    guard let streamUrlString = (result as? NSDictionary)?.value(forKey: "stream_url") as? String else {
                        return
                    }
                    let streamUrl = URL(string: streamUrlString)
                    
                    guard let lastPathComponent = streamUrl?.lastPathComponent,
                        let query = streamUrl?.query else {
                            return
                    }
                    print(lastPathComponent,query)
                    self.startLiveButton.setTitle("End live", for: UIControlState())
                    let stream = LFLiveStreamInfo()
                    let reqUrl = "rtmp://rtmp-api.facebook.com:80/rtmp/\(lastPathComponent)?\(query)"
                    stream.url = reqUrl
                    print(stream.url)
                    self.session.startLive(stream)
                    // self.setPathForRecording()
                    
                    
                    
                    //                    self.checkFileExists()
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    //                        //self.checkStatus()
                    //                        self.checkFileExists()
                    //                    })
                    
                    //                    let vi = UIView()
                    //                    vi.frame = CGRect(x:240,y:400,width:100,height:200)
                    //                    //imgView.image = UIImage(named:"App-Icon-1024px")
                    //                    vi.backgroundColor = UIColor.yellow
                    
                    //self.session.stopVideoSource(self.view)
                    
                    //  self.session.pushVideo(CVPixelBuffer?)
                    
                    // self.livePrivacyControl.isUserInteractionEnabled = false
                }
                startLiveButton.tag = 1
                
            } else {
                fbLogin()
                startLiveButton.tag = 0
            }
        } else {
            startLiveButton.setTitle("Began to live", for: UIControlState())
            session.stopLive()
            startLiveButton.tag = 0
            //self.session.saveLocalVideo = true
            //  self.session.saveLocalVideoPath = self.reqUrl
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.checkFileExists()
            })
        }
    }
    
    
    func setPathForRecording() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.session.saveLocalVideo = true
            self.session.saveLocalVideoPath = self.reqUrl
        })
        self.session.saveLocalVideo = true
        self.session.saveLocalVideoPath = self.reqUrl
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //            self.checkFileExists()
        //        })
    }
    
    func endFBLive() {
        if FBSDKAccessToken.current() != nil {
            FBLiveAPI.shared.endLive { _ in
                self.startLiveButton.setTitle("Began to live", for: UIControlState())
                self.session.stopLive()
                //   self.session.endRtmpSession()
                // self.livePrivacyControl.isUserInteractionEnabled = true
            }
        } else {
            fbLogin()
        }
    }
    
    func checkFileExists() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
        let foo : NSInteger = NSInteger(round(ct))
        let toAppend = "movie\(foo).mov"
        //"Documents/Movie.m4v"
        //"movie\(foo).mov"
        //        let fileUrl = NSURL(string: documentsPath)
        let fileUrl = NSURL(fileURLWithPath:documentsPath)
        // reqUrl = fileUrl.appendingPathComponent(toAppend)
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
                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        return
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.reqUrl!)
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
    }
    
    func fbLogin() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withPublishPermissions: ["publish_actions"], from: self) { (result, error) in
            if error != nil {
                print("Error")
            } else if result?.isCancelled == true {
                print("Cancelled")
            } else {
                print("Logged in")
            }
        }
    }
    
    // 美颜
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
    // 摄像头
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.front) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
    
    // 关闭
    func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }
    
    //MARK: - Getters and Setters
    
    //  默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    // 视图
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    
    // 状态Label
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 180, height: 40))
        stateLabel.text = "not connected"
        stateLabel.textColor = UIColor.red
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    // 关闭按钮
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControlState())
        return closeButton
    }()
    
    // 摄像头
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControlState())
        return cameraButton
    }()
    
    // 摄像头
    var beautyButton: UIButton = {
        let beautyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 3, y: 20, width: 44, height: 44))
        beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControlState.selected)
        beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControlState())
        return beautyButton
    }()
    
    // 开始直播按钮
    var startLiveButton: UIButton = {
        let startLiveButton = UIButton(frame: CGRect(x: 30, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width - 10 - 44, height: 44))
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.setTitle("Began to live", for: UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        startLiveButton.backgroundColor = UIColor.yellow
        startLiveButton.tag = 0
        
        //UIColor(colorLiteralRed: 50, green: 32, blue: 245, alpha: 1)
        return startLiveButton
    }()
}
