//
//  WBStatusListViewModel.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/29.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation
//微博数据列表视图模型

//父类的选择
//如果只是使用“KVC”或者字典抓模型框架设置对象值，类就需要继承自nsobject
//如果类只是包装一些逻辑代码（写了一些函数），可以不用任何类，好处跟家轻量级
//提示：如果用OC写，一律都继承自nsobject即可



//使命：负责微博的数据处理
//1.字典转模型
//2.下拉／上拉刷新数据处理

//上拉刷新最大的尝试次数
fileprivate let maxPullUpTryTimes = 3
class WBStatusListViewModel {
//   微博视图模型数组懒加载
    lazy var statusList = [WBStatusViewModel]()
    
//    上拉刷新错误次数
    fileprivate var pullupErrorTimes = 0
    
//    加载数据列表
    /// - parameter pullUp:     是否上拉刷新
    /// 完成回调，（网络请求是否成功）
    func loadData(pullUp: Bool,completion: @escaping (_ isSuccess: Bool,_ shuldRefresh: Bool)->()) {
//判断是否是上拉刷新，同时检查刷新错误
    
    
    if pullUp && pullupErrorTimes > maxPullUpTryTimes {
        completion(true,false)
        return
    }
    
    
    //      since_id下拉，取出数组第一条微博的id
        
    let sinceId = pullUp ? 0:statusList.first?.status.id ?? 0
//        上拉刷新，取出数组的最后一条微博的id
    let maxId = !pullUp ? 0: (statusList.last?.status.id) ?? 0
    
    
        
//        发起网络请求加载微博数据
        WBNetworkManager.shared.statusList(since_id:sinceId,max_id:maxId) { (list, isSuccess) in
            
//      0.如果网络请求失败，直接执行完成回调
            if !isSuccess{
                completion(false, false)
                
                return
            }

//1. 遍历字典数组，字典转模型 =》视图模型，将视图模型添加到数组
            var arry = [WBStatusViewModel]()
            for dict in list ?? []{
                
                
//                print(dict["pic_urls"])
//                1. 创建微博视图模型
                let status = WBStatus()
//                2.使用字典设置模型数值
                status.yy_modelSet(with: dict)
//                3. 使用 '微博' 模型创建 '微博视图'模型
                let viewModel = WBStatusViewModel(model: status)
//                4.添加到数组
                arry.append(viewModel)
                
                
            }
//            视图模型创建完成

            print("刷新到\(arry.count)数据\(arry)")
//            2.FIXME:---------拼接数据
//            下拉刷新，应该将结果数组拼接在数组前面
            if pullUp {
//            上拉刷新，应该讲结果数组拼接在数组的末尾
                self.statusList+=arry 
            }else{
//            下拉刷新，应该将结果数组拼接在数组的前面
            self.statusList=arry+self.statusList
            }
//            3.判断上拉刷新的数据量
            if pullUp && arry.count==0{
                self.pullupErrorTimes += 1
                
                completion(isSuccess,false)
            }else{
                //                3.完成回调
                completion(isSuccess,true)
            }
            
        }
    }

}
    
