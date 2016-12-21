//
//  WBHomeViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit


//原创微博可重用cellid
fileprivate let originalCellId = "originalCellId"
//被转发微博的可重用cellid
fileprivate let retweetedCellId = "retweetedCellId"

//定义全局常量，尽量使用private修饰。否则到处都可以访问
class WBHomeViewController: WBBaseViewController {
    //    微博数据数组
//    fileprivate lazy var statusList = [String]()
//    列表视图模型
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
  
    
    //    加载数据
    override func loadData() {
        
//        xcode 8.0 的刷新控件，beginRefreshing什么都不显示
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) { 
            self.listViewModel.loadData(pullUp: self.isPullUp) { (isSuceess,shuldRefresh) in
                //            刷新数据完成
                //            结束刷新控件
                self.refreshControl?.endRefreshing()
                //  把上拉刷新的标记恢复
                self.isPullUp=false
                print("加载数据结束")
                //            刷新表格
                if shuldRefresh{
                    self.tableView?.reloadData()
                }
            }
            
   
        }
        
        
        
//        用网络工具加载微博数据
//        WBNetworkManager.shared.statusList { (list, isSucess) in
////        字典转模型，绑定表格数据
//            print("记载数据结束--------------------\(list)")
//            
//        }
        
        //        模拟延时加载数据----》dispatch_after
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
//            for i  in 0..<15 {
//                //                判断如果是上拉刷新，将数据追加到底部
//                if self.isPullUp {
//                    self.statusList.append("上拉数据\(i)")
//                }else{
//                    self.statusList.insert(i.description, at: 0)
//                }
//            }
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -------------点击进入下一个界面
    @objc fileprivate  func showFriend() {
        
        let vc = WBDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
        print(#function)
    }
    
}
//MARK:-----------表格数据源方法,具体的数据源方法，不需要super
extension WBHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        0.取出视图模型，根据视图模型判断可重用的cell
        let viewModel = listViewModel.statusList[indexPath.row]
        
        let cellId = (viewModel.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        

        //       1.取cell，本身会调用代理方法（如果有）/如果没有找到cell，按照自动布局的规则从上向下计算，找到向下的约束，从而计算动态行高/
//        FIXME:-----修改cellId
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        
        //        2.设置cell
       cell.viewModel=viewModel
        //        3.返回cell
        return cell
    }
   
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
//        1.根据index获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
      
        
        
//        离屏渲染：
//        在进入屏幕前绘制好表格cell，进入之后直接显示！
//        离屏渲染的好处：更快
//        坏处：CPU消耗大
    }
    
    
    
}
//MARK:-----------设置界面
extension WBHomeViewController{
    //重写父类的方法
    
    override func setTableView() {
        super.setTableView()
        //        设置导航栏，无法高亮。不能满足需求
        //        swift调用OC返回的是instance的方法，无法判断是否可选
        navItem.leftBarButtonItem=UIBarButtonItem(title: "好友", fontSize: 16, frame:CGRect(x: 0, y: 0, width: 40, height: 40), target: self, action: #selector(showFriend))
        
        //        注册原型cell和转发的cell
        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        
//        设置自动行高
//        tableView?.rowHeight=UITableViewAutomaticDimension
//        预估行高
        tableView?.estimatedRowHeight=300
        
        tableView?.separatorStyle = .none
        setUpNavTitle()
        
    
    }
    
    
//  父类必须实现代理方法，子类才能够重写swif才是如此swi2.0不是  设置导航栏标题
    func setUpNavTitle() {
        
        let title = WBNetworkManager.shared.userAccount.screen_name
        let button = WBTitleButton(title: title)
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        navItem.titleView=button

    }
    
    @objc fileprivate func clickTitleButton(btn: UIButton) {
    
    btn.isSelected = !btn.isSelected
    }
    
}
