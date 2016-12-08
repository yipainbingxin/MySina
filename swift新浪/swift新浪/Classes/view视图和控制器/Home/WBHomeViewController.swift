//
//  WBHomeViewController.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/9.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit



fileprivate let cellId = "cellId"
//定义全局常量，尽量使用private修饰。否则到处都可以访问
class WBHomeViewController: WBBaseViewController {
    //    微博数据数组
//    fileprivate lazy var statusList = [String]()
//    列表视图模型
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
  
    
    //    加载数据
    override func loadData() {
        listViewModel.loadData(pullUp: self.isPullUp) { (isSuceess,shuldRefresh) in
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
        //       1.取cell
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        //        2.设置cell
        cell.textLabel?.text=listViewModel.statusList[indexPath.row].text
        
        //        3.返回cell
        return cell
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
        
        //        注册原型cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    setUpNavTitle()
    
    }
    
    
//    设置导航栏标题
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
