//
//  DataBaseHelper.swift
//  Vaco
//
//  Created by Param on 25/07/17.
//  Copyright © 2017 vaco. All rights reserved.
//

import UIKit
import CoreData

class DataBaseHelper: NSObject {
    static var sharedInstance : DataBaseHelper!
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    class func shared() -> DataBaseHelper {
        if sharedInstance == nil {
            sharedInstance = DataBaseHelper()
        }
        return sharedInstance
    }
    
    //get context
    func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - Saving and Updating user details in Core Data
    // Fetch User Entity
    func getUserObject() -> NSManagedObject? {
        var user = User()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let records = try getContext().fetch(fetchRequest) as! [NSManagedObject]
            if records.count > 0 {
                user = records[0] as! User
                return user
            }
            } catch {
            print(error)
        }
        return user
    }
    
    //Add or Update user details in DB
    func addOrUpdaeUserObject(userDetails : Dictionary<String,Any>) {
        let fetchReuest : NSFetchRequest<User> = User.fetchRequest()
        fetchReuest.resultType = .managedObjectResultType
        do {
            let result = try self.getContext().fetch(fetchReuest)
            if result.count > 0{
                let userObj = result[0] as NSManagedObject
                setValuesForUserObject(userObj: userObj as! User, userDetails: userDetails)
            }
            else{
                self.insertUserObject(userDetails: userDetails)
            }
            do {
                try self.getContext().save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Update image url
    func updateImageUrlInLocalDB(imgUrl : String) {
        let fetchReuest : NSFetchRequest<User> = User.fetchRequest()
        fetchReuest.resultType = .managedObjectResultType
        do {
            let result = try self.getContext().fetch(fetchReuest)
            if result.count > 0{
                let userObj = result[0] as NSManagedObject
                userObj.setValue(imgUrl, forKey: "avatarUrl")
            }
            do {
                try self.getContext().save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Insert User Details in DB
    func insertUserObject(userDetails : Dictionary<String,Any>) {
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let userObj = NSManagedObject(entity: entity!, insertInto: context)
        setValuesForUserObject(userObj: userObj as! User, userDetails: userDetails)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
  
    //Set User Details for User object
    func setValuesForUserObject(userObj : User, userDetails : Dictionary<String,Any>) {
        //Set user details
        userObj.setValue(String.giveMeProperString(str: userDetails["id"]), forKey: "userId")
        userObj.setValue(String.giveMeProperString(str: userDetails["email"]), forKey: "email")
        userObj.setValue(String.giveMeProperString(str: userDetails["avatar_url"]), forKey: "avatarUrl")
        userObj.setValue(String.giveMeProperString(str: userDetails["created_at"]), forKey: "createdDate")
        userObj.setValue(String.giveMeProperString(str: userDetails["avatar_url"]), forKey: "avatarUrl")
        userObj.setValue(String.giveMeProperString(str: userDetails["facebook_id"]), forKey: "facebookId")
        userObj.setValue(String.giveMeProperString(str: userDetails["token"]), forKey: "token")
      //  userObj.setValue(String.giveMeProperString(str: userDetails["role"]), forKey: "role")
         userObj.setValue(String.giveMeProperString(str: userDetails["name"]), forKey: "name")
        // userObj.setValue(String.giveMeProperString(str: userDetails["updated_at"]), forKey: "updatedDate")
        //Set Profile Details
        let userProfile = userDetails["profile"] as? Dictionary<String, Any>
        if(userProfile != nil){
//            userObj.setValue(String.giveMeProperString(str: userProfile?["full_name"]), forKey: "name")
            userObj.setValue(String.giveMeProperString(str: userProfile?["position"]), forKey: "designation")
            userObj.setValue(String.giveMeProperString(str: userProfile?["company"]), forKey: "organization")
            userObj.setValue(String.giveMeProperString(str: userProfile?["summary"]), forKey: "summary")
            userObj.setValue(String.giveMeProperString(str: userProfile?["twitter"]), forKey: "twitter")
            userObj.setValue(String.giveMeProperString(str: userProfile?["linkedin"]), forKey: "linkedin")
            userObj.setValue(String.giveMeProperString(str: userProfile?["website"]), forKey: "website")
        }
    }
    
    //Delete user object when user logout
    func deleteUserDetailsObject() {
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "User")
        do {
            let result = try context.fetch(fetchRequest)
            for object in result {
                context.delete(object as! NSManagedObject)
            }
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //Check Entity is empty
    func entityIsEmpty(entityName : String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let records = try getContext().fetch(fetchRequest) as! [NSManagedObject]
            if records.count > 0 {
                return false
            }
            else{
                return true
            }
        } catch {
            print(error)
            return true
        }
    }

}

