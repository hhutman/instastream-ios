//
//  UserModel.swift
//  Vaco
//
//  Created by Param on 04/08/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import Foundation

internal class UserModel {
    
    internal var createdDate: String?
    internal var designation: String?
    internal var deviceId: String?
    internal var email: String?
    internal var location: String?
    internal var name: String?
    internal var organization: String?
    internal var role: String?
    internal var token: String?
    internal var updatedDate: String?
    internal var userId: String?
    internal var summary: String?
    internal var linkedin: String?
    internal var twitter: String?
    internal var website: String?
    internal var avatarUrl: String?
    internal var sign_in_count: String?
    internal var company_name: String?
    internal var member_company: String?
    internal var logo_thumb_url: String?
    internal var avatar_thumb_url: String?
    internal var avatar_medium_url: String?
//    internal var home_page_logo_thumb_url : String?
//    internal var home_page_logo_url : String?

    //Set User Details for User object
    class func parseSingleUserObject(userDetails : Dictionary<String,Any>) -> UserModel{
        let userModel = UserModel()
        //Set user details
        userModel.userId = String.giveMeProperString(str: userDetails["id"])
        userModel.email = String.giveMeProperString(str: userDetails["email"])
        userModel.createdDate = String.giveMeProperString(str: userDetails["created_at"])
        userModel.updatedDate = String.giveMeProperString(str: userDetails["updated_at"])
        userModel.deviceId = String.giveMeProperString(str: userDetails["mobile_device_id"])
        userModel.token = String.giveMeProperString(str: userDetails["fcm_reg_id"])
        userModel.sign_in_count = String.giveMeProperString(str: userDetails["sign_in_count"])
        userModel.role = String.giveMeProperString(str: userDetails["role"])
        
        userModel.name = String.giveMeProperString(str: userDetails["name"])
        userModel.avatarUrl = String.giveMeProperString(str: userDetails["avatar_url"])
        userModel.designation = String.giveMeProperString(str: userDetails["position"])
        userModel.organization = String.giveMeProperString(str: userDetails["company"])
        userModel.location = String.giveMeProperString(str: userDetails["location"])
        userModel.summary = String.giveMeProperString(str: userDetails["summary"])
        userModel.twitter = String.giveMeProperString(str: userDetails["twitter"])
        userModel.linkedin = String.giveMeProperString(str: userDetails["linkedin"])
        userModel.website = String.giveMeProperString(str: userDetails["website"])
        userModel.company_name = String.giveMeProperString(str: userDetails["company_name"])
        userModel.member_company = String.giveMeProperString(str: userDetails["member_company"])
        userModel.logo_thumb_url = String.giveMeProperString(str: userDetails["logo_thumb_url"])
        userModel.avatar_thumb_url = String.giveMeProperString(str: userDetails["avatar_thumb_url"])
        userModel.avatar_medium_url = String.giveMeProperString(str: userDetails["avatar_medium_url"])
//       userModel.home_page_logo_url = String.giveMeProperString(str: userDetails["home_page_logo_url"])

        return userModel
    }
    
    class func parseMultipleUsers(array : Array<Dictionary<String, Any>>) -> [UserModel] {
        var finalUserArray = [UserModel]()
        for i in 0..<array.count {
            finalUserArray.append(parseSingleUserObject(userDetails: array[i]))
        }
        return finalUserArray
    }

}

internal class  MyTicketModule {
    internal var label : String?
    internal var date : String?
    internal var time : String?
    internal var venue : String?
    internal var sponsor_logo_url : String?
    internal var tag : String?
    internal var is_available : Bool?
    internal var order : String?
    
    class func parseSingleTicketObject(myTicketDetails : Dictionary<String,Any>) -> MyTicketModule  {
        let myTicketModule = MyTicketModule()
        
