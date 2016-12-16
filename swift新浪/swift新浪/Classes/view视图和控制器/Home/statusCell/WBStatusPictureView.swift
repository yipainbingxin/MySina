//
//  WBStatusPictureView.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/14.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBStatusPictureView: UIView {
    
    
    /// 配图视图数组
    var urls: [WBStatusPicture]?{
        didSet{
//           1.银行所有的imageview
            for v in subviews {
                v.isHidden=true
            }
//            2.遍历URLs数组，顺序设置头像
            var index = 0
            for url in urls ?? [] {
                
//                获得对应的索引的imageview
                let iv = subviews[index] as! UIImageView
                
//                4张图像处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
//               设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placehoderImage: nil)
//                显示图像
                iv.isHidden=false
                index+=1
            }
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    override func awakeFromNib() {
        setUI()
    }
}

// MARK: - 设置界面
extension WBStatusPictureView{
    
  /// 1.cell中所有的控件都是提前准备好
//    2.设置的时候，根据数据决定是否显示
//    3。不要动态创建控件
  fileprivate  func setUI() {
//    设置背景颜色
    backgroundColor = superview?.backgroundColor
//    超出边界的内容不显示
    clipsToBounds=true
    let count = 4
    let rect = CGRect(x: 0, y: WBStatusPictureViewQutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemWidth)
    
//    循环创建九个imageview
    for i in 0..<count * count{
        let iv = UIImageView()
//        设置contentmode
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        
        iv.backgroundColor=UIColor.red
        
//        行数 - y
        let row = CGFloat( i / count)
//        列数 - x
        let col = CGFloat( i % count)
        
        let xOffset = col*(WBStatusPictureItemWidth+WBStatusPictureViewInnerMargin)
        let yOffset = row*(WBStatusPictureItemWidth+WBStatusPictureViewInnerMargin)
        
        iv.frame=rect.offsetBy(dx:xOffset, dy: yOffset)
        addSubview(iv)
    }
    
    }
}
