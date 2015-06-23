//
//  YRCommentsViewController.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014y YANGReal. All rights reserved.
//

import UIKit

class YRCommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,YRRefreshViewDelegate ,UITextFieldDelegate,YRRefreshCommentViewDelegate,YRRefreshCommentDelegate{
    
    var tableView:UITableView?
    let identifier = "cell"
    
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    var jokeId:String!              //jokeId即为postId
    
    var postData:NSDictionary!
    var headerView:YRJokeCell2?
    
    var sendView:YRSendComment?
    
    var refreshCommentDelete:YRRefreshCommentDelegate?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.title = "Detail"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        //self.tableView?.backgroundColor = UIColor(red: 0.173, green: 0.133, blue: 0.361, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    func setupViews()
    {
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        self.tableView = UITableView(frame:CGRectMake(0,0,width,height), style:.Grouped)
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        
        //self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        //self.tableView?.separatorColor = UIColor.redColor()
        self.tableView?.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        //var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        var nib = UINib(nibName: "YRCommnentsCell", bundle: nil)
        
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        self.view.addSubview(self.tableView!)
        
        
        var arr =  NSBundle.mainBundle().loadNibNamed("YRSendComment" ,owner: self, options: nil) as Array
        self.sendView = arr[0] as? YRSendComment
        self.sendView?.delegate = self
        self.sendView?.setCurrentPostId(jokeId)
        
        self.sendView?.frame = CGRectMake(0, height - 50 , width, 50)
        self.view.addSubview(sendView!)
        
        let btn = UIBarButtonItem(image: UIImage(named: "info"), landscapeImagePhone: UIImage(named: "info"), style: UIBarButtonItemStyle.Plain, target: self, action: "btnAuditClicked")
        self.navigationItem.rightBarButtonItem = btn
        
        loadPostData()
        
        //        headerView.initData()
        
        
        
        
        //        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        //        self.refreshView = arr[0] as? YRRefreshView
        //        self.refreshView!.delegate = self
        //
        //        self.tableView!.tableFooterView = self.refreshView
        
    }
    
    func loadData()
    {
        var url = FileUtility.getUrlDomain() + "comment/getCommentByPostId?postId=\(jokeId)"
        //        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("WARNING",message:"Network error!")
                return
            }
            
            var arr = data["data"] as! NSArray
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            self.tableView!.reloadData()
            //            self.refreshView!.stopLoading()
            self.page++
            
            
            
            
        })
        
    }
    
    func loadPostData()
    {
        var url = FileUtility.getUrlDomain() + "post/get?id=\(self.jokeId)&uid=\(FileUtility.getUserId())"
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            
            
            var arrHeader =  NSBundle.mainBundle().loadNibNamed("YRJokeCell" ,owner: self, options: nil) as Array
            
            self.headerView = YRJokeCell2(style: .Default, reuseIdentifier: "cell")
            var post = data["data"] as! NSDictionary
            self.headerView?.data = post
            self.headerView?.setCellUp()
            self.headerView?.frame = CGRectMake(0, 0, self.view.frame.size.width,YRJokeCell2.cellHeightByData(post))
            self.headerView?.backgroundColor = UIColor(red:246.0/255.0 , green:246.0/255.0 , blue:246.0/255.0 , alpha: 1.0);
            
            self.tableView!.tableHeaderView = self.headerView
            self.headerView?.refreshCommentDelegate = self
        })
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? YRJokeCell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YRCommnentsCell
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        cell.data = data
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.whiteColor();
        return cell
    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
    //
    //
    //    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        return  YRCommnentsCell.cellHeightByData(data)
    }
    //    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    //    {
    //        var index = indexPath!.row
    //        var data = self.dataArray[index] as NSDictionary
    //        println(data)
    //    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData()
    }
    
    
    func refreshCommentView(refreshView:YRSendComment,didClickButton btn:UIButton){
        self.dataArray = NSMutableArray()
        loadData()
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        self.sendView?.frame = CGRectMake(0, height - 50 , width, 50)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnAuditClicked(){
        var alertView = UIAlertView()
        alertView.title = "Report"
        alertView.message = "This post violate whoop's regulation!"
        alertView.addButtonWithTitle("No")
        alertView.addButtonWithTitle("Yes")
        alertView.cancelButtonIndex = 0
        alertView.delegate = self
        alertView.show()
        
    }
    
    func refreshCommentByFavor(){
        loadPostData()
    }

    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex:Int){
        if buttonIndex != alertView.cancelButtonIndex{
            var url = FileUtility.getUrlDomain() + "post/reportPost?postId=\(self.jokeId)&uid=\(FileUtility.getUserId())"
            
            YRHttpRequest.requestWithURL(url,completionHandler:{ data in
                
                if data as! NSObject == NSNull()
                {
                    UIView.showAlertView("Alert",message:"Loading Failed")
                    return
                }
                
                UIView.showAlertView("Alert",message:"Report success")
                
            })
            
        }
    }
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
