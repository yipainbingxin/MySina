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
    
    
    /// 重写description的计算型属性
    override var description: String{
        
        
        return yy_modelDescription()
    }
    

    
    
    
}
