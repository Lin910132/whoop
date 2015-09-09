//
//  YRNewPostViewController.swift
//  Whoops
//
//  Created by huangyao on 15-2-26.
//  Copyright (c) 2015y Li Jiatan. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation



class YRNewPostViewController: UIViewController, UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,DKImagePickerControllerDelegate{
    
    
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var sendItem: UIBarButtonItem!
    
    @IBOutlet weak var nickName: UITextField!
    
    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var countWordLabel: UILabel!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    
    let placeHolder = "Write something"
    let locationManager = CLLocationManager()
    
    
    @IBOutlet var toolViewHeighContraint: NSLayoutConstraint!
    var imgView = UIImageView()
    var imgList = [UIImageView]()
    var img = UIImage()
    
    var schoolId:String = "0"
    var schoolName = String()
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    let MAX_WORD_COUNT = 100
    
    var universityView:UniversityViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nickNameText.textColor = UIColor.blackColor()
        imgView.frame = CGRectMake(100, 240, 100, 100)
        self.view.addSubview(imgView)
        
        self.schoolId = SchoolObject.result
        
        contentTextView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.contentTextView.text = placeHolder
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    func transmitSchoolId(schoolId:String){
        self.schoolId = schoolId
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        if (location.horizontalAccuracy > 0) {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            self.locationManager.stopUpdatingLocation()
            println(location.coordinate)
            
            println("latitude \(location.coordinate.latitude) longitude \(location.coordinate.longitude)")
        }
    }
    
    
    
    
    @IBAction func photoButtonClick(sender: AnyObject) {
        var actionSheet = UIActionSheet()
        //        actionSheet.addButtonWithTitle("取消")
        //        actionSheet.addButtonWithTitle("打开照相机")
        //        actionSheet.addButtonWithTitle("从手机相册选择")
        if imgList.count >= 6 {
            UIView.showAlertView("Warning",message:"The max count of photos can not be more than 6")
            return
        }
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Camera")
        actionSheet.addButtonWithTitle("Photo Library")
        actionSheet.cancelButtonIndex = 0
        actionSheet.delegate = self
        
        actionSheet.showInView(self.view)
        
        
        
    }
    
