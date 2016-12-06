//
//  UIScreen+WBUIScreen.m
//  新浪微博
//
//  Created by 冰 on 2016/11/16.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

#import "UIScreen+WBUIScreen.h"

@implementation UIScreen (WBUIScreen)
+(CGFloat)caculateScreenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
+(CGFloat)caculateHight{
    return 64;
}
+(CGFloat)caculateScreenHight{
    return [UIScreen mainScreen].bounds.size.height;

}

@end
