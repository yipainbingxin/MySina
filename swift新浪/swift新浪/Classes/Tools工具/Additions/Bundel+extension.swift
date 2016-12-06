//
//  Bundel+extension.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/14.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import Foundation
//返回命名空间字符串
extension Bundle{
//    func nameSpace () -> String {
//        return infoDictionary?["CFBundleName"]as?  String ?? ""
//    }
//    计算型属性类似于函数，没有参数有返回值
    var nameSpace: String {
      return infoDictionary?["CFBundleName"]as?  String ?? ""
    }
    
    
}
