//
//  MyRepliesViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 3/8/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class MyRepliesViewController: UITableViewController, YRRefreshViewDelegate {
    
    let identifier = "cell"
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Replies"
        setupViews()
        loadData()
    }
    
    func setupViews()
    {
        var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: identifier)
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView!.delegate = self
        self.tableView.tableFooterView = self.refreshView
        addRefreshControll()
    }
    
    func addRefreshControll()
    {
        var fresh:UIRefreshControl = UIRefreshControl()
        fresh.addTarget(self, action: "actionRefreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        fresh.tintColor = UIColor.whiteColor()
        self.tableView.addSubview(fresh)
    }
    
    func actionRefreshHandler(sender: UIRefreshControl)
    {
        //page = 1
        var url = "http://104.131.91.181:8080/whoops/post/listByCommentAndUid?uid=\(self.uid)&pageNum=1"
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Opps",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as! NSArray
            
            self.dataArray = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
                
            }
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            
            sender.endRefreshing()
        })
    }
    
    func loadData()
    {
        var url = urlString()
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Opps",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as! NSArray
            
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            self.page++
        })
        
    }
    
    func urlString()->String
    {
        //return "http://m2.qiushibaike.com/article/list/latest?count=20&page=\(page)"
        self.uid = FileUtility.getUserId()
        return "http://104.131.91.181:8080/whoops/post/listByCommentAndUid?uid=\(self.uid)&pageNum=\(page)"
    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData()
    }

    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageViewTapped", object:nil)
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageViewTapped:", name: "imageViewTapped", object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YRJokeCell
        var index = indexPath.row
        cell.data = self.dataArray[index] as! NSDictionary
       // cell.textLabel?.text = self.dataArray[index]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        var commentsVC = YRCommentsViewController(nibName :nil, bundle: nil)
        commentsVC.jokeId = data.stringAttributeForKey("id")
        commentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        return  YRJokeCell.cellHeightByData(data)
    }

    func imageViewTapped(noti:NSNotification)
    {
        
        var imageURL = noti.object as! String
        var imgVC = YRImageViewController(nibName: nil, bundle: nil)
        imgVC.imageURL = imageURL
        self.navigationController?.pushViewController(imgVC, animated: true)
    }
        
}
