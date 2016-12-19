//
//  WBStatusCell.swift
//  swift新浪
//
//  Created by 冰 on 2016/12/13.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

import UIKit

class WBStatusCell: UITableViewCell {
//    微博视图模型
    var viewModel: WBStatusViewModel?{
        didSet{
//          微博的文本
            statusLable.text=viewModel?.status.text
//          姓名
            nameLable.text=viewModel?.status.user?.screen_name
//          设置会员图标 ---直接获取属性不需要计算
            memberIconView.image=viewModel?.memberIcon
            
//          认证图标
            vipIconView.image=viewModel?.vipIcon
            
//           用户图像
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url, placehoderImage: UIImage(named: "avender_pepole"),isAvatar: true)
//            底部工具栏
            toolBar.viewModel=viewModel
        
            
//            测试修改视图的高度
//            pictureView.heightCons.constant = (viewModel?.pictureSize.height) ?? 0
//             配图视图模型
            pictureView.viewModel = viewModel
            
            
            
            
            
//            设置配图视图的URL的数据
//            测试四张图像
//            if (viewModel?.status.pic_urls?.count)!>4 {
////                修改数据，-》将末尾的数据全部删除
//                var picUrls = viewModel?.status.pic_urls!
//                picUrls?.removeSubrange(((picUrls?.startIndex)!+4)..<(picUrls?.endIndex)!)
//                pictureView.urls=picUrls
//                
//            }else{
//                pictureView.urls=viewModel?.status.pic_urls
// 
//            }

//            设置配图（包含了别转发和原创）
//            pictureView.urls=viewModel?.picURLs
   
            
//            设置被转发微博的文字
            retweetedLable?.text = viewModel?.retweetedText
            
        }
    }
    
  
//    底部工具栏
    
    @IBOutlet weak var toolBar: WBStatusToolBar!
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLable: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    /// 时间
    @IBOutlet weak var timelable: UILabel!
    /// 来源
    @IBOutlet weak var sourceLable: UILabel!
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    /// 正文
    @IBOutlet weak var statusLable: UILabel!
    
//    配图视图
     @IBOutlet weak var pictureView: WBStatusPictureView!
    
//    被转发微博的标签,原创微博没有此控件，被转发的有此控件有可能有有可能没有
    @IBOutlet weak var retweetedLable: UILabel?
    


    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //        离屏渲染：异步绘制
        self.layer.drawsAsynchronously = true
//        删格化： - 异步绘制之后，会生成一张独立的图像，cell在屏幕上华松的时候，本质上滚动的是这张图片
//        cell优化，要尽量减少用户的额数量，相当于只有一层
//        停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
//        栅格化必须指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
