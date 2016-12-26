//
//  UIView+CacheOperation.h
//  NBTV
//
//  Created by WangHui on 2016/12/8.
//  Copyright © 2016年 yijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WHCacheOperation)

/**
 保存加载中的operation
 
 @param operation operation
 @param key key
 */
- (void)wh_setImageLoadOperation:(NSOperation *)operation withKey:(NSString *)key;

/**
 cancel operation
 
 @param key key
 */
- (void)wh_cancelImageLoadOperationWithkey:(NSString *)key;

/**
 移除全部operation
 */
- (void)wh_removeAllImageLoadOperation;

@end
