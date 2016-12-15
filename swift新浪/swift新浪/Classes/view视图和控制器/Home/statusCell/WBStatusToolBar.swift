//
//  WBStatusToolBar.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/14.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    var viewModel: WBStatusViewModel?{
        didSet{
            
            
            guard let str1  = viewModel?.retweetedStr,let  str2 = viewModel?.commentStr,let str3 = viewModel?.likedStr else {
                return
            }
    retweetedButton.setTitle("\(str1)", for: [])
    commentButton.setTitle("\(str2)", for: [])
    likeButton.setTitle("\(str3)", for: [])
            
        }

    }
    

    /// 转发
    @IBOutlet weak var retweetedButton: UIButton!
//    评论
    @IBOutlet weak var commentButton: UIButton!
//    赞
    @IBOutlet weak var likeButton: UIButton!

  }
