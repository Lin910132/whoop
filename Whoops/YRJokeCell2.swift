//
//  YRJokeCell2.swift
//  Whoop
//
//  Created by djx on 15/5/22.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import UIKit

var textYpostion:CGFloat = 0;
var isTop:Bool=false;

protocol YRJokeCellDelegate
{
    
    func sendEmail(strTo:String, strSubject:String, strBody:String);
}

protocol YRRefreshMainDelegate
{
    
    func refreshMain();
}

protocol YRRefreshCommentDelegate
{
    
    func refreshCommentByFavor();
}



class YRJokeCell2: UITableViewCell
{

    var delegate:YRJokeCellDelegate?
    var refreshMainDelegate:YRRefreshMainDelegate?
    var refreshCommentDelegate:YRRefreshCommentDelegate?
    var data = NSDictionary()
    var postId:String = ""
    var likeNum:UILabel!
    
    var imgList = [UIImageView]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCellUp()
    {
        for view : AnyObject in self.subviews
        {
            view.removeFromSuperview();
        }
        
        if(self.data.count <= 0)
        {
            return ;
        }

        var rec = UIScreen.mainScreen().bounds.width;
        
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0);
        //背景图片
        var ivBack = UIImageView(frame:CGRectMake(10, 7, UIScreen.mainScreen().bounds.width - 20, 187));
        ivBack.backgroundColor = UIColor.whiteColor();
        ivBack.layer.shadowOffset = CGSizeMake(10, 10);
        ivBack.layer.shadowColor = UIColor(red:237.0/255.0 , green:237.0/255.0, blue:237.0/255.0 , alpha: 1.0).CGColor;
        ivBack.userInteractionEnabled = true;
        self.addSubview(ivBack);
        
        //收藏按钮
        var fav = UIButton(frame:CGRectMake(3, 3, 24, 24));
        //fav.backgroundColor = UIColor.redColor();
        var isFavor = data.stringAttributeForKey("isFavor") as String;
        if isFavor == "favor" {
            fav.setImage(UIImage(named:"starB1"), forState: UIControlState.Normal);
        }else{
            fav.setImage(UIImage(named:"star"), forState: UIControlState.Normal);
        }
        fav.addTarget(self, action: "btnFavClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(fav);
        
        //设置图片
        var imageStr = data.stringAttributeForKey("image") as NSString;
        var imgArray = imageStr.componentsSeparatedByString(",") as NSArray;
        var height:CGFloat = 160; //图片区域的高度
        var offset:CGFloat = 5; //图片偏移区
        var xPositon:CGFloat = 5;
        var yPosition:CGFloat = 33;
        var width:CGFloat;
        width = (CGFloat)(ivBack.frame.size.width - 55); //图片区域的宽度
        
        
        
        
        if(imgArray.count > 0 && imageStr.length > 0)
        {
            isTop = false;
            if (imgArray.count == 1)
            {
                //只有一张图片,高度应该小于宽度，以高度为准，居中显示
                var img0 = UIImageView(frame:CGRectMake((width - height)/2, yPosition, height, height));
                self.imgList.append(img0)
                
                ivBack.addSubview(img0);
                var imgUrl = imgArray.objectAtIndex(0) as! NSString;
                if(imgUrl.length <= 0)
                {
                    img0.image = UIImage(named: "Logoo.png");
                }
                else
                {
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as String);
                    img0.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"));
                }
                
                textYpostion = height + yPosition;
                
            }
            else if(imgArray.count == 2)
            {
                //2张图片
                var widthTmp:CGFloat;
                widthTmp = (CGFloat)(width - offset)/2;
                var imgWidth:CGFloat;
                imgWidth = height>widthTmp ? widthTmp:height;
                var index = 0
                for imgUrl in imgArray
                {
                    var x:CGFloat;
                     x = xPositon + CGFloat(index * Int(imgWidth + offset));
                    var imgView = UIImageView(frame:CGRectMake(x, yPosition, imgWidth, imgWidth));
                    self.imgList.append(imgView)
                    imgView.userInteractionEnabled = true
                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as! String)
                    imgView.tag = index;
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    index++;
                    ivBack.addSubview(imgView);
                    
                }
                
                textYpostion = imgWidth + yPosition;
            }
            else if(imgArray.count >= 3)
            {
                //3张图片及以上
                var widthTmp:CGFloat;
                widthTmp = (CGFloat)(width - 2*offset)/3;
                var index = 0
                for imgUrl in imgArray
                {
                    var x:CGFloat;
                    x = xPositon + CGFloat(index%3 * Int(widthTmp + offset));
                    var y:CGFloat;
                    y = yPosition + CGFloat(index/3 * Int(widthTmp + offset));
                    var imgView = UIImageView(frame:CGRectMake(x , y, widthTmp, widthTmp));
                    self.imgList.append(imgView)
                    imgView.userInteractionEnabled = true
                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as! String)
                    imgView.tag = index;
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    index++;
                    ivBack.addSubview(imgView);
                }
                
