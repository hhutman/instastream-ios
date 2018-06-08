//
//  DemoScreenOneViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 08/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit

class DemoScreenOneViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
       // imageView = UIImageView(image:UIImage.gifImageWithName("funny"))
        imageView.image = UIImage.gifImageWithName("1")
//        let jeremyGif = UIImage.gifImageWithName("1")
//        let imgVi = UIImageView(image: jeremyGif)
//        imgVi.frame = imageView.frame
//      //  imgVi.constraints = imageView.constraints
//            //CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
//        view.addSubview(imgVi)
        
        
       // let animatedImage = UIImage.gif(name: "FILE_NAME")
     //   let imageView = UIImageView(...)
        //imageView.animationImages = animatedImage?.images
      //  imageView.animationDuration = (animatedImage?.duration)! / 2
        imageView.animationImages = imageView.image?.images
        imageView.animationDuration = (imageView.image?.duration)! / 3
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
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
}
