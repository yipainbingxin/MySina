//
//  WBUserAccount.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/7.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
//存储文件的名字
fileprivate let accountFile: String = "useraccount.json"
/// 用户账户信息
class WBUserAccount: NSObject {

//    访问令牌
    var access_token: String?
//    用户代号
    var uid: String?
    
//    用户昵称
    var screen_name: String?

    //    用户头像
    var avatar_large: String?
    
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
    
 
    
    
    /// 重写init方法
    /// - returns:
    override init() {
        super.init()
//       1. 从磁盘中加载保存文件-》保存文件
//        加载磁盘文件到二进制数据，如果失败就直接返回
        guard let path = accountFile.cz_appendDocumentDir(),
        let data = NSData(contentsOfFile: path),let dict = try? JSONSerialization.jsonObject(with: data as Data, options: [])  as? [String: Any] else {
            return
        }
        
//       2. 使用字典的属性设值,用户是否登录的关键代码
        yy_modelSet(with: dict ?? [:])
        print("从沙盒中加载用户信息\(self)")
        
//        3.判断token是否过期
//        测试过期日期
//        expiresDate = Date(timeIntervalSinceNow: -3600*24)
//        print(expiresDate)
        if expiresDate?.compare(Date()) != .orderedDescending {
        print("账户过期")
//            清空token
            access_token = nil
            uid = nil
//            删除账户文件
         _ = try?  FileManager.default.removeItem(atPath: accountFile)
            
        }
        print("账户正常\(self)")
        

        
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

        guard  let data = try? JSONSerialization.data(withJSONObject: dict, options: []),let filePath = accountFile.cz_appendDocumentDir()else {
            return
        }
//        3.写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功---\(filePath)")
    }
}
