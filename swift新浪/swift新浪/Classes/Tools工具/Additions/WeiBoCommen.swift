//
//  WeiBoCommen.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/5.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation
// MARK:   定义应用程序的信息
//应用程序ID
let WBAppKey = "1889527261"
//应用程序的加密信息（开发者可以申请修改）
let WBAppSecret = "b0a6ba80bcee13fde431e2862f4c5514"
//回调地址，登录完成后跳转的URL，以get的方式拼接
let WBRedirect_uri = "http://baidu.com"
// MARK:   全局通知定义
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
//用户登录成功通知
let WBUserShouldLoginSuccessNotification = "WBUserShouldLoginSuccessNotification"

//MARK:---------------微博配图视图常量
//    配图视图外侧的间距
let WBStatusPictureViewQutterMargin = CGFloat(12)
//    配图视图内部图像视图的的间距
let WBStatusPictureViewInnerMargin = CGFloat(3)
//    屏幕的宽度
let WBStatusPictureViewWidth = UIScreen.caculateScreenWidth()-(2*WBStatusPictureViewQutterMargin)
//    每个item默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth-2 * 10)/3