        // Set Details
        myTicketModule.label = String.giveMeProperString(str: myTicketDetails["label"])
        myTicketModule.date = String.giveMeProperString(str: myTicketDetails["date"])
        myTicketModule.time = String.giveMeProperString(str: myTicketDetails["time"])
        myTicketModule.venue = String.giveMeProperString(str: myTicketDetails["venue"])
        myTicketModule.tag = String.giveMeProperString(str: myTicketDetails["tag"])
        myTicketModule.sponsor_logo_url = String.giveMeProperString(str: myTicketDetails["sponsor_logo_url"])
        myTicketModule.is_available = myTicketDetails["is_available"] as? Bool
        myTicketModule.order = String.giveMeProperString(str: myTicketDetails["order"])
        return myTicketModule
    }
    
    class func parseMultiTicketobject(array : Array<Dictionary<String,Any>>) -> [MyTicketModule] {
        var finalTicketArray = [MyTicketModule]()
        for i in 0..<array.count {
            finalTicketArray.append(parseSingleTicketObject(myTicketDetails: array[i]))
        }
        return finalTicketArray
    }
}

internal class FBPagesModel {
    internal var accessToken : String?
    internal var category : String?
    internal var id : String?
    internal var name : String?
    internal var url : String?
   // internal var category : String?

    class func parseSingleFBPage(myFBPageDetails : Dictionary<String,Any>) -> FBPagesModel  {
        let myFBPageModel = FBPagesModel()
        // Set Details
        myFBPageModel.accessToken = String.giveMeProperString(str: myFBPageDetails["access_token"])
        myFBPageModel.category = String.giveMeProperString(str: myFBPageDetails["category"])
        myFBPageModel.id = String.giveMeProperString(str: myFBPageDetails["id"])
        myFBPageModel.name = String.giveMeProperString(str: myFBPageDetails["name"])
        let dict = myFBPageDetails["picture"] as! Dictionary<String,Any>
        if let pictureDict = dict["data"] as? Dictionary<String,Any> {
            myFBPageModel.url = String.giveMeProperString(str: pictureDict["url"])
        }

        return myFBPageModel
    }
    
    class func parseMultipleFBPages(array : Array<Dictionary<String,Any>>) -> [FBPagesModel] {
        var finalTicketArray = [FBPagesModel]()
        for i in 0..<array.count {
            finalTicketArray.append(parseSingleFBPage(myFBPageDetails: array[i]))
        }
        return finalTicketArray
    }
}

internal class FBCommentsModel {
    internal var created_time : String?
    internal var commentId : String?
    internal var name : String?
    internal var message : String?

    class func parseSingleFBComment(myFBPageDetails : Dictionary<String,Any>) -> FBCommentsModel  {
        let myFBCommentModel = FBCommentsModel()
        // Set Details
        myFBCommentModel.created_time = String.giveMeProperString(str: myFBPageDetails["created_time"])
        myFBCommentModel.commentId = String.giveMeProperString(str: myFBPageDetails["id"]) //commentId
        myFBCommentModel.name = String.giveMeProperString(str: myFBPageDetails["name"])
        myFBCommentModel.message = String.giveMeProperString(str: myFBPageDetails["message"])
        if let fromDict = myFBPageDetails["from"] as? Dictionary<String,Any> {
            myFBCommentModel.name = String.giveMeProperString(str: fromDict["name"])
        }
        return myFBCommentModel
    }
    
    class func parseMultipleFBComments(array : Array<Dictionary<String,Any>>) -> [FBCommentsModel] {
        var fbCommentsArray = [FBCommentsModel]()
        for i in 0..<array.count {
            fbCommentsArray.append(parseSingleFBComment(myFBPageDetails: array[i]))
        }
        return fbCommentsArray
    }
    
}

internal class BroadcastsModel {
    internal var file_name : String?
    internal var file_size : String?
    internal var id : String?
    internal var tags_list : String?
    internal var url : String?
    internal var created_at : String?
    internal var updated_at : String?
    internal var title : String?
    internal var content_type : String?
    internal var thumbUrl : String?

