//
//  WBNvcViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBNvcViewController: UINavigationController {

    
    /// navigationcontroller：负责跳转的；要避免系统的覆盖需要将原生的bar隐藏；有两种隐藏方式：一个支持手势返回，一个不支持；需要在每一个子控制器添加bar
    /// navigationbar：只有一个：bartintcolor整个条子的背景颜色；负责管理item；手势返回的时候，前后的导航条会覆盖
    /// navigationitem：管理条目；中间的标题：titleattributed；左右按钮；返回按钮
    /// uibarbuttonitem：具体的按钮；tintcolor
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        隐藏默认的UINavigationbar
        navigationBar.isHidden=true

    }

    //MARK: ------------    重写push方法
    
//    重写push方法，所有的push动作都会调用此方法
//    viewController是被push的控制器
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        如果不是栈底控制器则需要隐藏，根控制器不需要处理
        if childViewControllers.count>0 {
            viewController.hidesBottomBarWhenPushed=true
//        判断控制器的基类
        if let vc = viewController as? WBBaseViewController{
            var  title = "返回"
//            判断控制器的级数
            if childViewControllers.count==1 {
                title=childViewControllers.first?.title ?? "返回"
            }
            
//            取出自定义的naviitem作为返回按钮，设置左侧按钮作为返回按钮
        vc.navItem.leftBarButtonItem=UIBarButtonItem(title: title, fontSize: 16, frame: CGRect(x: 0, y: 0, width: 60, height: 40), target: self, action: #selector(popToViewControlller),isBack:true)
            
        }
        }
        super.pushViewController(viewController, animated: true)
    }
     //MARK: ------------返回到上一级的控制器
   @objc fileprivate func popToViewControlller() {
        popViewController(animated: true)
    }
    
    
    

}
