//
//  UIView+CacheOperation.m
//  NBTV
//
//  Created by WangHui on 2016/12/8.
//  Copyright © 2016年 yijie. All rights reserved.
//

#import "UIView+CacheOperation.h"

#import <objc/message.h>

static char loadImageOperationKey;

@implementation UIView (WHCacheOperation)

- (NSMutableDictionary *)imageOperationDictionary
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &loadImageOperationKey);
    if (dict)
    {
        return dict;
    }
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadImageOperationKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

/**
 保存加载中的operation

 @param operation operation
 @param key key
 */
- (void)wh_setImageLoadOperation:(NSOperation *)operation withKey:(NSString *)key
{
    [self wh_cancelImageLoadOperationWithkey:key];
    NSMutableDictionary *dict = [self imageOperationDictionary];
    dict[key] = operation;
}

/**
 cancel operation

 @param key key
 */
- (void)wh_cancelImageLoadOperationWithkey:(NSString *)key
{
    NSMutableDictionary *dict = [self imageOperationDictionary];
    NSOperation *operation = dict[key];
    if (operation)
    {
        [operation cancel];
        operation = nil;
        [dict removeObjectForKey:key];
    }
}

/**
 移除全部operation
 */
- (void)wh_removeAllImageLoadOperation
{
    NSMutableDictionary *dict = [self imageOperationDictionary];
    [dict removeAllObjects];
}

@end
