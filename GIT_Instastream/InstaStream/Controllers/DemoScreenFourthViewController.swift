//
//  DemoScreenFourthViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 07/06/18.
//  Copyright © 2018 Rapid. All rights reserved.
//

import UIKit

class DemoScreenFourthViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView : UIImageView!
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.gifImageWithName("4")
        imageView.animationImages = imageView.image?.images
        imageView.animationDuration = (imageView.image?.duration)!
        imageView.startAnimating()
        nextButton.layer.cornerRadius = 5
        navigationBarTransparent()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if imageView != nil {
            imageView.stopAnimating()
            imageView.removeFromSuperview()
            imageView = nil
        }
    }
    
    @IBAction func nextTapped(_sender : Any) {
        if appDelegate.demoFromGallery {
            guard let viewcontrollers = self.navigationController?.viewControllers else{return}
            for controller in viewcontrollers {
                if  let galleryVC = controller as? GalleryViewController {
                    appDelegate.demoFromGallery = false
                    self.navigationController!.popToViewController(galleryVC, animated: true)
                }
            }
        }else{
            let connectFBView = UIStoryboard.connectWthFb()
            self.navigationController?.pushViewController(connectFBView, animated: true)
        }
    }
}
