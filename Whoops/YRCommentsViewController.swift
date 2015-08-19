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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onKeyboardWillChangeFrame:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewDidDisappear(animated)
    }

    
    /**
    键盘显示隐藏事件监听
    */
    func onKeyboardWillChangeFrame(notification: NSNotification) {
        // 1、将通知中的数据转换成NSDictionary
        let dict = NSDictionary(dictionary: notification.userInfo!);
        // 2、获取键盘最后的Frame值
        let keyboardFrame = dict[UIKeyboardFrameEndUserInfoKey]!.CGRectValue();
        // 3、获取键盘移动值
        println("keyboardFrame.origin.y \(keyboardFrame.origin.y)")
        println("self.sendView!.bounds.height \(self.sendView!.bounds.height)")
        let ty = keyboardFrame.origin.y - view.frame.height;
        // 4、获取键盘弹出动画事件
        let duration = dict[UIKeyboardAnimationDurationUserInfoKey] as! Double;
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            self.sendView!.transform = CGAffineTransformMakeTranslation(0, ty);
            self.tableView?.transform = CGAffineTransformMakeTranslation(0, ty);
        });
        
        //        键盘弹出隐藏所执行的操作数据
        //        UIKeyboardAnimationCurveUserInfoKey = 7;
        //        UIKeyboardAnimationDurationUserInfoKey = "0.25";  键盘弹出/隐藏时动画时间
        //        UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
        //        UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
        //        UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
        //        UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
        //        UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.sendView!.resignFirstResponder()
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
            
            var width = self.view.frame.size.width
            var height = self.view.frame.size.height
            self.sendView?.frame = CGRectMake(0, height - 50 , width, 50)
            
            
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
