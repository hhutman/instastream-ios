//
//  AllInstaStreamsViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 08/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit
import AVKit

class AllInstaStreamsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblMessage: UILabel!

    var broadCastModelObj : BroadcastsModel?
    var broadCastModelArr : [BroadcastsModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(AllInstaStreamsViewController.backTapped))
        navigationItem.leftBarButtonItem = back
        let add = UIBarButtonItem(image: UIImage(named: "Add Button"), style: .plain, target: self, action: #selector(AllInstaStreamsViewController.addTapped))
        navigationItem.rightBarButtonItem = add
        addCustomTitleForNavigationBar(titleStr: "InstaStream.tv") 
       getBroadcastVideos()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationBarColorChange()
    }
    
    @objc func addTapped() {
        BaseClass.shared().selectedImages = []
        //        let goToGalleryView = UIStoryboard.galleryView()
        let goToGalleryView = UIStoryboard.fbProfileDetails()
        //   goToGalleryView.grabImages()
        navigationController?.pushViewController(goToGalleryView, animated: true)
    }
    
    @objc  func backTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getBroadcastVideos() {
        APIHelper.shared().apiForBodyStringAndBlock(URL: "\(Constants.URL_TO_UPLOAD)", APIName: Constants.API_NAME_GET_BROADCAST_VIDEOS, MethodType: Constants.GET, ContentType: Constants.CONTENT_TYPE_JSON, BodyString: "",isLoading: true, controller: self, successblock:
            { (result) in
                if result != nil
                {
                    let status = String.giveMeProperString(str: result?[Constants.KEY_STATUS]!)
                    if(status == Constants.VALUE_STATUS_OK) {
                        let temp = result?["Broadcasts"] as! Array<Dictionary<String,Any>>
                        self.broadCastModelArr = BroadcastsModel.parseMultipleBroadcastsModels(array: temp)
                       // self.broadCastModelArr = self.broadCastModelArr?.filter({($0.url?.count != 0)})
                       // self.broadCastModelArr = self.broadCastModelArr?.sorted{ ($0.created_at)! > ($1.created_at)! }
                        //  print(result as Any)
                        
                        DispatchQueue.main.async(execute:{
                            self.collectionView.reloadData()
                        })
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
    
    fileprivate func showEmptyMessage(count : Int){
        lblMessage?.text = ""
        if count == 0{
            lblMessage?.text = Constants.MSG_NO_RESULTS
        }
    }
    
    func getThumbnailImage(videoUrl : String) -> UIImage {
        if videoUrl.count != 0 {
            do {
                let asset = AVURLAsset(url: URL(string:videoUrl)! , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let timestamp = CMTime(seconds: 10, preferredTimescale: 60)
                let cgImage = try imgGenerator.copyCGImage(at: timestamp, actualTime: nil)
               // let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                return UIImage()
            }
        }
        return UIImage()
    }
    
    @objc func playVideo(sender : UIButton) {
        
        broadCastModelObj = self.broadCastModelArr?[sender.tag]
        
        if let videoURL = URL(string:(broadCastModelObj?.url)!) {
            let player = AVPlayer(url: videoURL as URL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}

extension AllInstaStreamsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arr = self.broadCastModelArr else{
            return 0
        }
        showEmptyMessage(count: arr.count)
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(25,25,25,25)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! AllInstaStreamsCollectionViewCell
        broadCastModelObj = self.broadCastModelArr?[indexPath.row]
        cell.imageView.imageURL = URL(string:(broadCastModelObj?.thumbUrl)!)
            //self.getThumbnailImage(videoUrl: (broadCastModelObj?.url)!)
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        cell.imageView.alpha = 0.9
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 15
        
        return cell
    }

}
