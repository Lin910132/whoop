//
//  YRJokeCell.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-6.
//  Copyright (c) 2014y YANGReal. All rights reserved.
//

import UIKit


class YRJokeCell: UITableViewCell {
    
//    @IBOutlet var avatarView:UIImageView?

    @IBOutlet var nickLabel:UILabel?
    @IBOutlet var contentLabel:UILabel?
 
    @IBOutlet var containsPicView: UIView!
    @IBOutlet var commentLabel:UILabel?
    @IBOutlet var bottomView:UIView?
    
    @IBOutlet weak var likeImage: UIImageView!
    
    
    @IBOutlet weak var likeHotLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
   
    @IBOutlet weak var dislikeImage: UIImageView!
    
    var largeImageURL:String = ""
    var data :NSDictionary!
    
    var mainWidth:CGFloat = 0
    
    @IBOutlet weak var favorPost: UIImageView!
    var postId:String = ""
    var imgUrls:[String] = [String]()
    //let avatarPlaceHolder = UIImage(named: "avatar.jpg")
    
    @IBAction func shareBtnClicked()
    {
        // self.delegate!.jokeCell(self, didClickShareButtonWithData:self.data)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        mainWidth = UIScreen.mainScreen().bounds.width
       
        favorPost.userInteractionEnabled = true
        var tap = UITapGestureRecognizer(target: self, action: "favorViewTapped:")
        favorPost!.addGestureRecognizer(tap)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       // // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.nickLabel!.text = self.data.stringAttributeForKey("nickName")
        var content = self.data.stringAttributeForKey("content")
        var width = self.contentLabel?.width()
        var height = content.stringHeightWith(17,width:width!)

        self.contentLabel!.setHeight(height)
        self.contentLabel!.text = content
        

        
        for subview in containsPicView.subviews{
            if subview is UIImageView{
                subview.removeFromSuperview()
            }
        }
        
        var imgSrc = self.data.stringAttributeForKey("image") as NSString
        if imgSrc.length == 0
        {
            self.containsPicView!.hidden = true
            //self.bottomView!.setY(self.contentLabel!.bottom())
        }
        else
        {
            containsPicView.hidden = false
            imgUrls = imgSrc.componentsSeparatedByString(",") as! [String]
            var count = imgUrls.count
            if imgUrls.count <= 3 {
                var imgWidth = (mainWidth - 10 - 10 - 20 - 100)/CGFloat(count)
                var i = 0
                for imgUrl in imgUrls {
                    var imgView = UIImageView()
                    imgView.userInteractionEnabled = true
                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + imgUrl
                    imgView.tag = i
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    
                    i++
                    var tempWidth = 10 * i + (i-1) * Int(imgWidth)
                    imgView.frame = CGRectMake(CGFloat(tempWidth), height , imgWidth, imgWidth)
                    self.containsPicView.addSubview(imgView)
                    
                }
            }else {
                
                var imgWidth = (mainWidth - 10 - 10 - 20 - 100)/CGFloat(count >= 3 ? 3 : count)
                var i = 0
                for imgUrl in imgUrls {
                    var imgView = UIImageView()
                    imgView.userInteractionEnabled = true
                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + imgUrl
                    imgView.tag = i
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    
                    i++
                    
                    if i <= 3 {
                        var tempWidth = 10 * i + (i-1) * Int(imgWidth)
                        imgView.frame = CGRectMake(CGFloat(tempWidth), height , imgWidth, imgWidth)
                    }else{
                        var tempWidth = 10 * (i-3) + (i-4) * Int(imgWidth)
                        imgView.frame = CGRectMake(CGFloat(tempWidth), height + imgWidth + 10, imgWidth, imgWidth)
                    }
                    self.containsPicView.addSubview(imgView)
                    
                }

                
            }
        }
        
       
        if self.data.stringAttributeForKey("likeNum") == NSNull(){
            self.likeHotLabel!.text = "0"
        }else{
            self.likeHotLabel!.text = self.data.stringAttributeForKey("likeNum")
        }
            
//        if self.data.stringAttributeForKey("dislikeNum") == NSNull(){
//            self.dateTimeLabel!.text = "0"
//        }else{
//            self.dateTimeLabel!.text = self.data.stringAttributeForKey("dislikeNum")
//        }
        
        
        var commentCount = self.data.stringAttributeForKey("commentCount") as String
        if commentCount == "" || commentCount == "0" {
            commentCount = "0 Reply"
        }else if commentCount == "1" {
            commentCount = "1 Reply"
        }else {
            commentCount = "\(commentCount) Replies"
        }
        self.commentLabel!.text = "\(commentCount) "
        
        
        var cellHeight:CGFloat = YRJokeCell.cellHeightByData(self.data);
        //self.dislikeLabel?.setY(cellHeight/2)
        
        
        var nickName = self.data.stringAttributeForKey("nickName") as String
        if nickName == ""{
           contentLabel?.frame = CGRectMake(0, 0, cellContentWidth(), content.stringHeightWith(17,width:cellContentWidth()))
        }else{
            self.nickLabel!.text = "@" + nickName
            //contentLabel?.frame = CGRectMake(20, 30, 300, content.stringHeightWith(17,width:300))
        }
        self.dateTimeLabel!.text = self.data.stringAttributeForKey("createDateLabel") as String
        
       postId = self.data.stringAttributeForKey("id") as String
    
    }
    
    func cellContentWidth()->CGFloat{
        let mainWidth = UIScreen.mainScreen().bounds.width
        return mainWidth - 80
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width

        var nickName = data.stringAttributeForKey("nickName")
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:mainWidth-100)
        var imgSrc = data.stringAttributeForKey("image") as NSString
        var value = CGFloat()
        
        if imgSrc.length == 0
        {
            if nickName == "" {
                value = 59.0 + height + 40
            }else{
                value = 59.0 + height + 60
            }
            if value < 140 {
                return 140
            } else {
                return value
            }
        }
        
        return 59.0 + height + 5.0 + 140.0 + 100
        
    }
    
    func imageViewTapped(sender:UITapGestureRecognizer)
    {
        var i:Int = sender.view!.tag
        NSNotificationCenter.defaultCenter().postNotificationName("imageViewTapped", object:self.imgUrls[i])
        
    }
    
    func favorViewTapped(sender:UITapGestureRecognizer)
    {
        var url = FileUtility.getUrlDomain() + "favorPost/add?postId=\(postId)&uid=\(FileUtility.getUserId())"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            
            
            
        })
        
    }
    
    var likeCilcke:Bool = true
    var unLikeClick:Bool = true
    
    @IBAction func likeImageClick(){
            var url = FileUtility.getUrlDomain() + "post/like?id=\(postId)&uid=\(FileUtility.getUserId())"
            
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as! NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }
                var result:Int = data["result"] as! Int
                self.likeHotLabel!.text = "\(result)"

                
            })
        
        
    }
    
    @IBAction func unlikeImageClick(){
            var url = FileUtility.getUrlDomain() + "post/unlike?id=\(postId)&uid=\(FileUtility.getUserId())"
            
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as! NSObject == NSNull()
                {
                    UIView.showAlertView("提示",message:"加载失败")
                    return
                }
                var result:Int = data["result"] as! Int
                self.likeHotLabel!.text = "\(result)"
                
            })
            

    }
    
}
