//
//  UIImageView+WebImage.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/13.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import SDWebImage

extension UIImageView{
    
    /// 隔离SDWebImage设置图像函数
    ///
    /// - parameter urlString:       urlString description
    /// - parameter placehoderImage: 占位图像
    /// - parameter isAvatar:        是否头像
    func cz_setImage(urlString: String?,placehoderImage: UIImage?,isAvatar: Bool = false) {
//       处理URL
        
        guard   let urlString=urlString,let url = URL(string : urlString) else {
//            设置占位图像
            image = placehoderImage
            return
        }
        //       可选项只是用在swift中，oc有的时候用！同样可以穿入nil
        sd_setImage(with: url , placeholderImage: placehoderImage, options: [], progress: nil) { [weak self](image, _, _ , _ ) in
//            完成回调 ----判断是否是头像
            if isAvatar {
               self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
    }
    
    
}