                textYpostion = yPosition + CGFloat(index/3 * Int(widthTmp + offset));
            }
        }
        else
        {
            isTop = true;
            textYpostion = 138;
        }
        
        var lbPostion:CGFloat;
        if(isTop)
        {
            lbPostion = yPosition;
        }
        else
        {
            lbPostion = textYpostion;
        }
        
        var lableContent = UILabel(frame: CGRectMake(3, lbPostion + 5, ivBack.frame.size.width-6, 1000));
        lableContent.numberOfLines = 0;
        lableContent.textColor = UIColor(red:60.0/255.0 , green:60.0/255.0 , blue: 60.0/255.0, alpha: 1.0);
        lableContent.font = UIFont.systemFontOfSize(13);
        var text = data.stringAttributeForKey("content");
        
        lableContent.text = text as String;
        let size = text.stringHeightWith(13,width:lableContent.frame.size.width);
        var rect = lableContent.frame as CGRect;
        rect.size.height = size+20;
        rect.size.width = ivBack.frame.size.width-50
        lableContent.frame = rect;
        ivBack.addSubview(lableContent);
        
        //设置底部数据
        var bottomY = textYpostion+size + 25;
        if(isTop)
        {
            if(size + yPosition > 153)
            {
                bottomY = size + yPosition + 25;
            }
            else
            {
                bottomY = 138 + 15;
            }
            
        }
        
        var rectBack = ivBack.frame as CGRect;
        rectBack.size.height = bottomY + 35;
        ivBack.frame = rectBack;
        
        //喜欢按钮
        var like = UIButton(frame:CGRectMake(ivBack.frame.size.width-36, ((textYpostion - yPosition)/3 - 34)/2 + yPosition, 34, 34));
        like.setImage(UIImage(named:"Like"), forState: UIControlState.Normal);
        like.addTarget(self, action: "btnLikeClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(like);
        
        //喜欢数量
        likeNum = UILabel(frame: CGRectMake(ivBack.frame.size.width-52, (textYpostion - yPosition)/3 + ((textYpostion - yPosition)/3 - 34)/2 + yPosition, 67, 34));
        likeNum.textAlignment = NSTextAlignment.Center;
        likeNum.textColor = UIColor(red:121.0/255.0 , green:122.0/255.0 , blue:124.0/255.0 , alpha: 1.0);
        if (data.stringAttributeForKey("likeNum") == NSNull())
        {
            likeNum.text = "0";
        }
        else
        {
            likeNum.text = data.stringAttributeForKey("likeNum");
        }
        ivBack.addSubview(likeNum);
        
        //不喜欢
        var unlike = UIButton(frame:CGRectMake(ivBack.frame.size.width-36, 2*(textYpostion - yPosition)/3+((textYpostion - yPosition)/3 - 34)/2 + yPosition, 34, 34));
        unlike.setImage(UIImage(named:"close"), forState: UIControlState.Normal);
        unlike.addTarget(self, action: "btnUnLikeClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(unlike);
        


        
        var viewBottom = UIView(frame: CGRectMake(0, bottomY, ivBack.frame.size.width, 35));
        viewBottom.backgroundColor = UIColor(red:244.0/255.0 , green:244.0/255.0 , blue:244.0/255.0 , alpha: 1.0);
        ivBack.addSubview(viewBottom);
        
        var imgTime = UIImageView(frame: CGRectMake(5, 9, 16, 16));
        imgTime.image = UIImage(named: "time");
        viewBottom.addSubview(imgTime);
        
        var createDateLabel = UILabel(frame: CGRectMake(25, 9, 30, 16));
        createDateLabel.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        createDateLabel.font = UIFont.systemFontOfSize(13);
        createDateLabel.text = data.stringAttributeForKey("createDateLabel") as String;
        viewBottom.addSubview(createDateLabel);
        
        var commentCount = UILabel(frame: CGRectMake(55, 9, 70, 16));
        commentCount.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        commentCount.font = UIFont.systemFontOfSize(13);
        commentCount.textAlignment = NSTextAlignment.Center;
        
        var strcommentCount = data.stringAttributeForKey("commentCount") as String
        if strcommentCount == "" || strcommentCount == "0" {
            strcommentCount = "0 Reply"
        }else if strcommentCount == "1" {
            strcommentCount = "1 Reply"
        }else {
            strcommentCount = "\(strcommentCount) Replies"
        }
        commentCount.text = "\(strcommentCount) ";
        viewBottom.addSubview(commentCount);
        
        var  imgNick = UIImageView(frame: CGRectMake(155, 9, 16, 16));
        imgNick.image = UIImage(named: "ballonHighlight");
        imgNick.userInteractionEnabled = true;
        viewBottom.addSubview(imgNick);
        
        var nickName = UILabel(frame: CGRectMake(177, 9, ivBack.frame.width - 180, 16));
        nickName.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        nickName.font = UIFont.systemFontOfSize(13);
        nickName.text = data.stringAttributeForKey("nickName") as String;
        viewBottom.addSubview(nickName);
        
        var btnNick = UIButton(frame: CGRectMake(155, 9, ivBack.frame.width - 164, 16));
        btnNick.backgroundColor = UIColor.clearColor();
        btnNick.addTarget(self, action: "btnNickClick:", forControlEvents: UIControlEvents.TouchUpInside);
        viewBottom.addSubview(btnNick);
        
        postId = self.data.stringAttributeForKey("id") as String
    }
    
    func btnNickClick(sender:UIButton)
    {
        var nick = self.data.stringAttributeForKey("nickName") as NSString;
        if(YRJokeCell2.judgeNum(nick))
        {
            var telStr = NSString(format:"tel:%@",nick);
            var url = NSURL(string: telStr as String);
            UIApplication.sharedApplication().openURL(url!);
        }
        else if(YRJokeCell2.judgeEmail(nick))
        {
            if(delegate != nil)
            {
                var content = self.data.stringAttributeForKey("content")
                var subject:String = content
                if count(content) > 20 {
                    subject = content.substringToIndex(20)
                    subject = subject + "..."
                }
                subject = "I'm interest in your post in Whoop, that " + subject

                var body:String = "Hi, I'm interest in your post in Whoop, that \"" + content + "\""

                delegate?.sendEmail(nick as String,
                    strSubject: subject,
                    strBody:  body)
                
            }
        }
    }
    

    
    func btnFavClick(sender:UIButton)
    {
        var url = FileUtility.getUrlDomain() + "favorPost/add?postId=\(postId)&uid=\(FileUtility.getUserId())"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            
            self.refreshMainDelegate?.refreshMain()
            self.refreshCommentDelegate?.refreshCommentByFavor()
            
        })

    }
    
    func btnLikeClick(sender:UIButton)
    {
        var url = FileUtility.getUrlDomain() + "post/like?id=\(postId)&uid=\(FileUtility.getUserId())"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            var result:Int = data["result"] as! Int
            self.likeNum!.text = "\(result)"
            
            
        })
    }
    
    func btnUnLikeClick(sender:UIButton)
    {
        var url = FileUtility.getUrlDomain() + "post/unlike?id=\(postId)&uid=\(FileUtility.getUserId())"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("提示",message:"加载失败")
                return
            }
            var result:Int = data["result"] as! Int
            self.likeNum!.text = "\(result)"
            
        })
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width
        var lableContent = UILabel(frame: CGRectMake(3, 193, mainWidth - 26, 1000));
        lableContent.numberOfLines = 0;
        lableContent.font = UIFont.systemFontOfSize(13);
        var text = data.stringAttributeForKey("content");
        let size = text.stringHeightWith(13,width:mainWidth - 26);
        
        var bottomY = textYpostion+size + 10;
        var resut = textYpostion + size+65;
        
        if(isTop)
        {
            if(size + 33 > 153)
            {
                bottomY = size + 33  + 15;
            }
            else
            {
                bottomY = 138;
            }
            
            resut = bottomY + 50;
        }

        return resut;

    }
    
    class func judgeNum(strInput:NSString)->Bool
    {
        if(strInput.isEqualToString("") || strInput.length <= 0)
        {
            return false;
        }
        var strTmp:NSString;
        strTmp = strInput.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet());
        if(strTmp.length > 0)
        {
            return false;
        }
        return true;
    }
    
    class func judgeEmail(strInput:NSString)->Bool
    {
        if(strInput.isEqualToString("") || strInput.length <= 0)
        {
            return false;
        }
        
        var emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
        var email = NSPredicate(format:"SELF MATCHES%@",emailRegex);
        
        return email.evaluateWithObject(strInput);
    }
    
    
    func imageViewTapped(sender:UITapGestureRecognizer)
    {
        var i:Int = sender.view!.tag
        var image = self.imgList[i].image
        var window = UIApplication.sharedApplication().keyWindow
        var backgroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        var imageView = UIImageView(frame: self.imgList[i].frame)
        
        imageView.image = image
        //        imageView.tag = i + 1
        backgroundView.addSubview(imageView)
        window?.addSubview(backgroundView)
        var hide = UITapGestureRecognizer(target: self, action: "hideImage:")
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(hide)
        UIView.animateWithDuration(0.3, animations:{ () in
            var vsize = UIScreen.mainScreen().bounds.size
            imageView.frame = CGRect(x:0.0, y: 0.0, width: vsize.width, height: vsize.height)
            imageView.contentMode = .ScaleAspectFit
            backgroundView.alpha = 1
            }, completion: {(finished:Bool) in })
        
        
    }
    
    func hideImage(sender: UITapGestureRecognizer){
        var i:Int = sender.view!.tag
        var backgroundView = sender.view as UIView?
        if let view = backgroundView{
            UIView.animateWithDuration(0.1,
                animations:{ () in
                    var imageView = view.viewWithTag(i) as! UIImageView
                    imageView.frame = self.imgList[i].frame
                    imageView.alpha = 0
                    
                },
                completion: {(finished:Bool) in
                    view.alpha = 0
                    view.superview?.removeFromSuperview()
                    view.removeFromSuperview()
            })
        }
    }

}
