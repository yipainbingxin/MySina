//
//  WBComposeViewController.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/23.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

//撰写微博的控制器
class WBComposeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.lightGray

        
    navigationItem.leftBarButtonItem=UIBarButtonItem(title: "退出", frame: CGRect(x: 0, y: 0, width: 40, height: 40), target: self, action: #selector(close))
    }
    
    @objc fileprivate func close(){
        dismiss(animated: true, completion: nil)
    }
}
