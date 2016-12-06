//
//  WBQAuthViewController.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/5.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

/// 通过webview加载新浪微博授权页面控制器
class WBQAuthViewController: UIViewController {

     fileprivate lazy var webView = UIWebView()
    
    override func loadView() {
        view=webView
        view.backgroundColor=UIColor.white
        
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
        
//        query就是URL中查询字符串
        if request.url?.query?.hasPrefix("code=")==false{
            print("取消授权")
            close()
           return false
        }
        print("加载请求-------\(request.url?.query)")

        
    
//        2.从http://baidu.com回调地址中查找是否有code=
        
//        3.如果有就说明授权成功，否则授权失败
        return true
    }
    
    
}
