//
//  LikeViewController.swift
//  Whoop
//
//  Created by Li Jiatan on 4/16/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let identifier = "likeViewCell"
    var _db = NSMutableArray()
    var uid = String()
    var page: Int = 1

    @IBOutlet weak var likeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uid = FileUtility.getUserId()
        
        var nib = UINib(nibName:"LikeViewCell", bundle: nil)
        self.likeTableView.registerNib(nib, forCellReuseIdentifier: identifier)
        
        load_Data()
        // Do any additional setup after loading the view.
    }
    
    func load_Data(){
        var url = FileUtility.getUrlDomain() + "msg/getMsgByUId?uid=\(self.uid)&pageNum=\(self.page)"
        //var url = "http://104.131.91.181:8080/whoops/msg/getMsgByUId?uid=97&pageNum=1"
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as! NSArray
            
            for data : AnyObject  in arr
            {
                self._db.addObject(data)
            }
            self.likeTableView.reloadData()
            // self.refreshView!.stopLoading()
            self.page++
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._db.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? LikeViewCell
        var index = indexPath.row
        cell?.data = _db[index] as! NSDictionary
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = indexPath.row
        var data = self._db[index] as! NSDictionary
        var commentsVC = YRCommentsViewController(nibName :nil, bundle: nil)
        commentsVC.jokeId = data.stringAttributeForKey("id")
        commentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var index = indexPath.row
        var data = self._db[index] as! NSDictionary
        return  LikeViewCell.cellHeightByData(data)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