    class func parseSingleBroadcastsModel(myBroadcastsModelDetails : Dictionary<String,Any>) -> BroadcastsModel  {
        let myBroadcastsModel = BroadcastsModel()
        // Set Details
        myBroadcastsModel.content_type = String.giveMeProperString(str: myBroadcastsModelDetails["content_type"])
        myBroadcastsModel.title = String.giveMeProperString(str: myBroadcastsModelDetails["title"])
        myBroadcastsModel.updated_at = String.giveMeProperString(str: myBroadcastsModelDetails["updated_at"])
        myBroadcastsModel.created_at = String.giveMeProperString(str: myBroadcastsModelDetails["created_at"])
        myBroadcastsModel.tags_list = String.giveMeProperString(str: myBroadcastsModelDetails["tags_list"])
        myBroadcastsModel.file_size = String.giveMeProperString(str: myBroadcastsModelDetails["file_size"])
        myBroadcastsModel.id = String.giveMeProperString(str: myBroadcastsModelDetails["id"])
        myBroadcastsModel.file_name = String.giveMeProperString(str: myBroadcastsModelDetails["file_name"])
        myBroadcastsModel.thumbUrl = String.giveMeProperString(str: myBroadcastsModelDetails["thumbUrl"])
        myBroadcastsModel.url = String.giveMeProperString(str: myBroadcastsModelDetails["videoUrl"])
//        if let dict = myBroadcastsModelDetails["video"] as? Dictionary<String,Any> {
//       // let pictureDict = dict["data"] as! Dictionary<String,Any>
//            myBroadcastsModel.url = String.giveMeProperString(str: dict["url"])
//        }
        return myBroadcastsModel
    }
    
    class func parseMultipleBroadcastsModels(array : Array<Dictionary<String,Any>>) -> [BroadcastsModel] {
        var finalBroadcastsModel = [BroadcastsModel]()
        for i in 0..<array.count {
            finalBroadcastsModel.append(parseSingleBroadcastsModel(myBroadcastsModelDetails: array[i]))
        }
        return finalBroadcastsModel
    }
}

internal class SpeakerModel {
    internal var designation: String?
    internal var email: String?
    internal var location: String?
    internal var name: String?
    internal var role: String?
    internal var organization: String?
    internal var token: String?
    internal var userId: String?
    internal var avatarUrl: String?
    internal var sign_in_count: String?
    internal var about: String?
    internal var isGuest: Bool?
    internal var sortedString: String?
    
    internal var company_name: String?
    internal var created_at : String?
    internal var avatar_medium_url : String?
    internal var member_company : String?
    internal var linkedin : String?
    internal var phone : String?
    internal var position : String?
    internal var registration_type : String?
    internal var summary : String?
    internal var twitter : String?
    internal var address : String?
    internal var org_business_sector : Array<Dictionary<String, AnyObject>>?
    internal var type_of_org : Array<Dictionary<String, AnyObject>>?
    //internal var features: Array<Dictionary<String, AnyObject>>?
    //participantModel.features = participant["features"] as? Array<Dictionary<String, AnyObject>>



    //Set User Details for User object
    class func parseSingleSpeakerObject(speakerDetails : Dictionary<String,Any>) -> SpeakerModel{
        let speakerModel = SpeakerModel()
        //Set user details
        speakerModel.userId = String.giveMeProperString(str: speakerDetails["id"])
        speakerModel.email = String.giveMeProperString(str: speakerDetails["email"])
        speakerModel.sign_in_count = String.giveMeProperString(str: speakerDetails["sign_in_count"])
        speakerModel.role = String.giveMeProperString(str: speakerDetails["role"])
        speakerModel.name = String.giveMeProperString(str: speakerDetails["name"])
        speakerModel.about = String.giveMeProperString(str: speakerDetails["about"])
        speakerModel.avatarUrl = String.giveMeProperString(str: speakerDetails["avatar_url"])
        speakerModel.isGuest = true
        
