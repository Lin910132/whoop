//
//  MyUITabBarController.swift
//  Whoop
//
//  Created by alidao3 on 15/4/9.
//  Copyright (c) 2015y Li Jiatan. All rights reserved.
//

import UIKit
import Foundation

class MyUITabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.applicationTabBarColor();
        self.tabBar.barTintColor=UIColor.applicationTabBarColor();
        self.tabBar.tintColor=UIColor.applicationTabBarColor();
        self.tabBar.selectedImageTintColor = UIColor.applicationMainColor();
        self.configTabBar();
    }
    
    func configTabBar() {
        let items = self.tabBar.items
        for item in items as! [UITabBarItem] {
            let dic = NSDictionary(object: UIColor.applicationMainColor(),
                forKey:   NSForegroundColorAttributeName)
            item.setTitleTextAttributes(dic as [NSObject : AnyObject],forState: UIControlState.Selected)
        }
    }
    
}