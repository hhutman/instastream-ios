//
//  ViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 20/04/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextTapped : UIButton?
    @IBOutlet weak var demoFlowBtn : UIButton?

    var isFrom : UIViewController!
    var imageArray = [UIImage]()
    let imageManager = PHImageManager.default()
    let requestOptions  = PHImageRequestOptions()
    var displayImagesArray = [UIImage]()
    var profileImgUrl : String?
    var imageResultArray = [PHAsset]()
    var displayAssetImagesArray = [PHAsset]()
    var  reloadTableView: LongPressReorderTableView!
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = false
        let back = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(GalleryViewController.backTapped))
        self.navigationItem.leftBarButtonItem = back
        addCustomTitleForNavigationBar(titleStr: "Choose Images")
        displayPersonImageOnBarButton()
        grabImages()
        requestForPhotos()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat//.highQualityFormat
        reloadTableView = LongPressReorderTableView(tableView)
        reloadTableView.delegate = self
        reloadTableView.enableLongPressReorder()
        appDelegate.demoFromGallery = false
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
//        grabImages()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let push = UIStoryboard.logOut()
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func requestForPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Foundjkhfkhfhf \(allPhotos.count) assets")
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBarColorChange()
    }
    
    @objc func backTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func demoFlowTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Suggestions", message: "1. Tap to add \n 2. Swipe to remove \n 3. Hold to rearrange the timeline ", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
//        appDelegate.demoFromGallery = true
//        let demo1View = UIStoryboard.DemoOneView()
//        self.navigationController?.pushViewController(demo1View, animated: true)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
          //isEmptyImages()
        if displayAssetImagesArray.count == 0 {
            nextTapped?.isEnabled = true
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 0.2)
        }
        else {
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#FF0076", withAlpha: 1.0)
            BaseClass.sharedInstance.selectedImages.removeAll()
            self.loadImages()
        }
}

    func loadImages() {
        let assetObj = self.displayAssetImagesArray[BaseClass.sharedInstance.selectedImages.count]
        imageManager.requestImage(for: assetObj, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:  {
            image, error in
            BaseClass.sharedInstance.selectedImages.append(image!)
            
            if BaseClass.sharedInstance.selectedImages.count == self.displayAssetImagesArray.count {
                let fbPageView = UIStoryboard.fbPagesView()
                self.navigationController?.pushViewController(fbPageView, animated: true)
            }
            else {
                self.loadImages()
            }
        })
    }
    
    func isEmptyImages() {
        if displayAssetImagesArray.count == 0 {
            nextTapped?.isEnabled = true
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 0.2)
        }
        else {
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#FF0076", withAlpha: 1.0)
            BaseClass.shared().selectedImages = []
            self.filterImages()
            if BaseClass.shared().selectedImages.count > 0 {
                let fbPageView = UIStoryboard.fbPagesView()
                self.navigationController?.pushViewController(fbPageView, animated: true)
            }
        }
    }

    func filterImages() {
        print(displayAssetImagesArray)
        for assetObj in self.displayAssetImagesArray {
            imageManager.requestImage(for: assetObj, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:  {
                image, error in
               // if !BaseClass.shared().selectedImages.contains(image!) {
                    BaseClass.sharedInstance.selectedImages.append(image!)
              //  }
            })
        }
    }
    
    func grabImages() {
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .highQualityFormat
        
        Spinner.show(controller: self)

        let fetchoptions = PHFetchOptions()
        fetchoptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with : .image, options: fetchoptions) {
            if fetchResult.count > 0 {
                 for i in 0..<fetchResult.count {
                    self.imageResultArray.append(fetchResult.object(at: i) as! PHAsset) //= fetchResult as! [PHFetchResult]

                }
                
//                for i in 0..<fetchResult.count {
//                    imageManager.requestImage(for: fetchResult.object(at: i) as! PHAsset , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:  {
//                        image, error in
//                        self.imageArray.append(image!)
//                    })
//                }
                    self.collectionView.reloadData()
            }
            else {
                print("You got no photos!")
            }
        }
    }
    
    @objc  func deletePhoto(_ gesture:UIGestureRecognizer) {
        let view = gesture.view as! UIImageView
        
        UIView.animate(withDuration: 0.5, animations: {
            view.frame = CGRect(x:100,y:0,width:50,height:50)
            view.alpha = 0.3
        }) { _ in
            view.alpha = 1.0
            self.displayAssetImagesArray.remove(at: (view.tag))
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
        
//        self.displayAssetImagesArray.remove(at: (view.tag))
//        self.tableView.reloadData()
//        self.collectionView.reloadData()
        
        switch gesture.state {
        case .began : print("Delete began")
            break
        case .changed:print("Delete changed")
            break
        case .ended:print("Delete ended")
            break
        default:break
        }
    }
}
    
