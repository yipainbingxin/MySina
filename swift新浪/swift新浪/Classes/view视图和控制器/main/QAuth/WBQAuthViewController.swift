//
//  WBQAuthViewController.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/5.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 通过webview加载新浪微博授权页面控制器
class WBQAuthViewController: UIViewController {

     fileprivate lazy var webView = UIWebView()
    
    override func loadView() {
        view=webView
        view.backgroundColor=UIColor.white
//        取消页面的滚动，新浪微博的服务器，返回的授权界面默认的时候手机全屏
        webView.scrollView.isScrollEnabled=false
        
//        设置代理
        webView.delegate=self
        
//        设置导航栏按钮
        title="登录新浪微博"
//        导航条的按钮
        
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", fontSize: 16, frame: CGRect(x: 0, y: 0, width: 100, height: 40), target: self, action: #selector(close), isBack: true)
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "自动填充", frame: CGRect(x: 0, y: 0, width: 100, height: 40), target: self, action: #selector(autoFill))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        加载授权界面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirect_uri)"
//        1.确定要访问的资源
        guard let url = URL(string: urlString)else {
            return
        }
        //        2.建立请求
        let request = URLRequest(url: url)
//        3.家在请求
        webView.loadRequest(request)
        
        

    }

    //MARK:  --------------监听方法
  @objc fileprivate func close() {
       SVProgressHUD.dismiss()
       navigationController?.dismiss(animated: true, completion: nil)
    }
    // --------------自动填充，webview的注入直接通过js修改，修改本地浏览器中缓存的页面内容
//    点击登录按钮，执行submit（），将本地数据提交给服务器
    @objc fileprivate func autoFill() {
//        准备JS
        let js = "document.getElementById('userId').value='17682316585';"+"document.getElementById('passwd').value='bing134617';"
        
//        让web view执行js
        webView.stringByEvaluatingJavaScript(from: js)
        
    }

}

// MARK: -WBQAuthViewController的delegate
extension WBQAuthViewController:UIWebViewDelegate{
    
    /// webview将要加载请求
    ///
    /// - parameter webView:        webView
    /// - parameter request:        要加载的请求
    /// - parameter navigationType: 导航类型
    ///
    /// - returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
//       1. 确认思路
//        如果请求地址包含http://baidu.com/不加载页面，否则加载页面
        if request.url?.absoluteString.hasPrefix(WBRedirect_uri)==false{
            
            return true
        }
        print("加载请求-------\(request.url?.absoluteString)")
//        2.从http://baidu.com回调地址中查找是否有code=
//        query就是URL中查询字符串，如果没有code就取消授权
        if request.url?.query?.hasPrefix("code=")==false{
            print("取消授权")
            close()
           return false
        }
//        query就是查询字符串，这里是获取授权码
        print("加载请求-------\(request.url?.query)")
    
//        3.如果有就说明授权成功，否则授权失败
//        3.从query字符串中取出字符串
//        代码走到此处一定有查询字符串并且包含code
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        print("授权码-----是\(code)")
        
//        4.使用授权码 获取token
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
               SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                SVProgressHUD.showInfo(withStatus: "登录成功")

//                登录成功，下一步做什么，跳转界面，如何跳转
//                通过通知
//                1.发送通知
//                发送通知不关心有没有监听设备只负责发送通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserShouldLoginSuccessNotification),
                                                object: nil)
//                2.关闭窗口
                self.close()
                
            }
        }
//        关于URL中的一些信息
//        EG:meituan:///shouP1:P2:P3:P4/大西瓜/红牛/小樱桃/肥羊
//        scheme：协议头--- meituan
//        host：主机头----nil/如果没有///
//        pathcomponent：返回数组、URL中所有路径的数组----show:P1:P2:P3   /大西瓜/红牛/小樱桃/肥羊
//        query：查询字符串、URL中？后面所有的内容
        
        
        return false
    }
    
    
    
    /// 开始加载和结束加载的时候开始菊花，结束菊花
    ///
    /// - parameter webView:
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}
