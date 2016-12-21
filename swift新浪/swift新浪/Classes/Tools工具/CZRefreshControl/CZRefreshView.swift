//
//  CZRefreshView.swift
//  刷新控件
//
//  Created by 冰 on 2016/12/20.
//  Copyright © 2016年 hzmohe. All rights reserved.
import UIKit
//刷新视图：负责刷新相关的UI显示和动画
class CZRefreshView: UIView {
//    刷新状态
//    iOS系统中，UIview封装的旋转动画
//    默认顺时针旋转
//    就近原则
//    要想实现同方向旋转，需要调整一个非常小的数字
//    如果想实现360旋转，需要核心动画CABaseAnimation
    var refreshState: CZRefreshState = .Normal{
        didSet{
            switch refreshState {
            case .Normal:
//                回复状态：
                tipIcon?.isHidden = false
                indicator.stopAnimating()
                tipLable.text = "继续使劲拉"
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLable.text = "放手就刷新"
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI-0.001))
                }
            case .WillRefresh:
                tipLable.text = "正在刷新中..."
//                隐藏提示图标
                tipIcon?.isHidden = true
//                显示菊花
                indicator.startAnimating()

            }

        }
    }
//    指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
//    指示图标
    @IBOutlet weak var tipIcon: UIImageView?
//    指示标签
    @IBOutlet weak var tipLable: UILabel!
    
    class func refreshView()->CZRefreshView {
        let nib = UINib(nibName: "CZRefreshView", bundle:nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZRefreshView
        
        
    }
    
    

}
