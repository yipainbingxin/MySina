//
//  NSString+ExtentionPath.h
//  WaveProject
//
//  Created by 冰 on 2016/12/7.
//  Copyright © 2016年 hzmohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ExtentionPath)

//给当前文件夹追加文档路径
-(NSString*)cz_appendDocumentDir;

//给当前文件夹追加缓存路径
-(NSString*)cz_appendCacheDir;


//给当前文件夹追加临时路径
-(NSString*)cz_appendTempDir;

@end
