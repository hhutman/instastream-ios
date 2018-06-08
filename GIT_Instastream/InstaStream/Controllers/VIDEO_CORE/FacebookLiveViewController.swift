////
////  FacebookLiveViewController.swift
////  InstaStream
////
////  Created by Orbysol on 4/2/18.
////  Copyright © 2018 Orbysol. All rights reserved.
////
//
//import UIKit
//import Photos
//import AVKit
//
//class FacebookLiveViewController: UIViewController {
//    
//    @IBOutlet var liveButton: UIButton!
//    @IBOutlet var contentView: UIView!
//     @IBOutlet var imgView: UIImageView!
//    
//    var session : VCSimpleSession!
//    var livePrivacy: FBLivePrivacy = .everyone
//    var reqUrl : URL?
//    
//    var arrImages : [String]!
//    var count = 0
//    var previewLayer:AVCaptureVideoPreviewLayer!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        arrImages = ["instabg","logo_launch","App-Icon-1024px"]
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
//            self.count = self.count + 1
//            if (self.count%2 as Int) == 0 {
//                //                        self.view.backgroundColor = UIColor.red
//                //self.imgView.image = UIImage(named:"instabg")
//            }
//            else {
//                // self.view.backgroundColor = UIColor.green
//                //   self.imgView.image = UIImage(named:"logo_launch")
//                
//            }
//        }
//        // loadNavButton()
//        liveButton.layer.cornerRadius = 15
//        
//        // session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: false)
//        session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: false, cameraState: .back, aspectMode: .ascpectModeFill)
//        session.previewView.sizeToFit()
//        contentView.addSubview(session.previewView)
//        session.previewView.frame = contentView.bounds
//        session.delegate = self
//        
//        //   session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: true)
//        //session.aspectMode = VCAspectMode.aspectModeFit
//        //        let imgView = UIImageView()
//        //        imgView.frame = CGRect(x:640,y:360,width:640,height:360)
//        //        imgView.image = UIImage(named:"App-Icon-1024px")
//        //        imgView.backgroundColor = UIColor.yellow
//        // session.previewView.addSubview(imgView)
//        // session.addPixelBufferSource(imgView.image, with: imgView.frame )
//        
//        //        session.previewView.frame = CGRect(x:270,y:87,width:100,height:200)// working may18 11:21 am
//        //    session.previewView.frame = self.contentView.bounds
//        ///CGRect(x:0,y:10,width:1024,height:270)
//        
//        //(x:265,y:100,width:100,height:180) in phone image overlaying
//        //CGRect(x:265,y:100,width:100,height:180)//contentView.bounds
//        
//        
//        //     contentView.addSubview(session.previewView)
//        
//        
//        
//        // session.delegate = self
//        
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
//        let foo : NSInteger = NSInteger(round(ct))
//        //NSInteger(round(ct))//5
//        //NSInteger(round(ct))//movie978307200.mov
//        let toAppend = "Documents/Movie.m4v"
//        //"movie\(foo).mov"
//        //"Documents/Movie.m4v"
//        let fileUrl = NSURL(fileURLWithPath:documentsPath)
//        reqUrl = fileUrl.appendingPathComponent(toAppend)
//        print("view did load")
//        print(reqUrl as Any)
//        session1.saveLocalVideo = true
//        session1.saveLocalVideoPath = reqUrl
//        
//        // Do any additional setup after loading the view.
//        
//        
//        //     CVPixelBufferRef pxbuffer = nil;
//        //  let px : CVPixelBuffer? = nil
//        // NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: nil];
//        
//        //   CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, 512,
//        //   512, kCVPixelFormatType_32BGRA, nil,
//        // &pxbuffer);
//        // let status1 = CVPixelBufferCreate(kCFAllocatorDefault, 152, 152, kCVPixelFormatType_32BGRA, nil, px as! CVPixelBuffer)
//        //NSLog(@"Status is: %d", status);
//        //     [_session addPixelBufferSource:&pxbuffer withSize:(CGSizeMake(512, 512)) withRect:(CGRectMake(100, 100, 512, 512))];
//        
//        
//    }
//    
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
//    fileprivate func loadNavButton() {
//        //Back Button
//        let btnBack = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(FacebookLiveViewController.backTapped))
//        self.navigationItem.leftBarButtonItem = btnBack
//    }
//    
//    @objc func backTapped() {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func liveTapped(_ sender: Any) {
//        switch session.rtmpSessionState {
//        case .none, .previewStarted, .ended, .error:
//            startFBLive()
//        default:
//            endFBLive()
//            break
//        }
//    }
//    
//    func startFBLive() {
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
//                //                self.session.addPixelBufferSource(UIImage(named:"App-Icon-1024px"), with: CGRect(x:180,y:0,width:self.session.previewView.frame.size.width*6,height:200)) // working may18 11:21 am
//                
//                
//                
//                self.session.addPixelBufferSource(UIImage(named:"App-Icon-1024px"), with: CGRect(x:0,y:10,width:self.contentView.frame.size.width,height:100)) // working may18 11:21 am
//                
//                
//                //                let sessionCamera = AVCaptureSession()
//                //
//                //                self.previewLayer = AVCaptureVideoPreviewLayer(session: sessionCamera)
//                //                self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                //
//                //                let rootLayer :CALayer = self.session.previewView.layer
//                //                rootLayer.masksToBounds=true
//                //                self.previewLayer.frame = rootLayer.bounds
//                //                rootLayer.addSublayer(self.previewLayer)
//                
//                //  self.contentView.addSubview(self.session.previewView)
//                // self.session.previewView.bringSubview(toFront: self.session.previewView)
//                //self.session.previewView.removeFromSuperview()
//                //  self.session = nil
//                
//                //self.session = VCSimpleSession(videoSize: CGSize(width: 375, height: 375), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: true)
//                
//                //  self.session.previewView.frame = CGRect(x:270,y:87,width:100,height:200)
//                //self.contentView.addSubview(self.session.previewView)
//                
//                //                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
//                //                    self.count = self.count + 1
//                //                    if (self.count%2 as Int) == 0 {
//                //                        //                        self.view.backgroundColor = UIColor.red
//                //                        self.session.addPixelBufferSource(UIImage(named:"fall_tour2016"), with: CGRect(x:100,y:0,width:self.session.previewView.frame.size.width*5,height:200))
//                //                    }
//                //                    else {
//                //                        // self.view.backgroundColor = UIColor.green
//                //                        self.session.addPixelBufferSource(UIImage(named:"winery_tour"), with: CGRect(x:100,y:0,width:self.session.previewView.frame.size.width*5,height:200))
//                //
//                //                    }
//                //                }
//                
//                //self.session.previewView.bounds
//                //CGRect(x:0,y:0,width:500,height:300) )
//                //                self.session.previewView.frame = CGRect(x:270,y:87,width:100,height:200)
//                //                self.contentView.addSubview(self.session.previewView)
//                
//                
//                // self.session.addPixelBufferSource(UIImage(named:"App-Icon-1024px"), with: CGRect(x:0,y:0,width:175,height:200) )
//                
//                //                )
//                
//                // self.livePrivacyControl.isUserInteractionEnabled = false
//            }
//        } else {
//            fbLogin()
//        }
//    }
//    
//    func endFBLive() {
//        if FBSDKAccessToken.current() != nil {
//            FBLiveAPI.shared.endLive { _ in
//                self.session.endRtmpSession()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                    //   self.checkFileExists()
//                })
//                // self.livePrivacyControl.isUserInteractionEnabled = true
//            }
//        } else {
//            fbLogin()
//        }
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
//}
//
//extension FacebookLiveViewController : VCSessionDelegate {
//    func connectionStatusChanged(_ sessionState: VCSessionState) {
//        switch session.rtmpSessionState {
//        case .starting:
//            liveButton.setTitle("Conneting", for: .normal)
//            liveButton.backgroundColor = UIColor.orange
//        case .started:
//            liveButton.setTitle("Disconnect", for: .normal)
//            liveButton.backgroundColor = UIColor.red
//        default:
//            liveButton.setTitle("Live", for: .normal)
//            liveButton.backgroundColor = UIColor.green
//        }
//    }
//    
//    
//}

