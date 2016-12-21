//
//  CZRefreshControl.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/19.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

//刷新状态切换到临界点
fileprivate let CZRefreshOffset: CGFloat = 60


/// 刷新状态
///
/// - Normal:      普通状态什么都不做
/// - Pulling:     超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}
/// 刷新控件

/// 如果不选择copy item if inneed，拖拽的目录还在原始位置，多个项目的联动的一个重要的技巧·
/// 刷新控件- 负责刷新相关的逻辑处理
class CZRefreshControl: UIControl {
    
    //    MARK:-----属性
//    刷新控件的父视图，下拉刷新的控件应该适用于UItabview、UICollectionView
    fileprivate weak var scrollView: UIScrollView?
    
//    刷新视图
    fileprivate lazy var refreshView: CZRefreshView = CZRefreshView.refreshView()
//    MARK:------构造函数
    init() {
     super.init(frame: CGRect())
    setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    
    /// newSuperview是adsubview方法会调用
    ///当添加到父视图的时候，newsuperview 是父视图
//    当父视图被移除，newsuperview是nil
    /// - parameter newSuperview:
    override func willMove(toSuperview newSuperview: UIView?) {
      super.willMove(toSuperview: newSuperview)
        
//        判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
//        记录父视图
        scrollView = sv
//        KVO:监听父视图的ContentOFfset
//        在程序中，通常只负责监听某一个对象的属性，如果属性太多，方法会很乱
//        KVO要监听的对象负责添加监听者
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
//     本视图从父视图中移除
//    提示：所有的下拉刷新框架都是监听父视图的contentOffset
//    所有的框架的KVO监听实现思路都是这个
    override func removeFromSuperview() {
//        superview还存在
//        scrollView 不存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
//        superview不存在
    }
    /// 所有kvo方法统一调用此方法
    /// - parameter keyPath: keyPath description
    /// - parameter object:  object description
    /// - parameter change:  change description
    /// - parameter context: context description
//    观察者模式，在不需要的时候都需要释放
//    通知中心：如果不释放，什么也不会发生，但是会有内存泄漏，会有很多次注册的可能
//    -kvo:如果不释放，会崩溃
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        contentOffset的y值跟contentinset的top有关
//        print(scrollView?.contentOffset)
//        初始高度就应该是0
        guard let  sv = scrollView else {
            return
        }
        let height = -(sv.contentInset.top+sv.contentOffset.y)
        
        if height<0 {
            return
        }
//        可以根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
//        判断临界点 - 只需要判断一次
        if sv.isDragging {
            if height > CZRefreshOffset&&refreshView.refreshState == .Normal {
                print("放手刷新")
                
                refreshView.refreshState = .Pulling
            }else if height <= CZRefreshOffset && refreshView.refreshState == .Pulling  {
                print("继续拉")
                refreshView.refreshState = .Normal
            }
        }else{
//         放手判断是否超过临界点
            if refreshView.refreshState == .Pulling {
                print("准备开始刷新")

                
                beginRefreshing()
//      发送刷新数据的事件
                sendActions(for: .valueChanged)
                
            }
        }
    }
//    开始刷新
    func beginRefreshing(){
        print("开始刷新")
//        判断父视图
        guard let sv = scrollView else {
            return
        }
        
        
//        判断是否正在刷新，如果正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
//        设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        
//        调整表格的间距
        var inset = sv.contentInset
        inset.top += CZRefreshOffset
        sv.contentInset = inset
        
//       如果开始调用sendActions，会重复发送刷新事件
//        sendActions(for: .valueChanged)

    }
//    结束刷新
    func endRefreshing(){
        print("结束刷新")
        
        guard let sv = scrollView else {
            return
        }
//        判断状态，是否正在刷新，如果不是直接返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        
// 恢复刷新视图的状态
        refreshView.refreshState = .Normal
        
//  恢复表格视图的inset
        
        var inset = sv.contentInset
        inset.top -= CZRefreshOffset
        sv.contentInset = inset

        
        
        
    }

}
extension CZRefreshControl{
   fileprivate func setUpUI() {
    backgroundColor = superview?.backgroundColor
//    设置超出边界不显示
//    clipsToBounds = true
//   添加刷新视图
    addSubview(refreshView)
    
//    自动布局 - 设置 xib控件的自动布局，需要指定宽高的约束
//    提示：iOS程序员，一定要会原生的写法，因为如果自己开发框架，不能用任何的自动布局框架
    refreshView.translatesAutoresizingMaskIntoConstraints = false
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
//
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))

    }
}
