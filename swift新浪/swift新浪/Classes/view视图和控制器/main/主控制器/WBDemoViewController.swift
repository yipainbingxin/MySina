//
//  WBDemoViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/15.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        计算有多少个视图控制器
        title="第 \(navigationController?.childViewControllers.count ?? 0)个"
    }
    //MARK :----------------进入到下一个界面
    //继续push到下一个界面
  @objc fileprivate  func showNext() {
    let vc = WBDemoViewController()
    navigationController?.pushViewController(vc, animated: true)
    
    
    
    }
}
extension WBDemoViewController{
        override func setTableView() {
        super.setTableView()
        //        navigationItem ，这个是系统的,navItem，这个是自定义的

        navItem.rightBarButtonItem=UIBarButtonItem(title: "下一个", fontSize: 16, frame:CGRect(x: 0, y: 0, width: 60, height: 40), target: self, action: #selector(showNext))

    }
   
}
