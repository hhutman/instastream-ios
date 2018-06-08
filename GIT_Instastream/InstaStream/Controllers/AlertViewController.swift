//
//  AlertViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 05/05/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    var alertResult : ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 8
        alertView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTransparent()
    }

    @IBAction func yesButtonTapped(_ sender: Any) {
        self.alertResult!(true)
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.alertResult!(false)
    }
    

}
