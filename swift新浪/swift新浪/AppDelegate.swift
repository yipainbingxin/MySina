//
//  AppDelegate.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/28.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                setUpAddionts()

        
        
        sleep(2)
        window=UIWindow()
        window?.backgroundColor=UIColor.red
        window?.rootViewController=WBMainViewController()
        window?.makeKeyAndVisible()
        
        
        
        loadAppData()
        return true
    }
    
    
    
    //    appdelegate:网络
    //    1.获取之后，保存到沙盒
    //    2.下一次运行时使用
    //    3.不需要回调
    
    //    mainviewcontroller：
    //    加载main.json---bundle里面是固定的，不会变化；程序第一次运行需要快速显示第一个界     面给用户
    //    有数据后设置控制器
}


// MARK: - 设置应用程序额外信息
extension AppDelegate{
   fileprivate func setUpAddionts() {
//    1.设置SVProgressHUD最小的解除时间
    SVProgressHUD.setMinimumDismissTimeInterval(1)
//2.设置网络加载指示器
    AFNetworkActivityIndicatorManager.shared().isEnabled=true
    
    
//    3.设置用户授权显示通知
    //        询问用户是否授权
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (isSuccess, error) in
            
            let str  = isSuccess ? "成功" : "失败"
            print(str)
        }
    } else {
        // Fallback on earlier versions
        //        取消用户授权显示通知（上面的提示条、声音、badgeNumber）
        let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notifySettings)
        
        
    }
    
    

    }
    
    
}
//MARK: 从服务器 加载应用程序信息
extension AppDelegate{
    
    /// appdelegate
    //    mainviewcontroller
    
    //    basecontroller：设置导航条，解决铺设隐藏底部bar；解决NAVBbar的重叠；用户是否登录
    //  1.  登录的话设置表格视图--设置数据源和代理，
    //    实现空的数据源方法：0行，和uitableviewcell;
    //    添加refreshcontroll:实现下拉刷新；init；[tableview addsubview];[addtarget:loadData]
    //    实现将要显示cell的代理方法：是否是最后分组的最后一行;设置isPullUp;loadData实现上拉刷新；实现下拉刷新
    //  2.未登录的话：设置访客视图，实例话访客视图；设置访客视图的字典，从main.json中加载而来；访客视图内部didset
    //    tiplable.text=message,判断imagename==nil表示首页,启动动画；不为空的话更新iconview，隐藏另外两张视图
    
    
    func loadAppData() {
        //        1.模拟异步
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            //        2.data
            let data = NSData(contentsOf: url!)
            //        3.写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as String).appending("main.json")
            data?.write(toFile: jsonPath , atomically: true)
            
            print("应用程序加载完毕\(jsonPath)")
            
        }
    }
    
    
    
    
//    WBNetworkManager:requet  ---------封装AFN的GET、POST
//    1.隔离afn
//    2.post/get完成回调一样的
 
//    accessToken属性  ---------所有的新浪微博的数据请求，都需要token（登录除外）
    
//    tokenRequest:负责处理token字典，简化其他的网络方法

//    WBNetworkManager+extension.swift：   封装新浪微博的网络请求方法；注意力在回调的类型上；不用关心网络实现的细节
    
//    1.抽取单利
//    2.请求的token隔离出来
}


//登录成功后需要的一些操作
//token失效的处理：将两个fixme发送通知 ：token ==nil 发送通知不带对象
//网络请求statecode=403： 发送通知携带对象，对象本身没有意义，用于判断是否显示窗口

//WBMainViewController 通知监听方法：判断通知是否有对象，如果有对象设置SVProgressHUD的样式
//设置延迟时间，如果没有对象，直接展现登录控制器
//1.导航栏左右按钮、注册按钮的清除
//2.表格视图的指示器的缩进
//3.SVProgressHUD解除时长
//4.AFN指示器的显示

//FIXME:-----------微博的首页
//微博的首页：xib的自动布局、图像的性能优化：模拟器的使用技巧、视图模型的使用:重点理解原创微博中视图模型的理解


