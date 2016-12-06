//
//  WBVistorView.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/21.
//  Copyright © 2016年 hzmohe. All rights reserved.
//
import UIKit
class WBVistorView: UIView {
    //    注册按钮
     lazy var registerButton: UIButton=UIButton()
    //    登录按钮
     lazy var loginButton: UIButton=UIButton()
    
    
    
    // MARK: - -----设置访客视图信息字典
    /// 使用字典定义访客视图的信息
    /// - parameter dict: [imageName/message]
    //    如果是首页不更换图片imageName="",
    //    访客视图的信息字典 [imageName/message]
    
//    重写set方法，要重写didSet
    var vistitorInfo: [String: String]?{
        didSet{
            //  1.取字典信息
            guard let imageName = vistitorInfo?["imageName"],
                let message = vistitorInfo?["message"]
                else {
                    return
            }
            //   2. 设置消息
            tipLable.text=message
            
            //       如果是首页设置为空
            if imageName == "" {
                
                starAnimation()
                return
            }
            //        设置图像,首页不需要设置
            houseIconView.image=UIImage(named: imageName)
    //      其他控制器不需要显示,遮罩视图，
            iconView.isHidden=true
            maskIconView.isHidden=true
        }
    }

//    MARK: 构造函数
    /// 访客视图
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUi()

    }
    //    MARK: 旋转图标动画，只有首页需要
  fileprivate  func starAnimation() {
    let anim = CABasicAnimation(keyPath: "transform.rotation")
    anim.toValue=2*M_PI
    anim.repeatCount=MAXFLOAT
    anim.duration=15
//    动画完成之后不删除，如果iconview被释放，动画会随着一起销毁
//    设置连续播放的动画非常有用
    anim.isRemovedOnCompletion=false
//    将动画添加到图层
    
    iconView.layer.add(anim, forKey: nil)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
// MARK: - 私有控件
    
//    懒加载属性只有使用uikit控件的制定构造函数，其他都需要使用类型
//    图像视图
    fileprivate lazy var iconView: UIImageView=UIImageView(image: UIImage(named: "1-4"))
    
//    遮盖图像,不要使用maskView，和UI view内的重名
    fileprivate lazy var maskIconView: UIImageView=UIImageView(image: UIImage(named: "1-4back.png"))
    
//    小房子
    fileprivate lazy var houseIconView: UIImageView=UIImageView(image: UIImage(named: "shouye-icon"))
//    提示标签
    fileprivate  lazy var tipLable : UILabel = UILabel()


}
//MARK:---------------设置界面

// MARK: - extention中不能有属性

// MARK: -extenation中不能重写父类本类的方法，重写父类的方法，是子类的职责，扩展是对子类的扩展
extension WBVistorView{
    func setUi () {
//        开发的时候能用颜色尽量用颜色，不要用图像
        backgroundColor=UIColor.white
//    设置控件
//        iconView.frame=CGRect(x: 0, y: 100, width: 100, height: 100)
        
//        houseIconView.frame=CGRect(x: 25, y: 125, width: 50, height: 50)
        
//        tipLable.frame=CGRect(x: 25, y: 200, width: 200, height: 30)
        tipLable.text="关注一些人，回这里看看什么惊喜关注一些人，回这里看看有什么惊喜";
        tipLable.font=UIFont.systemFont(ofSize: 10)
        tipLable.numberOfLines=0
        tipLable.textColor=UIColor.orange
        
        tipLable.textAlignment = .center
//        registerButton.frame=CGRect(x: 0, y: 250, width: 40, height: 30)
        registerButton.setTitle("注册", for: UIControlState(rawValue: 0))
        registerButton.setTitleColor(UIColor.blue, for: .normal)
        registerButton.backgroundColor=UIColor.red
        
        
        loginButton.setTitle("登录", for: UIControlState(rawValue: 0))
        loginButton.setTitleColor(UIColor.black, for: .normal)
//        loginButton.frame=CGRect(x: 50, y: 250, width: 40, height: 30)
        loginButton.backgroundColor=UIColor.orange
        
        

//    1.添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLable)
        addSubview(registerButton)
        addSubview(loginButton)
        
//        2.取消autoresize，autolayout两者不能共存
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints=false
        }
//        3.自动布局
//        图像视图 设置x居中显示
        
//        para1item：约束属性
//        para2attribute：约束关系
//        para3relatedBy：参考视图
//        para4toItem：参考属性
//        para5：乘积
//        para5：约束数值


//        view1.attr1=view2.attri2*multif+constant
//        如果指定宽高约束
//        VFL可视化格式语言
//        H水平方向
//        V竖直方向
//        I边界
//        []包含控件的名称字符串
//        （）定义控件的宽高
        //        如果指定宽高的约束：
        //        参照视图设置为nil
//        参照属性选择：.notAnAttribute
//       2.
        let margin : CGFloat = 20.0
        
         addConstraint(NSLayoutConstraint(item: iconView,
                                          attribute: .centerX,
                                          relatedBy: .equal,
                                          toItem: self,
                                          attribute:.centerX ,
                                          multiplier: 1.0,
                                          constant: 0))
        
        
//        设置y的方向居中
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute:.centerY,
                                         multiplier: 1.0,
                                         constant: -60))
        
//        小房子视图
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute:.centerX ,
                                         multiplier: 1.0,
                                         constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute:.centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
//      3. 提示标签
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        
//        设置在iconview的下方
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: margin))
        
//        设置其宽度notAnAttribute
        addConstraint(NSLayoutConstraint(item: tipLable, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 175))

        
//    4.添加注册登录按钮
//    设置左侧和顶部宽度
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: tipLable, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLable, attribute: .bottom, multiplier: 1.0, constant: 10))

        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 90))
        
        
//        5.设置右侧的按钮登录
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: tipLable, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: tipLable, attribute: .bottom, multiplier: 1.0, constant: 10))
        
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: registerButton, attribute: .width, multiplier: 1.0, constant:0))
//        6.遮盖图像
//    自动布局函数
//        NSLayoutConstraint.constraints(
//            withVisualFormat:VFL公式,
//            options: [],
//            metrics: 约束数值字典[string:数值],
//            views: 视图字典[string:子视图])
        
//        VFL:可视化格式语言
//            .H:水平方向
//            .V:垂直方向
//            .I:边界
//            .[]:包含控件的名称字符串，对应关系在views字典中定义
//            .()定义控件的宽高，可以在metrics中指定
//        views:定义vfl中的控件名称和实际名称的映射关系
//         水平方向
//        metrics:定义的是vfl中（）指定的常数的映射关系
        let viewDict = ["maskIconView":maskIconView,
                        "registerButton":registerButton] as [String : Any]
        let metrics = ["spacing": -35]
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"H:|-0-[maskIconView]-0-|",
            options: [],
            metrics: nil,
            views: viewDict))
        
//        竖直方向
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat:"V:|-0-[maskIconView]-(spacing)-[registerButton]",
            options: [],
            metrics: metrics,
            views: viewDict))
        
    }
    
    
}
