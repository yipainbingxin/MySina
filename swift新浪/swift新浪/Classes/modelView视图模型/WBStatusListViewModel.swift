//
//  WBStatusListViewModel.swift
//  swift新浪
//
//  Created by 冰 on 2016/11/29.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation
import SDWebImage
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
//            遍历数组
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
                self.cacheSingleImage(list: arry, finished: completion)
                //  4.真正的数据回调,完成单张图片缓存之后再回调，闭包是准备好的代码，可以当做参数传递
//                completion(isSuccess,true)
            }
            
        }
        
    }
    
   ///缓存本次下载微博数据数组中的单张图像
   ///--应该缓存完单张图像，并且修改过配图的大小之后，再回调，才能够保证表格等比例显示单图图像
   /// - parameter list: 本次下载的视图模型数组
   fileprivate func cacheSingleImage(list:[WBStatusViewModel],finished: @escaping (_ isSuccess: Bool,_ shuldRefresh: Bool)->()){
//    调度组
    let group = DispatchGroup()
    
    
//记录数据的长度
    var length = 0
    //      遍历数组，查找微博数据中有单张图像的进行缓存
//    cmd+option+左 折叠代码，—+右展开代码
    for vm in list {
//        1.判断图像的数量
        if vm.picURLs?.count != 1 {
            continue
        }
        
//        2.获取图像模型,代码执行到这里数组有且仅有一张图片
        guard let pic = vm.picURLs![0].thumbnail_pic,let url = URL(string: pic) else {
            return
        }
        print("要缓存的URL是\(url)")
//        3.下载图像
//        1.）downloadImage是SDWebImage的核心的方法
//        2.）图像下载完成之后，会自动报讯在沙盒中，文件路径是URL的MD5
//       3.如果沙盒中已经存在缓存的图像，后续使用SD同过URL加载图像，都会记载本地沙盒的图像
//        4.不会发起网络请求，同时回调方法，同样会调用！
//        5.方法还是同样的方法，调用还是同样的调用，不过内部不会再次发起网络请求
        
//        ***:注意点如果如果缓存的图像累计很大，要找后台要接口
        
        
//        A>:  入组
        group.enter()
        SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image , _ , _ , _ , _ ) in
//            将图像转化成二进制数据
            if let image = image ,let data = UIImageJPEGRepresentation(image, 1){
                
//                NSData是lenth 的属性
                length += data.count
//                图像缓存成功，更新配图视图的大小
                vm.updateSingleImageSize(image: image)
            }
            
            
            
            print("缓存的图像是---\(image)---长度是\(length)")
//            B> 出组--要放在回调的最后一句
            group.leave()
        })

    }
//    C>监听调度组的情况
    group.notify(queue: DispatchQueue.main) { 
        print("图像缓存完成\(length/1024)k")
//        执行闭包回调
        finished(true, true)
    }
}
}

