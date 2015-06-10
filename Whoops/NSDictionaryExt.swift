//
//  NSDictionary-Null.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 15-2-17.
//  Copyright (c) 2015y naikun. All rights reserved.
//

import UIKit
import Foundation
extension NSDictionary {
    
    
    func stringAttributeForKey(key:String)->String
    {
        var obj : AnyObject! = self[key]
        if obj == nil {
            return ""
        }
        if obj as! NSObject == NSNull()
        {
            return ""
        }
        if obj.isKindOfClass(NSNumber)
        {
            var num = obj as! NSNumber
            return num.stringValue
        }
        return obj as! String
    }
    
}
