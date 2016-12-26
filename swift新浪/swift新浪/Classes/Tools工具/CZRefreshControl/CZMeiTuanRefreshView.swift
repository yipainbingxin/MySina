//
//  CZMeiTuanRefreshView.swift
//  刷新控件
//
//  Created by 冰 on 2016/12/21.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class CZMeiTuanRefreshView: CZRefreshView {
    @IBOutlet weak var buildingIconView: UIImageView!
    @IBOutlet weak var earthIconView: UIImageView!
    @IBOutlet weak var kangGuaRouIconView: UIImageView!
    
    
//    父视图的高度
  override var parentViewHeight: CGFloat {
        didSet{
           print("父视图高度\(parentViewHeight)")
            
            if parentViewHeight < 23 {
                return
            }
//            40--》200
//            0.2->1
//            高度差/最大高度差
//            23--1->0.2
//            126 == 0->1
            
            var scale:CGFloat
            
            if parentViewHeight>200 {
                scale = 1
            }else{
                scale = 1-(200-parentViewHeight)/(200-40)
  
            }

            kangGuaRouIconView.transform=CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    
    override func awakeFromNib() {
//        1.房子
        let image1 = #imageLiteral(resourceName: "loading_1_1")
        let image2 = #imageLiteral(resourceName: "loading_1_2")
        let image3 = #imageLiteral(resourceName: "loading_1_3")
        let image4 = #imageLiteral(resourceName: "loading_1_4")
        let image9 = #imageLiteral(resourceName: "loading_1_9")

        buildingIconView.image = UIImage.animatedImage(with: [image1,image2,image3,image4,image9], duration: 0.5)
        
//        2.地球
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = -2*M_PI
        animation.repeatCount=MAXFLOAT
        animation.duration=3
        animation.isRemovedOnCompletion=false
        earthIconView.layer.add(animation, forKey: nil)
        
//        3.袋鼠
//        1)设置锚点
         kangGuaRouIconView.layer.anchorPoint=CGPoint(x: 0.5, y: 1)
//        2.)设置center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height-40
        
        kangGuaRouIconView.center = CGPoint(x: x, y: y)
        kangGuaRouIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        
        
        
    }
}
