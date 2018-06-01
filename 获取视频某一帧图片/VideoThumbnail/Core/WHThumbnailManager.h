//
//  WHThumbnailManager.h
//  My
//
//  Created by WangHui on 2016/12/1.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WHImageCache.h"

@interface WHThumbnailManager : NSObject

@property (nonatomic, strong, readonly) WHImageCache *imageCache;

+ (instancetype)sharedManager;

/**
 根据视频URL截图某一秒的图片
 
 @param url 视频URL
 @param minDuration 秒数
 @param completedBlock 操作回调
 return operation
 */
- (NSOperation *)downloadImageWithVideoURL:(NSString *)url atTime:(CGFloat)minDuration completedBlock:(void (^)(UIImage *image, BOOL finished))completedBlock;

/**
 取消正在下载的队列
 */
- (void)cancelOperationQueue;

@end
