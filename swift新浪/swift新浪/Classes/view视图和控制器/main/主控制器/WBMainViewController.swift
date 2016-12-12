//
//  WBMainViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import SVProgressHUD
class WBMainViewController: UITabBarController {
//定时器
    fileprivate var timer: Timer?
    
    
    //主控制器
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
       setUpChildControllers()
       setUpComposeButton()
        
        setUpTimer()
        
        setUpNewFeatureView();
        
        
//        设置代理
        delegate=self
//        注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
        
    }
    
    
    // MARK:=------------J监听方法，用户登录
   @objc fileprivate func userLogin(n:Notification) {
     print("\(n)")
    
//    判断N的object是否有值，如果有值，提示用户重新登录
    var when = DispatchTime.now()
    
    if n.object != nil {
//    设置指示器的渐变样式
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.showInfo(withStatus: "用户登录已超时，请重新登录")
        
        
        when=DispatchTime.now()+2
    }
    
    DispatchQueue.main.asyncAfter(deadline: when) {
        //    展现登录的控制器---通常会和UInavicontroller连用，方便返回
        SVProgressHUD.setDefaultMaskType(.clear)
        let  vc = WBQAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)

    }
    
    
    }
    
    deinit {
//        销毁时钟
        timer?.invalidate()
//        注销通知
        NotificationCenter.default.removeObserver(self)
        
        
    }
//    MARK:----------------监听方法,
    
 @objc fileprivate func composeStatus() {
        print("撰写微博")
    let vc = UIViewController()
    vc.view.backgroundColor=UIColor.lightGray
    let nav = UINavigationController(rootViewController: vc)
    
    self .present(nav, animated: true, completion: nil)
    

    }
  
    
//    MARK:----------------私有控件
//    撰写按钮
  fileprivate  lazy var composeButton:UIButton = UIButton()
}



// MARK: - -------新特性视图处理
extension WBMainViewController{
//    设置新特性视图
   fileprivate  func setUpNewFeatureView() {
    //   判断是否登录
//    if  WBNetworkManager.shared.userLogin{
//        return
//    }
    
    
//    1.j检查版本是否更新
//    2.如果更新，显示新特性，否则显示欢迎
//    3.添加视图
    let v = isNewVersiong ? WBFeatureView() :WBWelcomeView.welcomeView()
//    v.frame=view.bounds
//    添加视图
    view.addSubview(v)
    
        
    }
    
    
  ///extenstion中可以有计算型属性，不会占用内存空间
//    构造函数给属性分配空间
//    在AppStore每次升级应用程序，版本号都需要增加，不能递减
//    在组成主版本号，次版本号，修订版本号
//    主版本号：意味着大的修改，使用者需要大的适应
//    此版本号：意味着晓得修改，某些函数和方法的使用或者参数的变化
//    修订版本号：框架/程序内部bug的修订，不会对使用者造成任何的影响
  fileprivate var isNewVersiong : Bool{
//    1.取当前的版本号1.0.1
    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    print(currentVersion)
    
//    2.取保存在document（iTunes备份）最理想保存在用户偏好设置，目录中之前的版本号
    let path: String = ("version" as NSString).cz_appendDocumentDir()
    let sandBoxVersion = (try? String(contentsOfFile: path)) ?? ""
    print(sandBoxVersion)
//    3.将当前版本号保存在沙盒
   _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
//    4.返回两个版本号是否一致   no   new
    print(path)
    return currentVersion != sandBoxVersion
    }
    
    
    
}

// MARK: - UITabBarControllerDelegate tabbar的代理方法
extension WBMainViewController:UITabBarControllerDelegate{
    
    /// 将要选择的tabbaritem
    ///
    /// - parameter tabBarController: tabBarController description
    /// - parameter viewController:   目标控制器
    /// - returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//       1.获取控制器在数组中的索引
        let idx = (childViewControllers as  NSArray).index(of: viewController)
//       2.判断当前索引是首页。同时inx也是首页，重复点击首页的按钮
        if selectedIndex == 0 && idx == selectedIndex {
            print("点击首页")
//            3.让表格滚动到首页
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
//        滑动到底部
//            刷新表格
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                vc.loadData()
            })
            vc.tableView?.setContentOffset(CGPoint(x:0,y:-64), animated: true)

            
            
        }
        
        print("将要切换到\(viewController)")
//        判断目标控制器是否是viewController
        return !viewController.isMember(of: UIViewController.self)

    }
    
    
}