    @IBAction func sendButtonClick(sender: AnyObject) {
        var content:String = contentTextView!.text
        
        if count(content) == 0 || content == placeHolder {
            UIView.showAlertView("Warning",message:"The Content should not be empty")
            return
        }else{
            if imgList.count == 0 {
                createNewPost()
            }else{
                postWithPic()
            }
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    //    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("tabBarId") as! UIViewController
    //    self.presentViewController(vc, animated: true, completion: nil)

        if self.schoolId == "0"{
            //let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("tabBarId") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            //let anotherView:UniversityViewController = mainStoryboard.instantiateViewControllerWithIdentifier("university") as! UniversityViewController
            //anotherView.schoolId = self.schoolId
            //anotherView.currentUniversity = self.schoolName
            //self.presentViewController(anotherView, animated: true, completion: nil)
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if self.schoolId == "0"{
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("tabBarId") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var sourceType = UIImagePickerControllerSourceType.Camera
        if buttonIndex == actionSheet.cancelButtonIndex {
            return
        }else if buttonIndex == 1{
            sourceType = UIImagePickerControllerSourceType.Camera
            
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true//设置可编辑
            picker.sourceType = sourceType
            
            self.presentViewController(picker, animated: true, completion: nil)//进入照相界面

        }else{
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            let pickerController = DKImagePickerController()
            pickerController.pickerDelegate = self
            self.presentViewController(pickerController, animated: true) {}
        }
        
    }
    
    // MARK: - DKImagePickerControllerDelegate methods
    // 取消时的回调
    func imagePickerControllerCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 选择图片并确定后的回调
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!) {
//        imageScrollView.subviews.map(){$0.removeFromSuperview}
//        
//        for (index, asset) in enumerate(assets) {
//            let imageHeight: CGFloat = imageScrollView.bounds.height / 2
//            
//
//            imageView.contentMode = UIViewContentMode.ScaleAspectFit
//            imageView.frame = CGRect(x: 0, y: CGFloat(index) * imageHeight, width: imageScrollView.bounds.width, height: imageHeight)
//            imageScrollView.addSubview(imageView)
//            
//        }
//        imageScrollView.contentSize.height = CGRectGetMaxY((imageScrollView.subviews.last as! UIView).frame)
//        
     
        
        for (index, asset) in enumerate(assets) {

            let imgView = UIImageView(image: asset.fullScreenImage)
            
            imgView.userInteractionEnabled = true
            imgView.tag = imgList.count
            
            var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
            imgView.addGestureRecognizer(tap)

            if imgList.count < 6 {
                imgList.append(imgView)
                var width = self.view.frame.size.width
                var height = self.view.frame.size.height
                var imgWidth = (width - 10 - 10 - 20)/3
                if imgList.count <= 3 {
                    var tempWidth = 10 * imgList.count + (imgList.count-1) * Int(imgWidth)
                    imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  - imgWidth, imgWidth, imgWidth)
                    self.view.addSubview(imgView)
                    //                toolView.frame = CGRectMake(0, height/2+200, width-300, 62)
                    toolViewHeighContraint.setValue(30 + imgWidth, forKey: "Constant")
                }else{
                    var tempWidth = 10 * (imgList.count-3) + (imgList.count-4) * Int(imgWidth)
                    imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  + 10, imgWidth, imgWidth)
                    self.view.addSubview(imgView)
                    toolViewHeighContraint.setValue(40 + imgWidth * 2, forKey: "Constant")
                    
                }
                
            }
            
        }
        
        //显示添加图片的按钮
        if imgList.count < 6 {
            let imgView = UIImageView(image: UIImage(named: "Icon_128x128px.png"))
            imgView.userInteractionEnabled = true
            imgView.tag = imgList.count
            
            var tap = UITapGestureRecognizer(target: self, action: "addPhotoButtonClick:")
            imgView.addGestureRecognizer(tap)


            imgList.append(imgView)
            var width = self.view.frame.size.width
            var height = self.view.frame.size.height
            var imgWidth = (width - 10 - 10 - 20)/3
            if imgList.count <= 3 {
                var tempWidth = 10 * imgList.count + (imgList.count-1) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  - imgWidth, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                //                toolView.frame = CGRectMake(0, height/2+200, width-300, 62)
                toolViewHeighContraint.setValue(30 + imgWidth, forKey: "Constant")
            }else{
                var tempWidth = 10 * (imgList.count-3) + (imgList.count-4) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  + 10, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                toolViewHeighContraint.setValue(40 + imgWidth * 2, forKey: "Constant")
                
            }
            imgList.removeLast()

        }
        
        
//        picker.dismissViewControllerAnimated(true, completion: nil)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addPhotoButtonClick(sender:UITapGestureRecognizer) {
        var actionSheet = UIActionSheet()
        //        actionSheet.addButtonWithTitle("取消")
        //        actionSheet.addButtonWithTitle("打开照相机")
        //        actionSheet.addButtonWithTitle("从手机相册选择")
        if imgList.count >= 6 {
            UIView.showAlertView("Warning",message:"The max count of photos can not be more than 6")
            return
        }
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Camera")
        actionSheet.addButtonWithTitle("Photo Library")
        actionSheet.cancelButtonIndex = 0
        actionSheet.delegate = self
        
        actionSheet.showInView(self.view)
        
        
        
    }

    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        var imgView = UIImageView()
        imgView.userInteractionEnabled = true
        imgView.tag = imgList.count
//        var deleteTap = UILongPressGestureRecognizer(target: self, action: "deleteImageViewTapped:")
//        //        deleteTap.numberOfTapsRequired = 1
//        imgView.addGestureRecognizer(deleteTap)
        
        var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
        imgView.addGestureRecognizer(tap)
        
        
        
