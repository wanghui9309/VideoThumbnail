//
//  WHMovieDecode.h
//  获取视频某一帧图片
//
//  Created by WangHui on 2017/7/26.
//  Copyright © 2017年 wanghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 视频解码
 */
@interface WHMovieDecode : NSObject

/**
 根据 URL 解码视频, 并返回指定时间的第一帧图片
 
 @param url 路径
 @param duration 指定时间
 */
- (UIImage *)movieDecode:(NSString *)url withDuration:(int64_t)duration;

@end
