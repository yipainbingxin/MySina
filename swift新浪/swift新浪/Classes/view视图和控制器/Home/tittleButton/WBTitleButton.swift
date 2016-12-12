//
//  WBTitleButton.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/8.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

//    重载构造函数
//    如果是nil就显示首页，如果不为nil就显示箭头和图像
    init(title: String?) {
        super.init(frame: CGRect())
//        1.判断title是否为nil
        if title == nil {
            setTitle("首页", for: [])
        }else{
            setTitle(title!+"  ", for: [])
            //        设置图像
            setImage(UIImage(named:"043"), for: [])
            setImage(UIImage(named:"042"), for: .selected)

        }
//        2.设置字体颜色使字体加粗
        titleLabel?.font=UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: [])
//        3.设置大小
        sizeToFit()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    重新布局子视图
    override func layoutSubviews() {
       super.layoutSubviews()
        
        guard let titleLabel = titleLabel , let imageView = imageView else {
            return
        }
//        将titleLabel的x向左移动imageview宽度
         titleLabel.frame=titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        // 将imageview的x向右移动titleLabel宽度
        imageView.frame=imageView.frame.offsetBy(dx: titleLabel.frame.size.width, dy: 0)
        
        print("调整按钮布局--\(titleLabel)--\(imageView)")

    }

}