extension WBMainViewController{
   fileprivate func setUpTimer() {
    
//    时间间隔建议写长一些
    timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
    }
    
//    MARK: 时钟撰写方法
   @objc fileprivate func updateTimer() {
    //    根据有没有登录开不开时钟,没有登录就直接返回
    if !WBNetworkManager.shared.userLogin {
        return
    }
//    测试微博的未读数量
    WBNetworkManager.shared.unReadCout { (count) in
        
//        设置app的badnumber,从iOS8之后需要用户授权才能接收到
        UIApplication.shared.applicationIconBadgeNumber = count
        self.tabBar.items?[0].badgeValue = "\(count)"

    }
//    UIApplication.shared.applicationIconBadgeNumber = count
    }
    
}

//    extension类似于OC的分类，还可以用来切分代码块，可以把相近的函数，放入一个extention中，便于代码维护
//    注意：和OC的extention一样只能定义方法不能定义属性

//MARK : ----------------设置界面
extension WBMainViewController{
//    设置撰写按钮
  fileprivate  func setUpComposeButton() {
    composeButton.backgroundColor=UIColor.blue
    composeButton.setTitleColor(UIColor.orange, for: UIControlState(rawValue: 0))
    composeButton.setTitle("+", for: UIControlState(rawValue: 0))
    composeButton.titleLabel?.font=UIFont.systemFont(ofSize: 40)
//       设置按钮的位置
//Use of unresolved identifier 'composeStatus'
    composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
     let cout = CGFloat(childViewControllers.count)
        
//        这里类似与OC的cgrectInsert,正数向内缩进，负数向外扩展
//        容错点：两个按钮之间会有间隙，用手点击不会出错，但是鼠标比较精确
//        将向内缩进的宽度减少，能够让按钮的宽度变大
        let width = tabBar.bounds.width/cout-1
        composeButton.frame=tabBar.bounds.insetBy(dx: 2*width, dy:-20)
        composeButton.layer.cornerRadius=width/5
        composeButton.clipsToBounds=true
        tabBar.addSubview(composeButton)
        
        
    }
    
    
    //设置所有的主控制器
 fileprivate  func setUpChildControllers() {
//    0.获取沙盒的json路径
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let jsonPath = (docDir as String).appending("main.json")
//    加载data
    var data = NSData(contentsOfFile: jsonPath)
//    判断data中是否有内容，如果没有说明本地沙盒没有文件
    if data == nil {
//        从bundle中加载data
      let path = Bundle.main.path(forResource: "main.json", ofType: nil)
      data = NSData(contentsOfFile: path!)
    }
    
//    data一定会有内容进行反序列化
    
    
    
    
//    从bundle中加载配置的json
//    1.路径
//    2.加载nsdata
//    3.反序列化转化成数组
//    guard let  path = Bundle.main.path(forResource: "main.json", ofType: nil),let data = NSData(contentsOfFile: path),
//        let arry = try? JSONSerialization.jsonObject(with: data as Data , options: []) as? [[String:Any]] else {
//
//        return
//    }
//    
    guard let arry = try? JSONSerialization.jsonObject(with: data as! Data , options: []) as? [[String:Any]] else {

            return
    }
    
    
//    遍历数组，循环创建控制器数组
        var arryClass = [UIViewController]()
        for dict in arry! {
            arryClass.append(controllers(dict: dict))
        }
//    设置tabbar的子控制器
        viewControllers=arryClass
        
    }
//    使用字典创建一个字控制器
//   para： dict[类名，名字，图片,选中图片，字典信息]
//    UIViewController 返回的子控制器
    func  controllers(dict: [String: Any])->UIViewController{

//        1.取得字符串内容
        guard let clasName = dict["clasName"] as? String,
        let title = dict["title"] as? String,
        let imageNormal = dict["imageNormal"] as? String,
        let imageSelect = dict["imageSelect"] as? String,
//       字典信息
        let  vistorInfo = dict["vistorInfo"] as? [String: String],
        

        let clas = NSClassFromString(Bundle.main.nameSpace+"."+clasName) as? WBBaseViewController.Type
        else {
            return UIViewController()
        }
//        2.创建视图控制器
//        将以上的转换成class
        let vc = clas.init()
        vc.title=title
//        3.设置图像
        vc.tabBarItem.image=UIImage(named: imageNormal)
//        给图片添加渲染
        vc.tabBarItem.selectedImage=UIImage(named: imageSelect)?.withRenderingMode(.alwaysOriginal)
//        4.设置字体的颜色和大小
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.red], for: .highlighted)
        
        
        
//        5.设置控制器的访客信息字典
        vc.vistorInfo=vistorInfo
//      系统默认的是12号字体，修改字体要设置normal，设置高亮是没有作用的
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 15)], for: UIControlState(rawValue: 0))

        let nav = WBNvcViewController(rootViewController: vc)
        return nav
    
    }

}






