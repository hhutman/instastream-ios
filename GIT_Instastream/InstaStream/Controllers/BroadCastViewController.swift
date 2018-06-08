//
//  broadCastViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 05/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit
import AVKit
import Photos

class BroadCastViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var broadCastsButton: UIButton!
    @IBOutlet weak var anotherInstaStream: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var videoURL : NSURL?
    var broadCastModelObj : BroadcastsModel?
    var broadCastModelArr : [BroadcastsModel]? = []
    var streamUrlTime : String!
    var uploadFailed : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        if uploadFailed {
            shareButton.isUserInteractionEnabled = false
            shareButton.alpha = 0.5
        }
          cornerRadius()
          loadThumbnail()
          getBroadcastVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = Constants.COLOR_NAV
        navigationBarTransparent()
//        getBroadcastVideos()
    }
    
    func getBroadcastVideos() {
        APIHelper.shared().apiForBodyStringAndBlock(URL: "\(Constants.URL_TO_GET_USER_VIDEOS)", APIName: Constants.API_NAME_GET_BROADCAST_VIDEOS, MethodType: Constants.GET, ContentType: Constants.CONTENT_TYPE_JSON, BodyString: "",isLoading: true, controller: self, successblock:
            { (result) in
                if result != nil
                {
                    let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                    if(status == Constants.VALUE_STATUS_OK) {
                        let temp = result?["Broadcasts"] as! Array<Dictionary<String,Any>>
                        self.broadCastModelArr = BroadcastsModel.parseMultipleBroadcastsModels(array: temp)
//                        self.broadCastModelArr = self.broadCastModelArr?.filter({($0.title?.contains("Prashanth Samala30-05-2018T16:26:08"))!})
                        self.broadCastModelArr = self.broadCastModelArr?.filter({($0.title?.contains(self.streamUrlTime))!})
                        print(self.streamUrlTime)
                        if self.broadCastModelArr!.count > 0 {
                        if let broadCastModelObj = self.broadCastModelArr?[0] {
                            self.streamUrlTime = broadCastModelObj.url
                            print(self.streamUrlTime)
                            self.broadCastModelObj = broadCastModelObj
//                        DispatchQueue.main.async(execute:{
//                        //    self.collectionView.reloadData()
//                            self.loadThumbnail()
//                        })
                     }
                    }
                }
                    else {
                        var error = String.giveMeProperString(str: result?[Constants.KEY_MESSAGE]!)
                        if error.isEmpty {
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
                self.view.hideToastActivity()
                self.showToastWithMessage(strMessage: (error?.localizedDescription)!)
            })
        }
    }
    
    func cornerRadius() {
        shareButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        broadCastsButton.layer.cornerRadius = 5
        anotherInstaStream.layer.cornerRadius = 5
        self.anotherInstaStream.layer.borderWidth = 1
        self.anotherInstaStream.layer.borderColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 1.0).cgColor
    }
    
    func loadThumbnail() {
      //  let videoURL = URL(string:"http://instastream-tv.s3.amazonaws.com/5af19aea80d95b0515e74c17/broadcasts/5afaa5ee80d95b6ba909b36a/SampleVideo_1280x720_5mb.mp4")
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let timestamp = CMTime(seconds: 10, preferredTimescale: 60)
            let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(7, 8), actualTime: nil)
            if let thumbnail = UIImage(cgImage: cgImage) as? UIImage {
                imageView.image = thumbnail
            }
             imageView.alpha = 0.9
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            imageView.imageURL = URL(string:(self.broadCastModelObj?.thumbUrl)!)
//            imageView.alpha = 0.9
        }
        //imageView.imageURL = URL(string:(self.broadCastModelObj?.thumbUrl)!)
    }
    
    @IBAction func playBtnTapped(_ sender: Any) {
       // let videoURL = URL(string:"http://instastream-tv.s3.amazonaws.com/5af2cd1780d95b6eb58cfbdc/broadcasts/5afb0f1480d95b2043a100d1/upload.mov")
        if let videoURL = videoURL {
      //  if let videoURL = URL(string:(self.broadCastModelObj?.url)!) {
            let player = AVPlayer(url: videoURL as URL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }        
    }
    
    //for video uploading
    func camera(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker,animated: true)
    }
    
    func album() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        self.present(imagePicker,animated: true)
    }
    
    
    func uploadVideo(videoUrl : URL) {
        // self.dismiss(animated: true, completion: nil)
        
        var bodyDict = [String : Any]()
        bodyDict = ["title" : "Rec 3","tags_list" : ["Education","Computer Science"]]
        APIHelper.shared().uploadImageWithBlock(bodyDict: bodyDict, imagesArray: [], videoUrl: videoUrl, url: "\(Constants.APP_URL)\( Constants.URL_TO_UPLOAD)", filename: "", isLoading: true, controller: self) { (result, error) in
            if result != nil
            {
                let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                if(status == Constants.VALUE_STATUS_OK){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showToastWithMessage(strMessage: "Broadcast Video added succesfully")
                        if let controller1 = self as? BroadCastViewController {
                            Spinner.hide(controller: controller1)
                        }
                    }
                }
            }
            if((error) != nil){
                var error = String.giveMeProperString(str: result?[Constants.KEY_MESSAGE]!)
                if error.isEmpty{
                    error = Constants.MSG_ERROR
                }
                DispatchQueue.main.async(execute: {
                    self.showToastWithMessage(strMessage: error)
                })
            }
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        //album()
        //getBroadcastVideos()
        //    self.collectionView.reloadData()
        guard let streamUrl = self.streamUrlTime else {return}
        let activityViewController = UIActivityViewController(activityItems: [streamUrl], applicationActivities: [])
        // activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.checkFileExists()
        })
    }
    
    @IBAction func allBroadcastsButtonTapped(_ sender: Any) {
        let broadCastlistScreen = UIStoryboard.broadCastlistScreen()
        navigationController?.pushViewController(broadCastlistScreen, animated: true)
    }
    
    @IBAction func createAnotherInstaStream(_ sender: Any) {
        BaseClass.shared().selectedImages = []
        let goToGalleryView = UIStoryboard.galleryView()
   //     goToGalleryView.grabImages()
        navigationController?.pushViewController(goToGalleryView, animated: true)
    }
    
    // for saving live video
    func checkFileExists() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let ct : TimeInterval = Date.timeIntervalBetween1970AndReferenceDate
        let foo : NSInteger = NSInteger(round(ct))
        let toAppend = "movie\(foo).mov"
        //"Documents/Movie.m4v"
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
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL! as URL)
        }, completionHandler: { (saved, error) -> Void in
//            do {
//                try FileManager.default.removeItem(at: self.videoURL! as URL)
//            } catch let error {
//                print(error)
//            }
            if saved {
                //self.showToastWithMessage(strMessage: "Video successfully saved")
                let alertController = UIAlertController(title: "Video successfully saved", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

extension BroadCastViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        videoURL = info[UIImagePickerControllerMediaURL]as? NSURL
        print(videoURL!)
        print(videoURL?.relativePath as Any)
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            // imgView.image = thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        self.uploadVideo(videoUrl: videoURL! as URL)
        self.dismiss(animated: true, completion: nil)
    }
    
}

