//
//  WBComposeView.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/22.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import pop

/// 撰写微博类型视图
class WBComposeTypeView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    
//    关闭按钮约束
    @IBOutlet weak var closeButtonCenterx: NSLayoutConstraint!
//    返回按钮约束
    @IBOutlet weak var returnButtonCenterx: NSLayoutConstraint!
//    返回按钮
    @IBOutlet weak var returnButton: UIButton!
//按钮数据数组
    fileprivate let buttonsInfo = [["imageName":"btn_1","title":"文字","clasName":"WBComposeViewController"],["imageName":"btn_2","title":"图片/视频"],["imageName":"btn_3","title":"长微博"],["imageName":"btn_4","title":"签到"],["imageName":"btn_5","title":"点评"],["imageName":"btn_6","title":"更多","actionName":"clickMore"],["imageName":"btn_7","title":"好友圈"],["imageName":"btn_8","title":"微博相机"],["imageName":"btn_9","title":"音乐"],["imageName":"btn_10","title":"拍摄"],]
    
    
    
//    完成回调。闭包可以为空
   fileprivate var completionBlock:((_ claName: String?)->())?
        
    
//    MARK:--实例化方法
    class func composeTypeView() -> WBComposeTypeView {
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
//        从XIB加载完成视图，就会调用awakefromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as!  WBComposeTypeView
        
//        从xib加载默认的是600*600
        v.frame=UIScreen.main.bounds
        v.setUpUI()
        return v
    }
    

    
    
   @objc fileprivate func clickMore(){
    print("点击了更多的按钮")
//    1.将scrollview滚动到第二页
    let offset = CGPoint(x: scrollView.bounds.width, y: 0)
    scrollView.setContentOffset(offset, animated: true)
 
//    2.处理底部按钮，让两个按钮分开
    returnButton.isHidden=false
    
    let margin = scrollView.bounds.width/6
    
    closeButtonCenterx.constant += margin
    returnButtonCenterx.constant -= margin
    
    UIView.animate(withDuration: 0.5) {
        self.layoutIfNeeded()
    }
    
    }
    
    //    显示当前视图
    
    /// OC中的block，如果当前方法不能执行，通常使用属性记录，再需要的时候执行
    ///
    /// - parameter completion:
    func show(completion:@escaping (_ clsName: String?)->()) {
//        0.记录闭包
        completionBlock = completion
        //       1.将当前视图添加到main上
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        //        2.添加视图
        vc.view.addSubview(self)
        
//        3.开始动画
         showCurrentView()
        
    }
    // MARK: ------监听方法
    @objc fileprivate  func clickButton(selectedButton:WBComposeTypeButton) {
//        1.判断当前显示的视图
        let page  = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
//        2.遍历当前视图
//        选中的按钮放大
//        未选中的按钮缩小
        for (i,btn) in v.subviews.enumerated() {
//            1.缩放动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
//            x,y在系统中使用cgpoint标示，如果要转换成id,需要使用nsvalue包装
            let scale = (btn == selectedButton) ? 2 : 0.5
            let value = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            
            scaleAnim.toValue = value
            scaleAnim.duration = 1
            btn.pop_add(scaleAnim, forKey: nil)
            
            
//            2.渐变动画--动画组
            let alphAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphAnim.toValue=0.2
            alphAnim.duration=0.5
            btn.pop_add(alphAnim, forKey: nil)
            
//            3.添加动画监听
            
            if i==0 {
                alphAnim.completionBlock={_,_ in
//                    需要执行回调
                    print("完成回调的控制器")
                    self.completionBlock?(selectedButton.clasName)
                }
            }
            
        }
        
        
        
        
        
        
        
    }
    
    /// 点击按钮返回
    @IBAction func clickReturn() {
        //        1.滚动到第一页
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        //        2.让两个按钮合并
        closeButtonCenterx.constant=0
        returnButtonCenterx.constant=0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha=0
        }) { (_) in
            self.returnButton.isHidden=true
            self.returnButton.alpha=1
        }
    }
    //   关闭视图
    @IBAction func close(_ sender: UIButton) {
        
//        removeFromSuperview()
        hideButtons()
    }
    
    
}



