//
//  UIImage+additons.swift
//  图像的优化
//
//  Created by 冰 on 2016/12/13.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
extension UIImage{
    func cz_avatarImage(size: CGSize?,backColor: UIColor = UIColor.white,lineColor: UIColor = UIColor.orange) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
//        1.上下文
        //        para1：size绘图的尺寸
        //        para2透明：false（透明）、true（不透明）
        //        scale：屏幕分辨率，默认生成的图像默认使用1.0的分辨率，图像质量不好可以指定为0，会选择当前设备的屏幕分辨率
        UIGraphicsBeginImageContextWithOptions(size!, true, 0)
        //        0:背景颜色
        backColor.setFill()
        UIRectFill(rect)
        
        
        //        a:实例化一个圆形的路径
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)

        
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        //  b：进行路径截切 - 后续的绘图都会出现早圆形路径内部，外部的全部干掉
        ovalPath.lineWidth=3
        lineColor.setStroke()
//      c:绘制内切的圆形
        ovalPath.stroke()
// 2.绘图drawrect就是在指定区域内拉伸屏幕
        
        
// 3.取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
//4.关闭上下文
        UIGraphicsEndImageContext()
//5.返回结果
        return result
    }
  
}
