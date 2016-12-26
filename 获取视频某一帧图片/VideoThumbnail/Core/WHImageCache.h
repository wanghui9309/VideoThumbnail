//
//  WHImageCache.h
//  My
//
//  Created by WangHui on 2016/12/5.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHImageCache : NSCache

/**
 image缓存到内存中
 
 @param image image
 @param Urlkey Urlkey
 */
- (void)cacheImage:(UIImage *)image forKey:(NSString *)Urlkey;

/**
 根据Key获取缓中的image
 
 @param Urlkey UrlKey
 @return 返回获取到image
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)Urlkey;

/**
 清空内存缓存
 */
- (void)clearMemory;

@end