// MARK: - 动画方法扩展
fileprivate extension WBComposeTypeView{
    // MARK: - 消除动画
//隐藏按钮动画
   fileprivate func hideButtons() {
//    1.根据contentoffset判断当前显示的子视图
    let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
    let v = scrollView.subviews[page]
    
//    2.遍历v中所有的按钮
    for (i,btn) in v.subviews.enumerated().reversed() {
//        1.创建动画
        let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
//        2.设置动画属性
          anim.fromValue = btn.center.y
          anim.toValue = btn.center.y + 350
        
//        设置时间
        anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count-i)*0.025
        
//        3.添加动画
        btn.layer.pop_add(anim, forKey: nil)
        
//        4.监听第0个按钮的动画，是最后一个执行的
        if i==0 {
            anim.completionBlock = { _,_ in
                self.hideCurrentView()
            }
        }
        
    }

    }
    //   隐藏当前视图--开始时间
    fileprivate func hideCurrentView(){
//        1.创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
//        2.添加到视图
        pop_add(anim, forKey: nil)
        
//        3.添加完成监听方法
        anim.completionBlock={_,_ in
            self.removeFromSuperview()
        }
    }
    
    
    
    
    
    
    // MARK: - 显示部分动画
   
//    动画显示当前视图
   fileprivate func showCurrentView() {
    
//    1.创建动画
    let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
    anim.fromValue=0
    anim.toValue=1
    anim.duration=0.5
//    2.添加到视图
    pop_add(anim, forKey: nil)
//    3.    弹力显示所有的按钮
    showButtons()

    }
    
    
    /// 弹力显示所有的按钮
    fileprivate func showButtons(){
//     1.虎丘scrollview的子视图的第0个视图
        let v = scrollView.subviews[0]
        
//       2.遍历v中所有的按钮
        for (i,btn)  in v.subviews.enumerated() {
//            1.创建动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
//            2.设置动画的属性
            anim.fromValue=btn.center.y+300
            anim.toValue=btn.center.y
//            弹力系数，取值范围是0-20，数值越大，，弹性越大，默认数值是4
            anim.springBounciness=8
//            弹力速度，取值范围0-20，数值越大，速度越快，默认数值为12
            anim.springSpeed=8
            
//        设置动画启动时间
            anim.beginTime=CACurrentMediaTime()+CFTimeInterval(i)*0.025
            
//            3.添加动画
            btn.pop_add(anim, forKey: nil)
        }
        
        
        
        
    }
    
}

// MARK: -fileprivate让extension中所有的方法都是私有
fileprivate extension WBComposeTypeView{
    func setUpUI() {
//        0.强行更新布局
          layoutIfNeeded()
//        1.向scrollview添加视图
          let rect = scrollView.bounds
          let width = scrollView.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i)*width, dy: 0))
            
            //        2.向视图添加按钮
            addButtons(v: v, idx: i*6)
//            3.向视图添加到scrollview
            scrollView.addSubview(v)
            
        }
        
//        4.设置scrollview
          scrollView.contentSize=CGSize(width: 2*width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces=false
//        禁用滚动
        scrollView.isScrollEnabled=false
    }
    /// 向view中添加按钮
    ///
    /// - parameter v:
    /// - parameter idx:
    func addButtons(v: UIView,idx: Int)  {
//       从idx开始添加6个按钮
        let count = 6
        
//        1.从 inx开始，添加6个按钮
        for i in idx..<(idx+count) {
//            0.从数组字典中获取图像名字和title
            if i>=buttonsInfo.count {
                break
            }
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],let title = dict["title"]  else {
                return
            }
            
//        1.创建按钮
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
//            2.添加到视图
            v.addSubview(btn)
//            3.添加监听方法
            if let actinName = dict["actionName"]{
                btn.addTarget(self, action: Selector(actinName), for: .touchUpInside)
            }else{
                
//                FIXME: ----
                btn.addTarget(self, action: #selector(clickButton(selectedButton:)), for: .touchUpInside)
            }
            
//            4.设置要展现的类名 --不需要任何的守护，有了就设置没有就不设置
            btn.clasName = dict["clasName"]
        }
        
        
//       2. 遍历视图的子视图，布局按钮
//        准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width-3*btnSize.width)/4
        
        
        for (i,btn) in v.subviews.enumerated() {
            
            let y :CGFloat = (i>2) ? (v.bounds.height-btnSize.height) : 0
            let column = i%3
            
            let x = margin*CGFloat(column+1)+CGFloat(column)*btnSize.width
            btn.frame=CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
            
        }
        
        
    }
    
}
