//
//  DemoScreenThreeViewController.swift
//  InstaStream
//
//  Created by prasanth inavolu on 08/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import UIKit

class DemoScreenThreeViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.gifImageWithName("3")
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
    
}
