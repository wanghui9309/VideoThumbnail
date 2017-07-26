//
//  UIImageView+VideoThumbnail.m
//  My
//
//  Created by WangHui on 2016/12/1.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import "UIImageView+VideoThumbnail.h"

#import "WHThumbnailManager.h"

#import "UIView+CacheOperation.h"

@implementation UIImageView (VideoThumbnail)

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url
{
    [self wh_setThumbnailImageForVideoWithURL:url placeholderImage:nil atTime:0];
}

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 @param placeholder 占位图
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    [self wh_setThumbnailImageForVideoWithURL:url placeholderImage:placeholder atTime:0];
}

/**
 根据URL获取视频某一秒缩略图
 
 @param url 视频URL
 @param minDuration 秒数
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url atTime:(CGFloat)minDuration
{
    [self wh_setThumbnailImageForVideoWithURL:url placeholderImage:nil atTime:minDuration];
}

/**
 根据URL获取视频某一秒缩略图

 @param url 视频URL
 @param placeholder 占位图
 @param minDuration 秒数
 */
- (void)wh_setThumbnailImageForVideoWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder atTime:(CGFloat)minDuration
{
    [self wh_cancelImageLoadOperationWithkey:[NSString stringWithFormat:@"%p", self]];
    if (placeholder)
    {
        self.image = placeholder;
    }
    else
    {
        self.image = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    NSOperation *opertaion = [WHThumbnailManager.sharedManager downloadImageWithVideoURL:url atTime:minDuration success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf) return;
            [weakSelf scaleToSize:image];
        });
    }];
    if (opertaion)
    {
        [self wh_setImageLoadOperation:opertaion withKey:[NSString stringWithFormat:@"%p", self]];
    }
}

/**
 按照源图片的宽、高比例压缩至目标宽、高

 @param image 源图
 */
- (void)scaleToSize:(UIImage *)image
{
    CGSize newSize = self.bounds.size;
    if (image)
    {
        if ([NSStringFromCGSize(self.image.size) isEqualToString:NSStringFromCGSize(image.size)])
        {
            self.image = image;
            return;
        }
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        CGFloat widthFactor = newSize.width / width;
        CGFloat heightFactor = newSize.height / height;
        CGFloat scaleFactor = widthFactor < heightFactor ? widthFactor : heightFactor;
        
        width = width * scaleFactor * scale;
        height = height * scaleFactor * scale;
        
        UIGraphicsBeginImageContext(CGSizeMake(width,height));
        [image drawInRect:CGRectMake(0,0,width,height)];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

@end
