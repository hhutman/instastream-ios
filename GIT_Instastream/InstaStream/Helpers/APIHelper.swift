//
//  APIHelper.swift
//  Vaco
//
//  Created by Param on 26/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import UIKit
//import Alamofire
//import Toast_Swift
//import SwiftMessages

class APIHelper: NSObject {
    static var sharedInstance : APIHelper!
    
    class func shared() -> APIHelper {
        if sharedInstance == nil {
            sharedInstance = APIHelper()
        }
        return sharedInstance
    }
    
    func apiForBodyStringAndBlock(URL aUrl : String, APIName apiName : String, MethodType methodType : String, ContentType contentType : String, BodyString bodyString : String, isLoading : Bool?, controller : UIViewController?, successblock : ((AnyObject?) -> Void)?, failureblock : ((NSError?) -> Void)?)
    {
        print(aUrl)
        let URLStr : NSURL = NSURL(string: "\(Constants.APP_URL)\(aUrl)")!

        return callServiceWithBlock(successblock: successblock, failureblock: failureblock, APIName: apiName, MethodType: methodType, URL: URLStr as URL, Bodydata: nil, BodyString: bodyString, ContentType: contentType, isLoading: isLoading, controller: controller)
    }
    
    //api for all services contains body data
    func apiForBodyDataAndBlock(URL aUrl : String, APIName apiName : String, MethodType methodType : String, ContentType contentType : String, BodyData bodyData : Dictionary<String,Any?>,isLoading : Bool?, controller : UIViewController?, successblock :  ((AnyObject?) -> Void)?, failureblock :  ((NSError?) -> Void)?)
    {
        let URLStr : NSURL = NSURL(string: "\(Constants.APP_URL)\(aUrl)")!
        var reqData: NSData?
        do {
            reqData = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted) as NSData?
        } catch {
            
        }
        return callServiceWithBlock(successblock: successblock!, failureblock: failureblock!, APIName: apiName, MethodType: methodType, URL: URLStr as URL, Bodydata: reqData, BodyString: nil, ContentType: contentType, isLoading: isLoading, controller: controller)
    }
    
    //Service method by Radha
    func callServiceWithBlock(successblock: ((AnyObject?) -> Void)?, failureblock: ((NSError?) -> Void)?, APIName api: String?, MethodType methodType: String?, URL aUrl:URL, Bodydata bodyData: NSData?, BodyString bodyStr:String? ,ContentType contentType: String?, isLoading : Bool?, controller : UIViewController?) -> Void
    {
        do
        {
            Spinner.hide(controller: controller!)
            if isLoading! {
                Spinner.show(controller: controller!)
            }
            let request:NSMutableURLRequest =  NSMutableURLRequest(url: aUrl as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Constants.TIME_OUT)
            if let methodType = methodType  {
                request.httpMethod = methodType
            } else {
                request.httpMethod = Constants.POST
            }
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            if let bodyData = bodyData  {
                request.httpBody = bodyData as Data
            }
            else if let bodyStr = bodyStr
            {
                let bodyStr = bodyStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                request.httpBody = bodyStr!.data(using: String.Encoding.utf8)
                print("BODY STRING IS : \n \(bodyStr!)")
            }
            print("WEB SERVICE URL is :\n \(aUrl)")
            //Set user token to headers
            if BaseClass.shared().userToken != nil
            {
                let headers = [
                    "Authorization" : BaseClass.shared().userToken!
                ]
                request.allHTTPHeaderFields = headers
            }
            let config = URLSessionConfiguration.default // Session Configuration
            config.timeoutIntervalForRequest = Constants.TIME_OUT
            config.timeoutIntervalForResource = Constants.TIME_OUT
            let session = URLSession(configuration: config)
            // Load configuration into Session
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, connectionError) in
                DispatchQueue.main.async(execute: {
                    Spinner.hide(controller: controller!)
                })
                //Got Response
                if connectionError == nil && response != nil, let responceData = data {
                    var responseobj:Any?
                    do{
                        responseobj = try  JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                    }
                    catch _ {
                        print("Error while parsing the API so returning")
                        if let failureBlk = failureblock {
                            failureBlk(NSError(domain:"JSON Error" ,code : 1000 , userInfo: nil))
                        }
                        return
                    }
                    if  responseobj == nil{
                        responseobj = data as AnyObject?
                    }
                    print("API(\(aUrl)) Response is \(responseobj!)")
                    if let successBlk = successblock {
                        successBlk(responseobj as! NSDictionary)
                    }
                }
                else{
                    //Error
                    if connectionError != nil{
                        Messages.shared().showErrorMessage(message: (connectionError?.localizedDescription)!)
                        print("Service Error and Error info is : \(connectionError!.localizedDescription) \n")
                    }
                    if let failureBlk = failureblock {
                        failureBlk(connectionError as NSError?)
                    }
                }
            })
            dataTask.resume()
        }
        catch _ {
            DispatchQueue.main.async(execute: {
                Spinner.hide(controller: controller!)
            })
            if let failureBlk = failureblock {
                failureBlk(NSError(domain:"Error" ,code : 1000 , userInfo: nil))
            }
        }
    }
    
    //Upload image
    
    func uploadImageWithBlock(bodyDict : Dictionary<String,Any?>, imagesArray : [UIImage]?, videoUrl : URL, url : String?,filename : String?,isLoading : Bool?, controller : UIViewController?, block: @escaping (AnyObject?, NSError?) -> Void)
    {
        do{
            Spinner.hide(controller: controller!)
            if isLoading! {
                Spinner.show(controller: controller!)
            }
            let aURL : NSURL = NSURL(string: url!)!
            let request = NSMutableURLRequest(url: aURL as URL)
            request.httpMethod = Constants.POST
            //Set user token to headers
            if BaseClass.shared().userToken != nil
            {
                let headers = [
                    "Authorization" : BaseClass.shared().userToken!
                ]
                request.allHTTPHeaderFields = headers
            }
            let boundary = generateBoundaryString()
            let contentType = "multipart/form-data; boundary=\(boundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-type")
            let body = NSMutableData()
            let mimetype = "video/mov"
            let parameters = ["title": bodyDict["title"] as! String,"tags_list":bodyDict["tags_list"] as! [String]] as [String : Any]

            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
                let reqName = "\(BaseClass.shared().userName!)\(BaseClass.shared().getCurrentTime()).mov"
                let filename = reqName
            print("PRASHANTH APICALL")
                print(filename)
            //"upload.mov"

                //add video to body data
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"video\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                var movieData: NSData?
                do {
                    movieData = try NSData(contentsOfFile: (videoUrl.relativePath), options: NSData.ReadingOptions.alwaysMapped)
                } catch _ {
                    movieData = nil
                    return
                }
                body.append(movieData! as Data)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            print("WEB SERVICE URL is :\n \(aURL)")
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = Constants.TIME_OUT
            config.timeoutIntervalForResource = Constants.TIME_OUT
            let session = URLSession(configuration: config)
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, connectionError) in
                if connectionError == nil && response != nil, let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200, let responceData = data {
                    var responseobj:Any?
                    do{
                        responseobj = try  JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
                    }
                    catch _ {
                        print("Error while parsing the API so returning")
                        block(nil,NSError(domain:"JSON Error" ,code : 1000 , userInfo: nil))
                        return
                    }
                    if  responseobj == nil{
                        responseobj = data as AnyObject?
                    }
                    block(responseobj as! NSDictionary,nil)
                }
                else{
                    //Error
                    if connectionError != nil {
                        //print("Service Error and Error info is : \(connectionError!.localizedDescription) \n")
                        Messages.shared().showErrorMessage(message: (connectionError?.localizedDescription)!)
                        block(nil,connectionError as NSError?)
                    }else{
                        block(nil,connectionError as NSError?)
                    }

//                    print("Service Error and Error info is : \(connectionError!.localizedDescription) \n")
//                    block(nil,connectionError as NSError?)
                }
            })
            dataTask.resume()
        }
        catch _ {
            DispatchQueue.main.async(execute: {
                Spinner.hide(controller: controller!)
            })
            block(nil, NSError(domain:"Error" ,code : 1000 , userInfo: nil))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func uploadImageWithBlock(imgData : NSData, url : String?,filename : String?,isLoading : Bool?, controller : UIViewController?, block: @escaping (AnyObject?, NSError?) -> Void)
//    {
//        do{
//            Spinner.hide(controller: controller!)
//            if isLoading! {
//                Spinner.show(controller: controller!)
//            }
//            let aURL : NSURL = NSURL(string: url!)!
//            let request = NSMutableURLRequest(url: aURL as URL)
//            request.httpMethod = Constants.POST
//            //Set user token to headers
//            if BaseClass.shared().userToken != nil
//            {
//                let headers = [
//                    "Authorization" : BaseClass.shared().userToken!
//                ]
//                request.allHTTPHeaderFields = headers
//            }
//            let boundary = generateBoundaryString()
//            let contentType = "multipart/form-data; boundary=\(boundary)"
//            request.setValue(contentType, forHTTPHeaderField: "Content-type")
//            let body = NSMutableData()
//            let fname = filename
//            let mimetype = "image/png" //application/octet-stream
//            //define the data post parameter
//            //add user id to body data
//            let parameters = ["user_id" : BaseClass.shared().userId!]
//            for (key, value) in parameters {
//                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
//            }
//            //add image to body data
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname!)\"\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
//            //Thumb Image
//            let img = UIImage(data: imgData as Data)
//            let length = imgData.length
//            print("Image Length is \(length/1024) KB")
//            if (length)/1024 > 10 //If image more than a KB
//            {
//               // let thumbImg = img?.resized(withPercentage: 0.8)
//                // let thumbImg = img?.sclaeImageToSize(scaledToSize: CGSize(width:UIScreen.main.bounds.size.width*2,height:UIScreen.main.bounds.size.height*2), andOffSet: CGPoint(x: 0, y: 0))
//               // body.append(UIImagePNGRepresentation(thumbImg!)! as Data)
//            }
//            else{
//                body.append(imgData as Data)
//            }
//            body.append("\r\n".data(using: String.Encoding.utf8)!)
//            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//            request.httpBody = body as Data
//            print("WEB SERVICE URL is :\n \(aURL)")
//            let config = URLSessionConfiguration.default
//            config.timeoutIntervalForRequest = Constants.TIME_OUT
//            config.timeoutIntervalForResource = Constants.TIME_OUT
//            let session = URLSession(configuration: config)
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, connectionError) in
//                if connectionError == nil && response != nil, let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200, let responceData = data {
//                    var responseobj:Any?
//                    do{
//                        responseobj = try  JSONSerialization.jsonObject(with: responceData, options: JSONSerialization.ReadingOptions.allowFragments)
//                    }
//                    catch _ {
//                        print("Error while parsing the API so returning")
//                        block(nil,NSError(domain:"JSON Error" ,code : 1000 , userInfo: nil))
//                        return
//                    }
//                    if  responseobj == nil{
//                        responseobj = data as AnyObject?
//                    }
//                    block(responseobj as! NSDictionary,nil)
//                }
//                else{
//                    //Error
//                    print("Service Error and Error info is : \(connectionError!.localizedDescription) \n")
//                    block(nil,connectionError as NSError?)
//                }
//            })
//            dataTask.resume()
//        }
//        catch _ {
//            DispatchQueue.main.async(execute: {
//                Spinner.hide(controller: controller!)
//            })
//            block(nil, NSError(domain:"Error" ,code : 1000 , userInfo: nil))
//        }
//    }
    
    func generateBoundaryString() -> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
}


