//
//  WBStatusViewModel.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/13.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation
import UIKit

///单条微博的视图模型

/// 如果没有任何父类，如果希望在开发的时候调试，输出调试信息，需要
//1.遵守CustomStringConvertible
//2.实现description的计算型属性

//源于表格的优化：
///-尽量少计算，所有需要的素材提前计算好！
///-控件上不要设置圆角的半径，所有的图像渲染的属性，都要注意
///-不要动态创建控件，所有需要的控件，都要提前创建好，在显示的时候根据数据显示或隐藏
///-cell中控件的层次越少越好，数量越少越好
//-要测量，不要猜测！
class WBStatusViewModel: CustomStringConvertible{
//微博模型
    var status: WBStatus

//    会员图标---存储型属性（用内存换CPU）
    var memberIcon : UIImage?
    
/// 认证类型，-1 ：没有认证，0：认证用户：2、3、4、5，220：达人
    var vipIcon : UIImage?

    
    
//    转发
    var retweetedStr : String?
    //   评论
    var commentStr : String?
    //    点赞
    var likedStr : String?

    
//    配图视图大小
    var pictureSize = CGSize()
    
    
    
    /// 构造模型
    ///
    /// - parameter model: 微博模型
    ///
    /// - returns: 微博的视图模型
    init(model: WBStatus) {
        self.status=model
        /// 会员等级0-6
        if (model.user?.mbrank)!>0 && (model.user?.mbrank)!<7 {
            let imageName = "fk28_\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        
//        认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grasroot")
        default:
            break
        }
        
        
//        设置底部计数字符串
        
//        测试超过一万的数字
//        model.reposts_count = Int(arc4random_uniform(100000))
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentStr = countString(count: model.comments_count, defaultStr: "评论")
        likedStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
//        计算配图视图的大小
        pictureSize = cacuPictureViewSize(count: status.pic_urls?.count)
        

    }

    
    var description: String{
        return status.description
    }
   
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - parameter count: 配图数量
    ///
    /// - returns: 配图视图的大小
   fileprivate func cacuPictureViewSize(count: Int?) -> CGSize {
    if  count == 0 || count==nil {
        return CGSize()
    }
    //    1.计算配图视图的宽度
//2.计算高度
//    根据count计算高度知道行数1-9
    
//     1 2 3 = 0 1 2/3=0+1=1
//     4 5 6 = 3 4 5/3=1+1=2
//     7 8 9 = 6 7 8/3=2+1=3

    let row = (count!-1)/3+1
//    2>根据行数计算高度
    let height = WBStatusPictureViewQutterMargin+CGFloat(row)*WBStatusPictureItemWidth+CGFloat(row-1)*WBStatusPictureViewInnerMargin
    return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
   ///给定义一个数字返回对应的描述结果
   ///count: Int：数字，
    ///defaultStr:默认的字符串（转发、评论、赞）

//    如果数量==0，显示的是默认标题
//    如果数量超过10000，显示的x.xx万
//    如果数值是<1000,显示的是实际数字
   /// - returns: 描述的结果
   fileprivate  func countString(count: Int,defaultStr: String) -> String {
        if count==0 {

            return defaultStr
        }
        
        if count<10000 {
            return count.description
        }
        return String(format: "%.02f万", Double(count)/10000)
    }
    

    
}


