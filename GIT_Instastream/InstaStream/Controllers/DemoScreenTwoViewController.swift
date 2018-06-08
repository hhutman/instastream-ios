//
//  DemoScreenTwoViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 08/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit

class DemoScreenTwoViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.gifImageWithName("2")
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
    
}
