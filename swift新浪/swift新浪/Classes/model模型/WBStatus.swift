//
//  WBStatus.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/29.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import YYModel
/// 微博数据模型
class WBStatus: NSObject {
    
//    MVVM:视图模型 是MVVM设计模式提出来的，用于从控制其中剥离业务逻辑，让每一
//        个函数都是可以测试的
//    微博列表视图模型的使命如下：
//    字典转模型逻辑
//    上拉、下拉数据处理逻辑
//    下拉刷新数据数量
//    本地缓存数据处理（SLLITE）
    
    
    
    /// int 类型，在64位的机器上是64位的，在32位的机器就是32位
//    如果不写，int64在iPad2、iPhone5、5c,4s/上都无法正常运行，数据会溢出
    var id: Int64=0
    
//    微博信息内容
    var text:String?

    
//    转发数
    var reposts_count: Int=0
//    评论数
    var comments_count: Int=0
//    点赞数
    var attitudes_count: Int=0
    
//    微博的用户--注意和服务器返回的属性值要和key一致
    var user: WBUser?
    
    
//    所有的第三方基本都是如此
    ///  微博配图模型数组《YY_MODEL字典转换类型时，如果发现一个数组属性》
//    尝试实用类方法，如果实现，YYmodel就尝试使用类来实例化数组中的对象
    var pic_urls: [WBStatusPicture]?
    
    
    
    
    /// 重写description的计算型属性
    override var description: String{
        return yy_modelDescription()
    }
//    类函数，-》 告诉第三方框架YY_model如果遇到数组类型的属性，数组中存放的对象是什么类
//    nsarry中保存的对象的类型通常是‘id’类型
//    oc中的泛型是swift推出的，苹果为了兼容给OC增加的
//    从运行时角度，仍然不知道数组中应该存放什么类型的对象
    class func modelContainerPropertyGenericClass()->([String:AnyClass]) {
        return ["pic_urls":WBStatusPicture.self]
    }
    
    
    
}
