//
//  NSString+ExtentionPath.m
//  WaveProject
//
//  Created by 冰 on 2016/12/7.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

#import "NSString+ExtentionPath.h"

@implementation NSString (ExtentionPath)

//给当前文件夹追加文档路径
-(NSString*)cz_appendDocumentDir{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:[self lastPathComponent]];
    
    
}

//给当前文件夹追加缓存路径
-(NSString*)cz_appendCacheDir{
    
    // 1.获取caches目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    // 2.拼接路径
    return [cachesDir stringByAppendingPathComponent:[self lastPathComponent]];
}


//给当前文件夹追加临时路径
-(NSString*)cz_appendTempDir{
    // 1.获取caches目录
    NSString *path = NSTemporaryDirectory();
    // 2.拼接路径
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

@end
