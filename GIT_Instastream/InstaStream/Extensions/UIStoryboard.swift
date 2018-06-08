//
//  UIStoryboard.swift
//  InstaStream
//
//  Created by Rapid Dev on 30/04/18.
//  Copyright © 2018 Rapid Dev. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum Storyboard : String {
        case main
        var filename : String{
            return rawValue.capitalized
        }
    }
    
    enum Identifier : String {
        case SplashScreenViewController = "SplashScreenViewController"
        case GalleryViewController = "GalleryViewController"
        case ConnectWithFacebookViewController = "ConnectWithFacebookViewController"
        case FbProfileDetailsViewController = "FbProfileDetailsViewController"
        case ChoosePagesForFbLiveViewController = "ChoosePagesForFbLiveViewController"
        case LiveVideoViewController = "LiveVideoViewController"
        case AlertViewController = "AlertViewController"
        case broadCastViewController = "BroadCastViewController"
        case BroadCastlistViewController = "BroadCastlistViewController"
        case AllInstaStreamsViewController = "AllInstaStreamsViewController"
        case FacebookLiveViewController = "FacebookLiveViewController"
        case LiveFacebookViewController = "LiveFacebookViewController"
        case LogOutViewController = "LogOutViewController"
        case DemoScreenOneViewController = "DemoScreenOneViewController"
        case LiveStreamTimerViewController = "LiveStreamTimerViewController"
    }
    
    class func splashScreen() -> SplashScreenViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.SplashScreenViewController.rawValue) as! SplashScreenViewController
    }
    
    class func allInstaStreams() -> AllInstaStreamsViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.AllInstaStreamsViewController.rawValue) as! AllInstaStreamsViewController
    }
    
    class func DemoOneView() -> DemoScreenOneViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.DemoScreenOneViewController.rawValue) as! DemoScreenOneViewController
    }
    
    class func broadCastlistScreen() -> BroadCastlistViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.BroadCastlistViewController.rawValue) as! BroadCastlistViewController
    }
    
    class func broadScreen() -> BroadCastViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.broadCastViewController.rawValue) as! BroadCastViewController
    }
    
    class func alertView() -> AlertViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.AlertViewController.rawValue) as! AlertViewController
    }
    
    class func liveStreamTimer() -> LiveStreamTimerViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.LiveStreamTimerViewController.rawValue) as! LiveStreamTimerViewController
    }
    
    //lflivekit
    class func liveVideoView() -> LiveVideoViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.LiveVideoViewController.rawValue) as! LiveVideoViewController
    }
//    //sample videocore
//    class func fbLiveView() -> FacebookLiveViewController {
//        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.LiveVideoViewController.rawValue) as! FacebookLiveViewController
//    }
//    //videocore
//    class func liveFBView() -> LiveFacebookViewController {
//        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.LiveFacebookViewController.rawValue) as! LiveFacebookViewController
//    }
    
    class func fbPagesView() -> ChoosePagesForFbLiveViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.ChoosePagesForFbLiveViewController.rawValue) as! ChoosePagesForFbLiveViewController
    }
    
    class func galleryView() -> GalleryViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.GalleryViewController.rawValue) as! GalleryViewController
    }
    
    class func logOut() -> LogOutViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.LogOutViewController.rawValue) as! LogOutViewController
    }
    
    class func connectWthFb() -> ConnectWithFacebookViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.ConnectWithFacebookViewController.rawValue) as! ConnectWithFacebookViewController
    }
    
    class func fbProfileDetails() -> FbProfileDetailsViewController {
        return UIStoryboard(name: Storyboard.main.filename, bundle: nil).instantiateViewController(withIdentifier: Identifier.FbProfileDetailsViewController.rawValue) as! FbProfileDetailsViewController
    }
}