        imgView.image = img
        if imgList.count < 6 {
            imgList.append(imgView)
            var width = self.view.frame.size.width
            var height = self.view.frame.size.height
            var imgWidth = (width - 10 - 10 - 20)/3
            if imgList.count <= 3 {
                var tempWidth = 10 * imgList.count + (imgList.count-1) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  - imgWidth, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                //                toolView.frame = CGRectMake(0, height/2+200, width-300, 62)
                toolViewHeighContraint.setValue(30 + imgWidth, forKey: "Constant")
            }else{
                var tempWidth = 10 * (imgList.count-3) + (imgList.count-4) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  + 10, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                toolViewHeighContraint.setValue(40 + imgWidth * 2, forKey: "Constant")
                
            }
            
        }
        //显示添加图片的按钮
        if imgList.count < 6 {
            let imgView = UIImageView(image: UIImage(named: "Icon_128x128px.png"))
            imgView.userInteractionEnabled = true
            imgView.tag = imgList.count
            
            var tap = UITapGestureRecognizer(target: self, action: "addPhotoButtonClick:")
            imgView.addGestureRecognizer(tap)
            
            
            imgList.append(imgView)
            var width = self.view.frame.size.width
            var height = self.view.frame.size.height
            var imgWidth = (width - 10 - 10 - 20)/3
            if imgList.count <= 3 {
                var tempWidth = 10 * imgList.count + (imgList.count-1) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  - imgWidth, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                //                toolView.frame = CGRectMake(0, height/2+200, width-300, 62)
                toolViewHeighContraint.setValue(30 + imgWidth, forKey: "Constant")
            }else{
                var tempWidth = 10 * (imgList.count-3) + (imgList.count-4) * Int(imgWidth)
                imgView.frame = CGRectMake(CGFloat(tempWidth), height/2  + 10, imgWidth, imgWidth)
                self.view.addSubview(imgView)
                toolViewHeighContraint.setValue(40 + imgWidth * 2, forKey: "Constant")
                
            }
            imgList.removeLast()
            
        }

        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        var formerWordcount = count(textView.text)
        var addWordCount = count(text)
        if formerWordcount + addWordCount <= MAX_WORD_COUNT{
            self.countWordLabel.text = String(MAX_WORD_COUNT - formerWordcount - addWordCount)
            return true
        }else{
            return false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if count(self.contentTextView.text) < 1 {
            self.contentTextView.text = placeHolder
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if self.contentTextView.text == placeHolder{
            self.contentTextView.text = ""
        }
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
    
    func deleteImageViewTapped(sender:UITapGestureRecognizer){
        var i:Int = sender.view!.tag
        if self.imgList.count == 0 || self.imgList.count < i {
            return
        }
        var imageView = self.imgList[i]
        self.imgList.removeAtIndex(i)
        imageView.removeFromSuperview()
    }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    func updateLocation(latitude:Double, longitude:Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createNewPost(){
        var content = contentTextView.text;
        var url = FileUtility.getUrlDomain() + "post/addNoPic?"
        var paraData = "content=\(content)"
        var nickName:String = nickNameText.text
        if count(nickName) > 0{
            paraData += "&nickName=\(nickName)"
        }
        
        if schoolId == "0" {
            paraData += "&latitude=\(latitude)&longitude=\(longitude)"
        }else{
            paraData += "&latitude=\(latitude)&longitude=\(longitude)"
            paraData += "&schoolId=\(schoolId)"
        }
        
        paraData += "&uid=\(FileUtility.getUserId())"
        
        var data:NSMutableArray = YRHttpRequest.postWithURL(urlString: url, paramData: paraData)
        
    }
    func postWithPic(){
        var content = contentTextView.text;
        var nickName:String = nickNameText.text
        var request = createRequest(content: content, nickName: nickName)
        NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        
        //        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
        //            data, response, error in
        //
        //            if error != nil {
        //                // handle error here
        //                return
        //            }
        //
        //            // if response was JSON, then parse it
        //
        //            var parseError: NSError?
        //            let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
        //
        //            if let responseDictionary = responseObject as? NSDictionary {
        //                // handle the parsed dictionary here
        //            } else {
        //                // handle parsing error here
        //            }
        //
        //            // if response was text or html, then just convert it to a string
        //            //
        //            // let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        //            // println("responseString = \(responseString)")
        //
        //            // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
        //            //
        //            // dispatch_async(dispatch_get_main_queue()) {
        //            //     // update your UI and model objects here
        //            // }
        //        })
        //        task.resume()
        
    }
    
    func createRequest (#content: String, nickName: String) -> NSURLRequest {
        var param = [
            "content"  : content,
            "nickName" : nickName,
            "uid" : FileUtility.getUserId()
        ]  // build your dictionary however appropriate
        if schoolId == "0" {
            param["latitude"] = toString(self.latitude)
            param["longitude"] = toString(self.longitude)
        }else{
            param["latitude"] = toString(self.latitude)
            param["longitude"] = toString(self.longitude)
            param["schoolId"] = toString(self.schoolId)
        }
        
        let boundary = generateBoundaryString()
        
        let url:String = FileUtility.getUrlDomain() + "post/add?"
        //        let url:String = "http://192.168.1.4:8080/whoops/" + "post/add?"
        let nsurl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsurl!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //        let path1 = NSBundle.mainBundle().pathForResource("image1", ofType: "png") as String!
        //        let path2 = NSBundle.mainBundle().pathForResource("image2", ofType: "jpg") as String!
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// :param: parameters   The optional dictionary containing keys and values to be passed to web service
    /// :param: filePathKey  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// :param: paths        The optional array of file paths of the files to be uploaded
    /// :param: boundary     The multipart/form-data boundary
    ///
    /// :returns:            The NSData of the body of the request
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        //        if paths != nil {
        //            for path in paths! {
        let filename = "file"
        for img in imgList {
            let data:NSData = UIImageJPEGRepresentation(img.image, 0.3)
            
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: application/octet-stream\r\n\r\n")
            body.appendData(data)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// :returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// :param: path         The path of the file for which we are going to determine the mime type.
    ///
    /// :returns:            Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as NSString as String
            }
        }
        return "application/octet-stream";
    }
    
    
    func uploadImageOne(){
        var imageData = UIImageJPEGRepresentation(imgView.image, 0.3)
        
        if imageData != nil{
            var url:String = FileUtility.getUrlDomain() + "post/add?"
            var nsurl = NSURL(string: url)
            var request = NSMutableURLRequest(URL:nsurl!)
            request.HTTPMethod = "POST"
            
            var bodyData = "content="+contentTextView.text
            
            
            //            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            //            request.HTTPBody = NSData(data: UIImagePNGRepresentation(imgView.image))
            //            println("miraqui \(request.debugDescription)")
            //            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            //            var HTTPError: NSError? = nil
            //            var JSONError: NSError? = nil
            //
            //            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            //                data, response, error in
            //
            //                if error != nil {
            //                    // handle error here
            //                    return
            //                }
            //
            //                // if response was JSON, then parse it
            //
            //                var parseError: NSError?
            //                let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
            //
            //                if let responseDictionary = responseObject as? NSDictionary {
            //                    // handle the parsed dictionary here
            //                } else {
            //                    // handle parsing error here
            //                }
            //
            //                // if response was text or html, then just convert it to a string
            //                //
            //                // let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            //                // println("responseString = \(responseString)")
            //
            //                // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
            //                //
            //                // dispatch_async(dispatch_get_main_queue()) {
            //                //     // update your UI and model objects here
            //                // }
            //            })
            //            task.resume()
            
            //            var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &HTTPError)
            //
            //            if ((dataVal != nil) && (HTTPError == nil)) {
            //                var jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &JSONError)
            //
            //                if (JSONError != nil) {
            //                    println("Bad JSON")
            //                } else {
            //                    println("Synchronous\(jsonResult)")
            //                }
            //            } else if (HTTPError != nil) {
            //                println("Request failed")
            //            } else {
            //                println("No Data returned")
            //            }
            
            //            var url:String = FileUtility.getUrlDomain() + "post/add?content=\(contentTextView.text)"
            //            var nsurl = NSURL(fileURLWithPath: url)
            //            var request = NSMutableURLRequest(URL: nsurl!)
            var session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            
            var boundary = NSString(format: "---------------------------14737809831466499882746641449")
            var contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData.alloc()
            
            // Title
            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: imageData, completionHandler: {data, response, error -> Void in
                
                println(request)
                println(response)
                // println(payload)
                
            })
            task.resume()
            
            //            var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            //
            //            if returnData != nil{
            //                var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
            //
            //                println("returnString \(returnString)")
            //            }
        }
        
        
    }
    
    
    
}