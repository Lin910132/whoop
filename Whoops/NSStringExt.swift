//
//  NSStringExtension.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-6.
//  Copyright (c) 2014y YANGReal. All rights reserved.
//
import UIKit
import Foundation

extension String {
   

    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat

    {
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width,CGFloat.max)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    func dateStringFromTimestamp(timeStamp:NSString)->String
    {
        var ts = timeStamp.doubleValue
        var  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyyyMM月dd日 HH:MM:ss"
        var date = NSDate(timeIntervalSince1970 : ts)
         return  formatter.stringFromDate(date)
        
    }
    
    func substringToIndex(index:Int) -> String {
        return self.substringToIndex(advance(self.startIndex, index))
    }
    func substringFromIndex(index:Int) -> String {
        return self.substringFromIndex(advance(self.startIndex, index))
    }
    func substringWithRange(range:Range<Int>) -> String {
        let start = advance(self.startIndex, range.startIndex)
        let end = advance(self.startIndex, range.endIndex)
        return self.substringWithRange(start..<end)
    }
    subscript(index:Int) -> Character{
        return self[advance(self.startIndex, index)]
    }
    subscript(range:Range<Int>) -> String {
        let start = advance(self.startIndex, range.startIndex)
        let end = advance(self.startIndex, range.endIndex)
        return self[start..<end]
    }
    func replaceCharactersInRange(range:Range<Int>, withString: String!) -> String {
        var result:NSMutableString = NSMutableString(string: self)
        result.replaceCharactersInRange(NSRange(range), withString: withString)
        return result as String
    }
    
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as [NSObject : AnyObject])
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as [NSObject : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}
