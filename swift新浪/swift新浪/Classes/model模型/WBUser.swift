//
//  WBUser.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/13.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

/// 微博用户模型
class WBUser: NSObject {
    
    
/// 基本数据类型&private不能使用KVC设置
    var id: Int64 = 0
//    用户昵称
    var screen_name: String?
//    用户头像地址（中图），50×50像素
    var profile_image_url: String?
/// 认证类型，-1 ：没有认证，0：认证用户：2、3、4、5，220：达人
    var verified_type: Int = 0
    /// 会员等级1-6
    var mbrank: Int = 0
    
    
    override var description: String{
        return yy_modelDescription()
    }

}
