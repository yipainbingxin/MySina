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

//FIXME:-----------代码评审（code review）
//1.code review在大公司比较流行
//2.相对于创业团队中以产品为驱动的开发过程，代码审查觉得比较重要了
//3.code review在一定的程度上可以避免一些bug的楚翔，以及大幅度提升个人的编码效率
//4.code review有一套科学的管理机制，使工作流程固定化

//代码评审工具 --phabricator
//phabricator 是Facebook开源的一套框架
//它集成了bug跟踪，内部工作交流，版本控制管理，wiki，code review等功能


//客户端---》评审系统----》》git或者SVN
//code review的意识：
//1.作为一个developer，不仅要提交可工作的代码（deliver working COD）
//更重要提交可维护的代码
//2.必要的时候进行重构，随着项目的迭代，在计划新功能的同时，开发要主动计划重构的工作项
//3.开放的心态，虚心接受大家的评审建议（review comments）



//作为评审的方式：
//1.开code review会议
//2.团队内部会整理check list
//3.团队内部成员交换代码
//4.找出可优化的方案
//5.多问问题，例如这块怎么处理的
//6.区分重点，抓住设计，可读性，健壮性等重点问题
//7.整理好的代码实战，用来作为code review的参考

//评审内容
//架构、设计
//1.单一职责原则：这是经常被违背的原则，一个类只能干一件事情，比较常见的是一个类既干UI的事情，又干
//逻辑的事情这个在低质量的客户端的代码很常见


//MARK:------WBStatusNormalCell.xib
//发现问题：，没有微博的用户数据
//1.创建WBuser模型
//2.在WBuser模型中增加user属性
//3.cmd+R字典转模型已经OK
//4.增加WBStatusViewModel 单独处理一条微博的所有业务逻辑
//5.修改WBStatusListViewModel中字典转模型的方法
//6.在控制器中设置username

//下午的步骤：
//1.在cell中添加视图模型上属性，从控制器给cell设置视图模型
//2.会员图标
//3.认证图标
//4.设置用户头像：隔离sdwebimage方法、增加了是否头像的选型（自动增加圆角半径，增加实现）
//5.底部工具栏：如果一些xib很复杂、可以根据一些特定的业务逻辑，定义一些视图、避免所有的的代码都写在一个cell中利用视图模型，计算底部工具栏显示的内容
//6.配图视图：自动布局，测试修改配图视图的高度，影响行高；在视图模型中，定义配图视图尺寸的属性，配图视图的尺寸修改，进一步测试行高；定义WBStatusPicture这个视图模型：（modelContainerPropertyGenericClass从YYmodel的官方网站查询；解决的问题：字典转模型的时候，如果遇到nsaryy类型，OC中默认的都是id类型而用用运行时同样无法判断其中应该保存什么类型的对象；通过一个映射字典，告诉第三方框架，picurls数组中应该保存WBStatusPicture类的对象；根绝配图URL数量计算配图视图的尺寸：为单张图像预留伏笔；在配图视图的awakeFromnib创建了9个imageview；在didset中设置图像显示（第一次循环，隐藏所有图像，第二次循环，URL有内容就设置图像，并且显示图像））



//WBStatusViewModel：
//1.单条微博的视图模型
//2.封装单条微博中所有的业务逻辑
//3.需要修改列表模型中字典转模型的方法


//第六天的知识点：
//1.转发的原创微博
//2.单图的等比例
//3.自定义刷新控件
//4.缓存高度和性能的优化
//转发的


//如何提供返回图像的大小：
//1.让后台提供一个接口：（一般后天不提供这个接口；以前的蘑菇街、美丽说，现在的性能考虑，都放弃了瀑布流）
//2.不推荐：按照字节读取图像在服务器的图片首部的二进制数据
//sd是根据第一个字节判断图像类型，JPG最多的是读100k
//3.将图像直接下载到本地，可以实例化成image，就知道image的大小
//（知识点）：GCD的调度组


//MARK:--------------   转发微博  


//cell的准备：
//1. 修改原创中的cell的细节：间距、字体、因为要复制xib，如果细节不注意。会两个不停的进行修改
//2.复制新的cell-》retweetedCell :增加一个背景按钮，目的点击转发微博做出交互、增加被转发的文字、调整配图视图的顶部的约束

//控制器的准备：
//1.增加可重用的cellID
//2.在setuptabview中注册原型的cell

//准备模型：
//增加了一个retweeted_status


//运行测试：
//原创微博的图片，跑到了转发微博中
//转发微博没有文字，因为没有处理
//强调：如果没有被转发的微博，原创微博部分没有配图

//视图模型中增加计算型属性 ：
//-->picURLs: return status.retweeted_status?.pic_urls ?? status.pic_urls （如果有被转发的微博，返回被转发的微博的配图；如果没哟别转发的微博，返回原创微博的配图，否则返回nil）

//修改构造函数中计算配图视图大小的参数 ： picURLs/   计算配图视图的大小（原创，被转发，只有一组配图）




//修改cell中的设置配图数组 pictureview.urls= viewModel?.picURLs
//在控制器的数据源的方法中：根据视图模型判断是否有转发微博，决定可重用的cell


//MARK: ------------- 单图
//在加载完成网络数据之后：
//在刷新表格之前：
//知道单图微博的图片的大小： 在显示表格的时候，等比例显示表格中的图像；变通的做法，高度不变，等比例调整宽度（UI基础生活圈）

//修改listviewmodel： 
//1.在加载到数据之后，缓存单张图像
//2.cacheSingleImage（参数：本次下载生成的视图模型数组、遍历数组、获取单张图的url、使用SDWebImageManager.shared().downloadImage;）
//1.图像下载完成之后，会自动报讯在沙盒中，文件路径是URL的MD5
//2.如果沙盒中已经存在缓存的图像，后续使用SD同过URL加载图像，都会记载本地沙盒的图像
//3.不会发起网络请求，同时回调方法，同样会调用！
//4.方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网络请求;程序员在开发的时候不需要做任何的改动，其他位置不需要做任何的改动，也不要担心重复下载


//为了监听所有的图像缓存完成，使用了GCD的调度组，dispatch_group ----->  enter之后，监听随后的block，block的最后一句是要leave；enter和leave要配对出现

//当监听到所有的图像缓存完成之后，再刷新表格 ，所有单张图像的视图模型中的配图视图大小，已经计算完成
//细节：记录了所有图片的二进制数据长度（判断方案的可行性，如果数据太长，就不合适，需要找后台要接口）


//扩展viewmodel：增加一个函数updateSinggleimagesize，使用缓存的单张图片更新配图视图的大小，增加了顶部间距
//修改wbstauspictureView:增加了viewmodel的属性，在didset中计算配图视图的大小
//cell中设置配图视图的视图模型

//MARK :-----------缓存行高的步骤：
//1.打开xib/纯代码一样，按照从上向下的顺序，依次罗列控件的高度公式
//2.计算行高的方法：在视图模型中，根据公式，定义需要的常量（间距、图标、标签视图计算的额大小、标签的字体）
//3.定义变量height
//4.从上向下，依次计算(不建议跳跃，不要省略)