extension GalleryViewController : UICollectionViewDelegate,UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            Spinner.hide(controller: self)
            return self.imageResultArray.count
            //return imageArray.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! GalleryViewControllerCell
        cell.galleryImageView = cell.viewWithTag(1) as! UIImageView
       // cell.galleryImageView.image = imageArray[indexPath.row]
        

        imageManager.requestImage(for: self.imageResultArray[indexPath.row], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:  {
            image, error in
            DispatchQueue.main.async {
                cell.galleryImageView.image = image
            }
        })
        cell.galleryImageView.alpha = 1
        cell.checkMarkView.isHidden = true
        if self.displayAssetImagesArray.contains(imageResultArray[indexPath.row]) == true {
            cell.checkMarkView.isHidden = false
            cell.checkMarkView.image = UIImage(named:"CheckBoxActive")
            cell.galleryImageView.alpha = 0.6
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = GalleryViewControllerCell()
        cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! GalleryViewControllerCell
        
        if self.displayAssetImagesArray.contains(imageResultArray[indexPath.row]) == true {
            let index = self.displayAssetImagesArray.index(of: imageResultArray[indexPath.row])
            cell = collectionView.cellForItem(at: indexPath) as! GalleryViewControllerCell
            self.displayAssetImagesArray.remove(at: index!)
            cell.checkMarkView.isHidden = true
            cell.galleryImageView.alpha = 1
        }
        else {
            cell = collectionView.cellForItem(at: indexPath) as! GalleryViewControllerCell
            cell.checkMarkView.isHidden = false
            self.displayAssetImagesArray.append(imageResultArray[indexPath.row])
            cell.checkMarkView.image = UIImage(named:"CheckBoxActive")
            cell.galleryImageView.alpha = 0.6
        }
        //  collectionView.reloadItems(at: [indexPath])
        self.tableView.reloadData()
    }
}

extension GalleryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  displayAssetImagesArray.count == 0 {
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#F04781", withAlpha: 0.2)
        }
        else {
            nextTapped?.backgroundColor = UIColor.colorFromHexString(hexString: "#FF0076", withAlpha: 1.0)
        }
        print(self.displayAssetImagesArray)
        return displayAssetImagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableView", for: indexPath) as! SelectedImagesTableViewCell
        cell.selectedImageView.frame = CGRect(x:7,y:10,width:50,height:50)
        imageManager.requestImage(for: self.displayAssetImagesArray[indexPath.row], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:  {
            image, error in
            DispatchQueue.main.async {
               cell.selectedImageView.image = image
            }
        })
        
       // cell.selectedImageView.image = displayAssetImagesArray[indexPath.row] as UIImage
        cell.selectedImageView.layer.masksToBounds = true
        cell.selectedImageView.clipsToBounds = true
        cell.selectedImageView.layer.cornerRadius = cell.selectedImageView.frame.height/2
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.deletePhoto(_:)))
        swipeGesture.direction = .right
        cell.selectedImageView.addGestureRecognizer(swipeGesture)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.deletePhoto1(_:)))
//        cell.selectedImageView.addGestureRecognizer(panGesture)
        
        cell.selectedImageView.isUserInteractionEnabled = true
        cell.selectedImageView.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
}

extension GalleryViewController {
    
    override func startReorderingRow(atIndex indexPath: IndexPath) -> Bool {
        if indexPath.row >= 0 {
            return true
        }
        return false
    }
    
    override func allowChangingRow(atIndex indexPath: IndexPath) -> Bool {
        if indexPath.row >= 0 {
            return true
        }
        
        return false
    }
    
    override func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath)
    {
        //swap(&self.displayAssetImagesArray[initialIndex.row], &self.displayAssetImagesArray[finalIndex.row])
        self.displayAssetImagesArray.swapAt(initialIndex.row, finalIndex.row)
        self.tableView.reloadData()
    }
}
    


