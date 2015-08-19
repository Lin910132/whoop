//
//  SettingViewController.swift
//  UniPub
//
//  Created by Li Jiatan on 8/18/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBAction func facebookLink(sender: AnyObject) {
        if let url = NSURL(string: "https://www.facebook.com/whoop.hopkins") {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    
    @IBAction func renrenLink(sender: AnyObject) {
        //if let url = NSURL(string: "http://page.renren.com/602116917") {
        //    UIApplication.sharedApplication().openURL(url)
        //}
        var renrenHooks = "renren://page.renren.com/602116917"
        var renrenUrl = NSURL(string: renrenHooks)
        if UIApplication.sharedApplication().canOpenURL(renrenUrl!)
        {
            UIApplication.sharedApplication().openURL(renrenUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.sharedApplication().openURL(NSURL(string: "http://page.renren.com/602116917")!)
        }
    }
   
}
