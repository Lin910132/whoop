//
//  FileUtility.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014y YANGReal. All rights reserved.
//

import UIKit

class FileUtility: NSObject {
    
    
    class func cachePath(fileName:String)->String
    {
        var arr =  NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        var path = arr[0] as! String
        return "\(path)/\(fileName)"
    }
    
    
    class func imageCacheToPath(path:String,image:NSData)->Bool
    {
        return image.writeToFile(path, atomically: true)
    }
    
    class func imageDataFromPath(path:String)->AnyObject
    {
        var exist = NSFileManager.defaultManager().fileExistsAtPath(path)
        if exist
        {
            return  UIImage(contentsOfFile: path)!
        }
        
        return NSNull()
    }
    
    
    class func loadUserId() -> String{
        var userId:String = "0"
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("user.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("user", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle user.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("user.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("user.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded user.plist file is --> \(resultDictionary?.description)")
        var myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            
          
            var key = dict.allKeys[0] as! String

            userId =  dict.objectForKey(key) as! String
         

            //...
        } else {
            println("WARNING: Couldn't create dictionary from user.plist! ")
        }
        return userId
    }
    
    
    class func saveUserId() {
        var url = FileUtility.getUrlDomain() + "user/add"
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            
            var user = data["data"] as! NSDictionary
            var userId = user.stringAttributeForKey("id")
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths.objectAtIndex(0) as! NSString
            let path = documentsDirectory.stringByAppendingPathComponent("user.plist")
            var dict: NSMutableDictionary = NSMutableDictionary()
            
            
            //saving values
            dict.setObject(userId, forKey: "userid")
            
            //...
            //writing to user.plist
            dict.writeToFile(path, atomically: false)
            let resultDictionary = NSMutableDictionary(contentsOfFile: path)
          
            
        })

        
        
    }
    
    
    class func getUserId() ->String{
        var userId:String = loadUserId()
        if userId == "0"{
            saveUserId()
            userId = loadUserId()
        }
        return userId
    }
    
    class func getUrlDomain()->String{
        let urlDomain = "http://104.131.91.181:8080/whoops/"
        return urlDomain
    }
    
    class func getUrlImage()->String{
        let urlDomain = "http://104.131.91.181/"
        return urlDomain
    }
    
    
    
}