        //for participants
        speakerModel.company_name = String.giveMeProperString(str: speakerDetails["company_name"])

        speakerModel.created_at = String.giveMeProperString(str: speakerDetails["created_at"])
        speakerModel.avatar_medium_url = String.giveMeProperString(str: speakerDetails["avatar_medium_url"])
        speakerModel.member_company = String.giveMeProperString(str: speakerDetails["member_company"])
        speakerModel.linkedin = String.giveMeProperString(str: speakerDetails["linkedin"])
        speakerModel.phone = String.giveMeProperString(str: speakerDetails["phone"])
        speakerModel.position = String.giveMeProperString(str: speakerDetails["position"])
        speakerModel.registration_type = String.giveMeProperString(str: speakerDetails["registration_type"])
        speakerModel.summary = String.giveMeProperString(str: speakerDetails["summary"])
        speakerModel.twitter = String.giveMeProperString(str: speakerDetails["twitter"])
        speakerModel.org_business_sector = speakerDetails["org_business_sector"] as? Array<Dictionary<String,AnyObject>>
        speakerModel.type_of_org = speakerDetails["type_of_org"] as? Array<Dictionary<String,AnyObject>>
        speakerModel.address = String.giveMeProperString(str: speakerDetails["address"])

        
        //Set Profile Details
        let speakerProfile = speakerDetails["profile"] as? Dictionary<String, Any>
        if(speakerProfile != nil){
            speakerModel.isGuest = false
            speakerModel.name = String.giveMeProperString(str: speakerProfile?["full_name"])
            speakerModel.designation = String.giveMeProperString(str: speakerProfile?["position"])
            speakerModel.organization = String.giveMeProperString(str: speakerProfile?["company"])
            speakerModel.location = String.giveMeProperString(str: speakerProfile?["location"])
            speakerModel.avatarUrl = String.giveMeProperString(str: speakerProfile?["avatar_url"])
        }
        speakerModel.sortedString = speakerModel.name
        if (speakerModel.sortedString?.isEmpty)! {
            speakerModel.sortedString = speakerModel.email
        }
        return speakerModel
    }
    
    class func parseMultipleSpeakers(array : Array<Dictionary<String, Any>>) -> [SpeakerModel] {
        var finalSpeakerArray = [SpeakerModel]()
        for i in 0..<array.count {
            finalSpeakerArray.append(parseSingleSpeakerObject(speakerDetails: array[i]))
        }
        return finalSpeakerArray
    }
}


internal class EventModel {
    internal var id: String?
    internal var average_rating: String?
    internal var created_at: String?
    internal var date: String?
    internal var description: String?
    internal var location: String?
    internal var time: String?
    internal var start_time: String?
    internal var end_time: String?
    internal var title: String?
    internal var updated_at: String?
    internal var user_rating: String?
    internal var time24: Int?
    internal var is_favorite: Bool?
    
    internal var event_images: Array<Dictionary<String, AnyObject>>?

    //Set User Details for User object
    class func parseSingleEvent(event : Dictionary<String,Any>) -> EventModel{
        let eventModel = EventModel()
        //Set event details
        eventModel.id = String.giveMeProperString(str: event["id"])
        eventModel.average_rating = String.giveMeProperString(str: event["average_rating"])
        eventModel.created_at = String.giveMeProperString(str: event["created_at"])
        eventModel.date = String.giveMeProperString(str: event["date"])
        eventModel.description = String.giveMeProperString(str: event["description"])
        eventModel.location = String.giveMeProperString(str: event["location"])
        eventModel.time = String.giveMeProperString(str: event["time"])
        eventModel.start_time = String.giveMeProperString(str: event["start_time"])
        eventModel.end_time = String.giveMeProperString(str: event["end_time"])
        eventModel.title = String.giveMeProperString(str: event["title"])
        eventModel.updated_at = String.giveMeProperString(str: event["updated_at"])
        eventModel.user_rating = String.giveMeProperString(str: event["user_rating"])
        eventModel.is_favorite = event["is_favorite"] as? Bool
        var timeStr = String.giveMeProperString(str: event["timin24"])
        if !timeStr.isEmpty {
            timeStr = timeStr.replacingOccurrences(of: ":", with: "")
            let timeNum = Int(timeStr)
            eventModel.time24 = timeNum
        }
        
