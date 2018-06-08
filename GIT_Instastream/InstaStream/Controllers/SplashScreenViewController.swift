//
//  SplashScreenViewController.swift
//  InstaStream
//
//  Created by prasanth inavolu on 30/04/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit
import Photos
import AVKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var howItWorks: UIButton!
    @IBOutlet weak var imgView: UIImageView!

    let imagePicker = UIImagePickerController()
    var videoURL : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       howItWorks.layer.cornerRadius = 5
       // loadThumbnail()
       // album()
    }
    
    func loadThumbnail() {
        let videoURL = URL(string:"http://instastream-tv.s3.amazonaws.com/5af19aea80d95b0515e74c17/broadcasts/5afaa5ee80d95b6ba909b36a/SampleVideo_1280x720_5mb.mp4")
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let timestamp = CMTime(seconds: 13, preferredTimescale: 60)

            let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            imgView.image = thumbnail
            imgView.alpha = 0.9
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
          self.navigationBarTransparent()
    }
    
    func album() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        self.present(imagePicker,animated: true)
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        

//        let shareText = "Hello, world!"
//        if let image = UIImage(named: "App-Icon-1024px") {
//            let vc = UIActivityViewController(activityItems: ["http://instastream-tv.s3.amazonaws.com/5b0d60c480d95b79766044a5/broadcasts/5b0ed0ea80d95b7db9c67baa/Prashanth_Samala30-05-2018T16_26_08.mov"], applicationActivities: [])
//            present(vc, animated: true)
//        }
//        return
       // album()
        //return
//        let videoURL = URL(string:"/private/var/mobile/Containers/Data/Application/0DF02947-A8A0-451C-BDA0-AD6DEAC9A56A/tmp/AF45AB1F-A9A0-45BB-9C8A-9C175748F62F.MOV")
//        if let videoURL = videoURL{
//            let player = AVPlayer(url: videoURL as URL)
//
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//
//            present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
//        }
//        return
        let connectWthFb = UIStoryboard.connectWthFb()
        navigationController?.pushViewController(connectWthFb, animated: true)
    }
}



extension SplashScreenViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        videoURL = info[UIImagePickerControllerMediaURL]as? NSURL
        print(videoURL!)
        print("newline")
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
      //  self.uploadVideo(videoUrl: videoURL! as URL)
        
        //        Alamofire.upload(multipartFormData: { (multipartFormData) in
        //
        //            multipartFormData.append(videoURL, withName: "Video")
        //
        //        }, to:"http://54.175.48.253/api/v1/broadcasts/post")
        //        { (result) in
        //            switch result {
        //            case .success(let upload, _ , _):
        //
        //                upload.uploadProgress(closure: { (progress) in
        //
        //                    print("uploding")
        //                })
        //
        //                upload.responseJSON { response in
        //
        //                    print("done")
        //
        //                }
        //
        //            case .failure(let encodingError):
        //                print("failed")
        //                print(encodingError)
        //
        //            }
        //        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
