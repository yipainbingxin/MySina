//
//  WBWelcomeView.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import SDWebImage
//欢迎界面
class WBWelcomeView: UIView {
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLab: UILabel!
    
    
    
//    类函数加好方法
    class func welcomeView() -> WBWelcomeView {
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        //        从xib加载视图，有个默认值
        v.frame=UIScreen.main.bounds
        
        return v
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//    提示：initwithcoder只是刚刚从xib 的二进制文件将视图加载完成
//        还没有和代码连线建立起联系，所以开发时，千万不要在这个方法中处理UI
        print("initwithcoder----+\(iconView)")
    }
    override func awakeFromNib() {

//        1.url 
        
        guard  let urlString = WBNetworkManager.shared.userAccount.avatar_large,let url = URL(string: urlString )else {

            return
        }
//        2.设置头像,--如果没有网络图像没有下载完成，先显示占位头像
//        如果不设置占位头像，之前设置的图像会被清空

        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avender_pepole"))
        
        
    }
    
    
    
    
//    自动布局系统更新完成约束后。会自动调用此方法
//    通常是对子视图布局进行修改
//    override func layoutSubviews() {
//        
//    }
//    视图被添加到window上标示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
//        视图是使用自动布局来设置的，只是设置约束，
//       --- 当视图被添加到窗口上时。根据父视图的大小，计算约束值，更新控件的位置
//       layoutIfNeeded会直接按照当前的约束值直接更新控件的位置
//        执行之后，控件的所在位置，就是xib中布局的位置
        self.layoutIfNeeded()

        bottomConstrain.constant = bounds.size.height-200
        //        如果控件们的frame还没有计算好！所有的约束会一起动画
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //    更新约束
            self.layoutIfNeeded()
            }) { (_) in

                UIView.animate(withDuration: 1.0, animations: { 
                    self.tipLab.alpha=1;
                    }, completion: { (_) in
                    
                        
//                        移除界面
                        self.removeFromSuperview()
                })
                
                
        }
    
    
    }
    
    
    
}
