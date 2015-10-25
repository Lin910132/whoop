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
        //let url = NSURL(string: "http://www.facebook.com/whoop.hopkins")
        let url = NSURL(string: "fb://profile/100009359472896")
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
        else {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.facebook.com/whoop.hopkins")!)
        }
    }
    
    
    @IBAction func renrenLink(sender: AnyObject) {
        //if let url = NSURL(string: "http://page.renren.com/602116917") {
        //    UIApplication.sharedApplication().openURL(url)
        //}
        let renrenHooks = "renren://page.renren.com/602116917"
        let renrenUrl = NSURL(string: renrenHooks)
        if UIApplication.sharedApplication().canOpenURL(renrenUrl!)
        {
            UIApplication.sharedApplication().openURL(renrenUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.sharedApplication().openURL(NSURL(string: "http://page.renren.com/602116917")!)
        }
    }
   
}
