//
//  WBComposeButton.swift
//  新浪微博
//
//  Created by 冰 on 2016/11/15.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBComposeButton: UIButton {

    var composeButton : UIButton{
        
        let btn = UIButton()
        btn.backgroundColor=UIColor.blue
        btn.setTitleColor(UIColor.orange, for: UIControlState(rawValue: 0))
        btn.setTitle("+", for: UIControlState(rawValue: 0))
        btn.titleLabel?.font=UIFont.systemFont(ofSize: 40)
       return btn
    }
}
