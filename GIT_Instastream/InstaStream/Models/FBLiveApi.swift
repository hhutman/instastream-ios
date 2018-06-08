//
//  FBLiveApi.swift
//  InstaStream
//
//  Created by Orbysol on 4/2/18.
//  Copyright © 2018 Orbysol. All rights reserved.
//

import Foundation

import Foundation

enum FBLivePrivacy: StringLiteralType {
    case closed = "SELF"
    case everyone = "EVERYONE"
    case allFriends = "ALL_FRIENDS"
    case friendsOfFriends = "FRIENDS_OF_FRIENDS"
    //    case custom = "CUSTOM"
}

class FBLiveAPI {
    typealias CallbackBlock = ((Any) -> Void)
    var liveVideoId: String?
    
    static let shared = FBLiveAPI()
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func startLive(privacy: FBLivePrivacy, callback: @escaping CallbackBlock) {
        DispatchQueue.main.async {
            //FBSDKAccessToken.setCurrent(FBSDKAccessToken!)
            if FBSDKAccessToken.current().hasGranted("publish_actions") {
                let path = "/me/live_videos"
              //  let path = "/295356941001509/live_videos"
//                let params = [
//                    "privacy": "{\"value\":\"\(privacy.rawValue)\"}","access_token" : self.appDelegate.accessTokenFBPage!
//                ]
                let params = [
                    "privacy": "{\"value\":\"\(privacy.rawValue)\"}"]
                
                var request : FBSDKGraphRequest
                if let token = self.appDelegate.accessTokenFBPage {
                    request = FBSDKGraphRequest(
                        graphPath: path,
                        parameters: params,
                        tokenString: token,
                        version : "v3.0",
                        httpMethod: "POST"
                    )
                }else{
                    request = FBSDKGraphRequest(
                        graphPath: path,
                        parameters: params,
                        httpMethod: "POST"
                    )
                }
//                let request = FBSDKGraphRequest(
//                    graphPath: path,
//                    parameters: params,
//                    tokenString: self.appDelegate.accessTokenFBPage!,
//                    version : "v3.0",
//                    httpMethod: "POST"
//                )
                
               // let requestPage : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(1234)/feed", parameters: ["message" : "Hello Page!"], accessToken: FBSDKAccessToken.current(), httpMethod: .POST, apiVersion: .defaultVersion)

                _ = request.start { (_, result, error) in
                    if error == nil {
                        self.liveVideoId = (result as? NSDictionary)?.value(forKey: "id") as? String
                        print(result as Any)
                        callback(result as Any)
                    }else{
                        print(error?.localizedDescription as Any)
                        callback(error as Any)
                    }
                }
            }
        }
    }
    
    func endLive(callback: @escaping CallbackBlock) {
        DispatchQueue.main.async {
            if FBSDKAccessToken.current().hasGranted("publish_actions") {
                guard let id = self.liveVideoId else { return }
                let path = "/\(id)"

                let request = FBSDKGraphRequest(
                    graphPath: path,
                    parameters: ["end_live_video": true],
                    httpMethod: "POST"
                )
                
                _ = request?.start { (_, result, error) in
                    if error == nil {
                        callback(result)
                    }
                }
            }
        }
    }
}
