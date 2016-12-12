//
//  WBFeatureView.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
/// 新特性视图
class WBFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var enterBtn: UIButton!
    
    
//    进入微博
    @IBAction func enterStatus(_ sender: AnyObject) {
    
        removeFromSuperview()
    }
    
//       类函数加好方法
    class func newFeature() -> WBFeatureView {
        let nib = UINib(nibName: "WBFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBFeatureView
        //        从xib加载视图，有个默认值
        v.frame=UIScreen.main.bounds
        
        return v
    }
    
    
    override func awakeFromNib() {
        print(bounds)
//        如果使用自动布局设置的界面从xib中加载默认的是600*600
//        添加4个图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "introductoryPage\(i+1)"
            
            let iv = UIImageView(image: UIImage(named: imageName))
//            设置大小
            iv.frame=rect.offsetBy(dx: CGFloat(i)*rect.size.width, dy: 0)
            scrollView.addSubview(iv)

        }
        //            指定scrollview的属性
        scrollView.contentSize=CGSize(width: CGFloat(count+1)*rect.width, height: rect.height)
        scrollView.isPagingEnabled=true
        scrollView.bounces=false
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.delegate=self
  
        
//        隐藏属性
        enterBtn.isHidden=true
        
    }
}


extension WBFeatureView: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        1.滑动到最后一屏，让视图删除
        let page = scrollView.contentOffset.x/scrollView.bounds.width
//        2.判断是否是最后一页
        if page == CGFloat(scrollView.subviews.count) {
          print("欢迎欢迎，热烈欢迎")
            removeFromSuperview()
        }
        
//        3.如果是倒数第二页，显示按钮
        enterBtn.isHidden = (page  != CGFloat(scrollView.subviews.count-1))
 
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        0.一旦滚动的时候隐藏按钮
        enterBtn.isHidden=true
//        1.计算当前的偏移量
        let page  = (scrollView.contentOffset.x/scrollView.bounds.width)
       
//        2.设置分页控件
        pageControl.currentPage = Int(page)
        
        print("page----\(page)----\(scrollView.subviews.count)")
//        3.分页控件的隐藏
        pageControl.isHidden = (page == CGFloat(scrollView.subviews.count))
    }
}
