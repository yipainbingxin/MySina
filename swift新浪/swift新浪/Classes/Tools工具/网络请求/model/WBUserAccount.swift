//
//  WBUserAccount.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/7.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

/// 用户账户信息
class WBUserAccount: NSObject {

//    访问令牌
    var access_token: String?
//    用户代号
    var uid: String?
//   access_token的生命周期 过期日期单位秒
//    开发者5年，每次登录之后都是5年；
//    使用者3天，会从第一天递减
    var expires_in: TimeInterval=0{
        
        didSet{
           expiresDate=Date(timeIntervalSinceNow: expires_in)
        }
    }
    
//    过期日期
    var expiresDate : Date?
    

    override var description: String{
        return yy_modelDescription()
    }
    
   
    
//    1.偏好设置(小) --xcode 8 无效
//    2.沙盒-归档、plist、json
//    3.数据库(FMDB/CoreData)
//    4.钥匙串访问（小、自动加密-需要使用SSKeyChain）
    func saveAccount() {
//        1.模型转字典
        
        var dict = self.yy_modelToJSONObject() as? [String:Any] ?? [:]
        
        dict.removeValue(forKey: "expires_in")
        print("存储的数据是---\(dict)")
        
//        需要删除expires_in
//        2.字典序列化data
        
        guard  let data = try? JSONSerialization.data(withJSONObject: dict, options: []),let filePath = ("useraccount.json" as String).cz_appendDocumentDir()else {
            return
        }
//        3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功---\(filePath)")
    }
}
