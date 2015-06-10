//
//  YRHttpRequest.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-5.
//  Copyright (c) 2014y YANGReal. All rights reserved.
//

import UIKit
import Foundation

//class func connectionWithRequest(request: NSURLRequest!, delegate: AnyObject!) -> NSURLConnection!


class YRHttpRequest: NSObject {

    override init()
    {
        super.init();
    }
    
    class func requestWithURL(urlString:String,completionHandler:(data:AnyObject)->Void)
    {
        var url = NSURL(string:urlString)
        var req = NSURLRequest(URL: url!)
        var queue = NSOperationQueue();
        NSURLConnection.sendAsynchronousRequest(req, queue: queue, completionHandler: { response, data, error in
            if error != nil
            {
                dispatch_async(dispatch_get_main_queue(),
                {
                    println(error)
                    completionHandler(data:NSNull())
                })
            }
            else
            {
                let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary

                dispatch_async(dispatch_get_main_queue(),
                {
                    completionHandler(data:jsonData)
                    
                })
            }
        })
    }
    
   
    class func postWithURL(#urlString:String,paramData:String)->NSMutableArray{
    
    
        var data:NSMutableArray = NSMutableArray()
        var url1:NSURL = NSURL(string: urlString)!
    
        var postData:NSData = paramData.dataUsingEncoding(NSUTF8StringEncoding)!
    
        var postLength:String = String( postData.length )
    
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url1)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
        var reponseError: NSError?
        var response: NSURLResponse?
    
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
    
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            NSLog("Response code: %ld", res.statusCode);
    
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
    
                NSLog("Response ==> %@", responseData);
    
                var error: NSError?
    
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
    
                
    
                
            } else {
                NSLog("Login failed2");
            }
        } else {
            NSLog("Login failed3");
        }
        return data
    }
    
}