        eventModel.event_images = event["event_images"] as? Array<Dictionary<String,AnyObject>>

        return eventModel
    }
    
    class func parseMultipleEvents(array : Array<Dictionary<String, Any>>) -> [EventModel] {
        var finalEventArray = [EventModel]()
        for i in 0..<array.count {
            finalEventArray.append(parseSingleEvent(event: array[i]))
        }
        return finalEventArray
    }
}

internal class CompanyModel {
    internal var id: String?
    internal var address: String?
    internal var contact_person_name: String?
    internal var created_at: String?
    internal var description: String?
    internal var is_sponsor: Bool?
    internal var logo_thumb_url: String?
    internal var logo_url: String?
    internal var logo_medium_url: String?
    internal var name: String?
    internal var phone: String?
    internal var website: String?
    //for directory flow
    internal var about: String?
    internal var contact: String?
    internal var manager_name: String?
    internal var manager_phone: String?
//    internal var business_sector : Array<String>?
//    internal var type_of_org : Array<String>?
    internal var business_sector = ""
    internal var type_of_org = ""

    
    class func parseSingleCompany(event : Dictionary<String,Any>) -> CompanyModel{
        let companyModel = CompanyModel()
        companyModel.id = String.giveMeProperString(str: event["id"])
        companyModel.address = String.giveMeProperString(str: event["address"])
        companyModel.contact_person_name = String.giveMeProperString(str: event["contact_person_name"])
        companyModel.created_at = String.giveMeProperString(str: event["created_at"])
        companyModel.description = String.giveMeProperString(str: event["description"])
        companyModel.website = String.giveMeProperString(str: event["website"])
        companyModel.phone = String.giveMeProperString(str: event["phone"])
        companyModel.name = String.giveMeProperString(str: event["name"])
        companyModel.logo_url = String.giveMeProperString(str: event["logo_url"])
        companyModel.logo_thumb_url = String.giveMeProperString(str: event["logo_thumb_url"])
        companyModel.logo_medium_url = String.giveMeProperString(str: event["logo_medium_url"])
        companyModel.is_sponsor = event["is_sponsor"] as? Bool
        //for directory flow
        companyModel.about = String.giveMeProperString(str: event["about"])
        companyModel.contact = String.giveMeProperString(str: event["contact"])
        companyModel.manager_name = String.giveMeProperString(str: event["manager_name"])
        companyModel.manager_phone = String.giveMeProperString(str: event["manager_phone"])
        if let type_of_orgArr = event["type_of_org"] as? Array<String> {
            for index in 0..<type_of_orgArr.count {
                if index + 1 == type_of_orgArr.count {
                    companyModel.type_of_org.append(type_of_orgArr[index])

                }else{
                    companyModel.type_of_org.append("\(type_of_orgArr[index]) ,")
                }
            }
        }
        
        if let business_sectorArr = event["business_sector"] as? Array<String> {
            for index in 0..<business_sectorArr.count {
                if index + 1 == business_sectorArr.count {
                    companyModel.business_sector.append(business_sectorArr[index])
                    
                }else{
                    companyModel.business_sector.append("\(business_sectorArr[index]) ,")
                }
        }
    }
        return companyModel
}
    
    class func parseMultipleCompanys(array : Array<Dictionary<String, Any>>) -> [CompanyModel] {
        var finalCompanyArray = [CompanyModel]()
        for i in 0..<array.count {
            finalCompanyArray.append(parseSingleCompany(event: array[i]))
        }
        return finalCompanyArray
    }
    
}

