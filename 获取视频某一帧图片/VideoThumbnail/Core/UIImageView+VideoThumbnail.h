//
//  UIImageView+VideoThumbnail.h
//  My
//
//  Created by WangHui on 2016/12/1.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (VideoThumbnail)

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url;

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 @param placeholder 占位图
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 @param minDuration 秒数
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url atTime:(CGFloat)minDuration;

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 @param placeholder 占位图
 @param minDuration 秒数
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder atTime:(CGFloat)minDuration;

@end
