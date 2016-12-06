//
//  UIBarButtonItem+extension.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/16.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    ///便利构造函数
    /// - parameter title:    title
    /// - parameter fontSize: fontSize description
    /// - parameter frame:    frame
    /// - parameter target:   target
    /// - parameter action:   action
    ///isBack: Bool=false 是否是返回按钮如果是加上箭头
    /// - returns:
    convenience  init(title: String,fontSize: CGFloat=16,frame: CGRect,target: Any?,action : Selector,isBack: Bool=false) {
        let btn = UIButton();
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font=UIFont.systemFont(ofSize: fontSize)
        btn.frame=frame
        btn.addTarget(target, action:action, for: .touchUpInside)
        btn.setTitleColor(UIColor.orange, for: .normal)
     
        if isBack {
            btn.setImage(UIImage(named: "icon_back"), for: UIControlState(rawValue:0))
            btn.sizeToFit()
        }
//       self.init 实例化UIBarButtonItem
        self.init(customView: btn)
    }
    
    
}
