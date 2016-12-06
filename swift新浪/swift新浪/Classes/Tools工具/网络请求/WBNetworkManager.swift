//
//  WBNetworkManager.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/28.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
//打入框架的文件夹的名字
import AFNetworking
//swift 的枚举支持任意数据类型
//switch，enum在oc中都只支持整数

enum WBHTTPMethod {
    case GET
    case POST

}


/// 网络管理工具

class WBNetworkManager: AFHTTPSessionManager {
    
//    静态区／常量/闭包
//    在第一次访问时，执行闭包，并且将结果保存在shared常量中
    static let shared = WBNetworkManager()
//    访问令牌，所有网络请求，都基于此令牌（登录除外）,
//    为了保护用户安全，默认权限是三天，token作为访问令牌有期限
//    模拟token过期，返回的是403，处理用户token过期
    var accessToken : String?
//        ="2.007xcQ6GJ3QsDCf3c8ee25386h6yPB"
    
    
//    UId 用户的微博uid
    var uid: String? = "5365823342"
   
//    用户登录标记
    var userLogin: Bool{
                 return accessToken != nil
    }
    
    
    
//    专门负责拼接token的网络请求
    func tokenRequest(method: WBHTTPMethod = .GET,urlString: String,parameters:[String:Any]?,completion:@escaping (_ json: Any?,_ isSuceess: Bool)->()) {
        
//        处理token字典
//        0.判断token是否为nil，为nil直接返回
     
        guard let token = accessToken else {
//        FIXME:-----------------发送通知，提示用户登录
                print("没有token！需要登录")
                completion(nil, false)
                return
        }
        //        1.判断参数字典是否存在，如果为nil，应该创建一个字典
        var parameters = parameters
        
        if parameters==nil {
//            实例化字典
            parameters=[String: Any]()
        }
        
//      2.设置参数字典  代码在此处字典一定有值
        parameters!["access_token"]=token
//        调用request发起真正的网络请求
        request(urlString: urlString, parameters: parameters, completion: completion)
        
    }
    
    
    
    
    
//    使用一个个函数封装afn的get/post 请求
        /// 封装afn的post和get请求的方法
    ///
    /// - parameter method:     post／get请求
    /// - parameter urlString:  URL
    /// - parameter parameters: 请求的参数
    /// - parameter completion: 请求的回调结果返回
    func request(method: WBHTTPMethod = .GET,urlString: String,parameters:[String:Any]?,completion:@escaping (_ json: Any?,_ isSuceess: Bool)->()) {
        
//        成功回掉的闭包
        let success = { (task: URLSessionDataTask,json: Any?)->() in
            completion(json, true)
            
            
        
        }
        
        
//        失败回调的闭包
        let failure = { (task: URLSessionDataTask?,error: Error)->() in
//            针对403处理用户token过期
//            对于测试用户(应用程序还没有提交给新浪微博审核)，每天的刷新都是有限的
//            超出上限，token会被锁定一段时间
//            解决办法：创建一个应用程序
            if (task?.response as? HTTPURLResponse)?.statusCode==403 {
                print("token ----------过期了")
//                FIXME:发送通知，提示用户再次登录（本方法不知道被谁调用，谁接受到通知，谁处理！）
            }
//            error通常比较吓人，输出的一般都是英文
            print("网络请求错误-------\(error)")
            completion(nil, false)

        }
        
        if method == .GET {
        get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
 
        }else{
           post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        
        }
    }

}
