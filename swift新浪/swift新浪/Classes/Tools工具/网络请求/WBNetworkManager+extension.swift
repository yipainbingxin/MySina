//
//  WBNetworkManager+extension.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/29.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation


// MARK: - 封装新浪微博的请求的方法

extension WBNetworkManager{
    
    /// 加载微博数据字典数组
    ///
    /// - parameter since_id:   若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    /// - parameter max_id:     若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    /// - parameter completion: 完成回调（list：微博字典数组／是否成功）
    func statusList(since_id: Int64=0,max_id: Int64=0,completion:@escaping (_ list: [[String:Any]]?, _ isSuccess: Bool)->()) {
        
        
//        swift中int，可以转换成anyObject,
        let params = ["since_id": "\(since_id)","max_id":"\(max_id>0 ? max_id-1: 0)" ]
        
        
        
        tokenRequest(urlString: "https://api.weibo.com/2/statuses/home_timeline.json", parameters: params) { (json, isSuessess) in
//            从json中获取status的字典数组
//            如果as?失败，result=nil
//            提示： 服务器返回的字典数组就是按照时间的倒序排序的
            guard let result = json,let tResult = result as?
                [String:Any] else {
                    return
            }
            completion(tResult["statuses"] as? [[String:Any]], isSuessess)
            
        }


    }
    
    
    
    /// 返回微博的未读的数量
    func unReadCout(completion: @escaping (_ count: Int)->()) {
        
        guard let uid=userAccount.uid else {
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let parames = ["uid":uid]
        
        tokenRequest(urlString: urlString, parameters: parames) { (json, isSuccess) in
            let dic=json as? [String:Any]
            
            guard let count = dic?["status"] as? Int else{
                
                return
            }
            
            completion(count )
        }
        
        
    }
    
}