internal class MeetingsModel {
    internal var id: String?
    internal var created_at: String?
    internal var description: String?
    internal var title: String?
    internal var date: String?
    internal var location: String?
    internal var status: String?
    internal var updated_at: String?
    internal var company_logo_thumb_url: String?
    internal var company_logo_url: String?
    internal var company_name: String?
    internal var company_id: String?
    internal var admin_participants : Array<Dictionary<String, AnyObject>>?
    internal var all_participants : Array<Dictionary<String, AnyObject>>?
    internal var meeting_participants : Array<Dictionary<String, AnyObject>>?
    internal var companies : Array<Dictionary<String, AnyObject>>?
    internal var timeslot: String?
    internal var tableName: String?


    class func parseSingleMeeting(event : Dictionary<String,Any>) -> MeetingsModel{
        let companyModel = MeetingsModel()
        companyModel.id = String.giveMeProperString(str: event["id"])
        companyModel.created_at = String.giveMeProperString(str: event["created_at"])
        companyModel.description = String.giveMeProperString(str: event["description"])
        companyModel.title = String.giveMeProperString(str: event["title"])
        companyModel.date = String.giveMeProperString(str: event["date"])
        companyModel.location = String.giveMeProperString(str: event["location"])
        companyModel.status = String.giveMeProperString(str: event["status"])
        companyModel.updated_at = String.giveMeProperString(str: event["updated_at"])
        companyModel.admin_participants = event["admin_participants"] as? Array<Dictionary<String, AnyObject>>
        companyModel.all_participants = event["all_participants"] as? Array<Dictionary<String, AnyObject>>
        companyModel.meeting_participants = event["meeting_participants"] as? Array<Dictionary<String, AnyObject>>
        companyModel.companies = event["companies"] as? Array<Dictionary<String, AnyObject>>
        companyModel.timeslot = String.giveMeProperString(str: event["timeslot"])
        companyModel.tableName = String.giveMeProperString(str: event["table_name"])

        
        let companyProfile = event["company_details"] as? Dictionary<String, Any>
        if(companyProfile != nil){
            companyModel.company_name = String.giveMeProperString(str: companyProfile?["name"])
            companyModel.company_id = String.giveMeProperString(str: companyProfile?["id"])
            companyModel.company_logo_thumb_url = String.giveMeProperString(str: companyProfile?["logo_thumb_url"])
            companyModel.company_logo_url = String.giveMeProperString(str: companyProfile?["logo_url"])
    }
        return companyModel
    }
    
    class func parseMultipleMeetings(array : Array<Dictionary<String, Any>>) -> [MeetingsModel] {
        var finalCompanyArray = [MeetingsModel]()
        for i in 0..<array.count {
            finalCompanyArray.append(parseSingleMeeting(event: array[i]))
        }
        return finalCompanyArray
    }
    
}

internal class TimeSlotsModel {
    internal var id: String?
    internal var label: String?
    internal var is_available: Bool?
    internal var date: String?

    
    class func parseSingletimeSlotsArray(event : Dictionary<String,Any>) -> TimeSlotsModel{
        let timeSlotsModel = TimeSlotsModel()
        timeSlotsModel.id = String.giveMeProperString(str: event["id"])
        timeSlotsModel.label = String.giveMeProperString(str: event["label"])
        timeSlotsModel.date = String.giveMeProperString(str: event["date"])
        timeSlotsModel.is_available = event["is_available"] as? Bool
        return timeSlotsModel
    }
    
    class func parseMultipleTimeSlots(array : Array<Dictionary<String, Any>>) -> [TimeSlotsModel] {
        var timeSlotsArray = [TimeSlotsModel]()
        for i in 0..<array.count {
            timeSlotsArray.append(parseSingletimeSlotsArray(event: array[i]))
        }
        return timeSlotsArray
    }
    
}

