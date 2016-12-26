//
//  WBComposeTypeButton.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/22.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
//UIControl内置了touchupinside
class WBComposeTypeButton: UIControl {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    
//点击按钮要展现的控制器的类型
    var clasName :String?
    
    
    
    /// 使用图喜庆名称、标题创建按钮，按钮布局从xib加载
    ///
    /// - parameter imageName: 图片名字
    /// - parameter title:     图片标题
    ///
    /// - returns:
    class func composeTypeButton(imageName: String,title: String)->WBComposeTypeButton {
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLable.text = title
        return btn
    }
    
    
}
