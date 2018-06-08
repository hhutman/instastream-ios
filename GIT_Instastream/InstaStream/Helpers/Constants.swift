//
//  Constants.swift
//  InstaStream
//
//  Created by prasanth inavolu on 03/05/18.
//  Copyright © 2018 prasanth inavolu. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let APP_STORE_URL = "www.apple.com"
    static let APP_URL = "http://54.175.48.253/"
    //"http://mycounty.io/"
    //"http://a4475784.ngrok.io/"
    //Storyboard Name
    static let STORYBOARD_MAIN = "Main"
    //Color
    static let COLOR_NAV = UIColor.colorFromHexString(hexString: "#FF1C7C", withAlpha: 1.0)
    
    //Service related
    static let TOAST_DURATION = 2.0
    static let TIME_OUT = 60.0
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
    
    static let CONTENT_TYPE_JSON = "application/json"
    static let CONTENT_TYPE_ENCODING = "application/x-www-form-urlencoded"
    
    //Font
    static let FONT_REGULAR = "Arial-Bold"
    
    //json keys
    static let KEY_MESSAGE = "message"
    static let KEY_ERROR = "error"
    static let KEY_STATUS = "status"
    static let KEY_PASSWORD = "password"
    
    //json values
    static let VALUE_STATUS_OK = "ok"
    
    //URLs
    //users
    static let URL_VALIDATE_EMAIL = "api/v1/users/validate_email"
    static let URL_SIGN_UP = "api/v1/users"
    static let URL_SIGN_IN = "api/v2/users/sign_in"
    static let URL_FB_SIGN_IN = "api/v1/facebook/login"
    
    //VIDEO upload
    static let URL_TO_UPLOAD = "api/v1/broadcasts"
    
    // user uploaded videos
    static let URL_TO_GET_USER_VIDEOS = "api/v1/broadcasts/user_broadcasts"
   // static let URL_TO_UPLOAD = "api/v1/broadcasts"

    //API Names
    static let API_NAME_VALIDATE_EMAIL = "Validate Email"
    static let API_NAME_SIGN_IN = "Sign In"
    static let API_NAME_SIGN_UP = "Sign Up"
    static let API_NAME_FB_SIGN_IN = "FB Sign In"
    static let API_NAME_GET_BROADCAST_VIDEOS = "Broadcast Videos"

    static let MSG_NO_INTERNET = "Check your internet connection"
    static let MSG_NO_DETAILS = "No details are available"
    static let MSG_EMPTY = "Fields can not be empty"
    static let TEXTFIELD_EMPTY = "tourname can not be empty"
    static let MSG_ERROR = "Something went wrong please try again later"
    static let MSG_PASSWORD = "Password is too short. Needs to have 8 characters"
    static let MSG_EMAIL = "Please enter a valid email"
    static let MSG_UPLOAD_PROFILE_DETAILS = "Profile updated successfully"
    static let MSG_TWITTER_VALID_URL = "Please enter a valid twitter url"
    static let MSG_LINKEDIN_VALID_URL = "Please enter a valid linkedin url"
    static let MSG_URL_ERROR = "url is not valid"
    static let MSG_NO_RESULTS = "No results found"

}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD_AIR = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_LANDSCAPE = UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
    static let IS_PORTRAIT = UIDevice.current.orientation == UIDeviceOrientation.portrait
}
