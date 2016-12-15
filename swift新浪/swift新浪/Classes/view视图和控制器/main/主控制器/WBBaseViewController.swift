//
//  WBBaseViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
//swift这种写法更加类似于多继承
//面试题：OC中支持多继承吗？如果不支持，如何替代？答案使用协议替代！
//class WBBaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
//所有主控制器的基类
//swift中，利用extention可以把函数按照功能分类管理，便于阅读和维护
//注意：
//1、extension中不能有属性
//2 extension中不能重写父类的方法！重写父类的方法，是子类的职责，扩展是对类的扩展
class WBBaseViewController: UIViewController{
//    用户登录标记
//    var userLogin = false
    
//    访客视图信息字典
    var vistorInfo :[String: String]?
    
    //表格视图
    var tableView: UITableView?
    
//    刷新控件 上拉刷新
    var refreshControl :UIRefreshControl?
//   上拉刷新标记
    var isPullUp = false
    
    //    自定义导航条
//    懒加载： 定义一个navigationbar，自定义导航条
//    lazy var  navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.caculateScreenWidth(), height: UIScreen.caculateHight()))

     lazy var  navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
    //自定义的导航条目,以后统一使用naviitem，而不要使用NavigationItem
    lazy var navItem = UINavigationItem()
    //重写viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.lightGray
        setUI()
        WBNetworkManager.shared.userLogin ?  loadData(): ()
        
//        注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WBUserShouldLoginSuccessNotification), object: nil)
        
    }
    
    deinit {
//        注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
//    重写title
    override var title: String?{
        didSet {
          navItem.title=title
        }
    }
//    加载数据，具体的实现由子类负责
    func loadData() {
//        如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }
    
    
}

//MARK:------------访客视图监听方法。用户登录和用户注册
extension WBBaseViewController{
    
    
    /// 登录成功后的处理
    @objc fileprivate func loginSuccess(n: Notification) {
        print("登录成功\(n)")
//        登录前左边是注册，右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        
        
//        更新UI将访客视图变成表格视图
//        需要重新设置view
//        在访问view的getter时，如果view==nil会调用viewdidload
        view=nil
        
        //  注销通知 -》重新执行viewdidload会再次注册，避免通知重复注册
        NotificationCenter.default.removeObserver(self)
    }
 
   @objc fileprivate func login() {
//    发送通知
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    
    @objc fileprivate func register() {
        print("用户注册")
    }
    
}

//MARK:------------设置界面
extension WBBaseViewController{
   fileprivate func setUI() {
//     取消自动缩进--如果隐藏了了导航栏会缩进20个点
      automaticallyAdjustsScrollViewInsets=false
//        简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可
      setNav()
        
//    表格视图和view根据用户登录与否进行设置，登录了设置成表格，没登录设置成视图
        WBNetworkManager.shared.userLogin ? setTableView():setUpVisitorView()
    
        
        
        
    }
    // 设置表格视图,用户登录后执行(子类重写此方法)
//    子类重写此方法：因为子类不需要关心用户登录之前的逻辑
    func setTableView() {
        tableView=UITableView(frame: view.bounds, style: .plain)
        tableView?.backgroundColor=UIColor.orange
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
//        设置数据源和代理，目的让子类实现数据源方法
        tableView?.delegate=self
        tableView?.dataSource=self
        
        
//        设置内容缩进,设置上面和底部的缩进，tabbar默认的高度是49
        tableView?.contentInset=UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
//        修改指示器的缩进  --强行解包是为了拿到一个必须的inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        
//        设置刷新控件
//        1.》刷新控件
        refreshControl=UIRefreshControl()
//        2.》添加到视图
        tableView?.addSubview(refreshControl!)
//        3.添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }
//   设置 访客视图
    func setUpVisitorView() {
//        1.设置访客视图信息
        let vistorView = WBVistorView(frame: view.bounds)
        view.insertSubview(vistorView, belowSubview: navigationBar)
        vistorView.vistitorInfo=vistorInfo
  
        
//使用代理传递消息就是为了在控制器和视图之间解耦，让视图能够别多个控制器复用，例如UItableview
//        但是如果视图仅仅只是为了封装代码，而从控制器中剥离开来的，并且能够确认该视图不会被其他控制器引用，则可以通过addtarget的方式为该视图中的按钮添加监听方法
//        这样做的代价是耦合度高，控制器和视图绑定在一起，但是会省略部分冗余代码
        
//   2.添加访客视图按钮的监听方法
//        点击登录按钮
        vistorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
//        点击注册按钮
        vistorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)

//        3.设置导航条按钮
        navItem.leftBarButtonItem=UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        
        navItem.rightBarButtonItem=UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))

    }
    
// 设置导航条
  fileprivate  func setNav() {
    //        添加导航条和导航条目
    //        把导航条添加到view
    view.addSubview(navigationBar)
    //        把导航条目item添加到导航条bar
    navigationBar.items=[navItem]
//        设置navigationBar的渲染的颜色,这里设置的是整个导航条的颜色
    navigationBar.barTintColor=UIColor.init(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)

    
    //        设置navibar的字体的颜色
    //         这种没有作用
    //    navigationBar.tintColor=UIColor.orange
    navigationBar.titleTextAttributes=[NSForegroundColorAttributeName: UIColor.orange]
    
    
    }
    
    
}
//MARK:------------delegate/dataSource
extension WBBaseViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

//基类只是准备方法，子类负责具体的实现
//    子类的数据源方法不需要super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        只是保证没有语法错误
        return UITableViewCell()
    }

//    将要显示cell
    
    ///在显示最后一行的时候做上拉刷新
    ///
    /// - parameter tableView: tableView description
    /// - parameter cell:      cell description
    /// - parameter indexPath: indexPath description
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
//        1.判断indexpath是否是最后一行
//        （indexpath.section/indexpath.row）
//        1.row,取出最大section的最大一行
        let row = indexPath.row
//        2.section
        let section = tableView.numberOfSections-1
        
        if row<0 || section<0   {
            return
        }
//        3.行数
        let count = tableView.numberOfRows(inSection: section)
        
//        如果是最后一行，同时没有开始上拉刷新
        if row==(count-1) && !isPullUp {
            print("上拉刷新")
            isPullUp=true
            loadData()
        }
//        print("row---------\(row)------count------\(count)")
//        print("section---------\(section)")

    }
//    显示cell结束
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

