//
//  LiveStreamTimerViewController.swift
//  InstaStream
//
//  Created by Rapid Dev on 08/06/18.
//  Copyright © 2018 Rapid. All rights reserved.
//

import UIKit

class LiveStreamTimerViewController: UIViewController {

    @IBOutlet weak var timerTime: UILabel!
   // @IBOutlet weak var liveStreamingStartLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    var startLiveTimer : Timer!
    var liveCount : Int = 5
    var timerResult : ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadLiveStartTimer()
    }

    func LoadLiveStartTimer() {
        timerView.layer.cornerRadius = 8
        // timerTime.layer.masksToBounds = true
        //  timerTime.layer.cornerRadius = timerTime.layer.frame.size.height/2
      //  self.timerTime.text = "Connecting ..."
        
        //        self.startLiveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
        //            if self.liveCount == 0 {
        //                self.startLiveTimer.invalidate()
        //                self.timerResult!(true)
        //             //   self.timerView.isHidden = true
        //            }else{
        //                self.timerTime.text = "\(self.liveCount)"
        //                self.liveCount = self.liveCount - 1
        //            }
        //        })
    }

}
