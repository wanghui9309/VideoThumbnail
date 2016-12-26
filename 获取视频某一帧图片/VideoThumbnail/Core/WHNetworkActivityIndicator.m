//
//  WHNetworkActivityIndicator.m
//  NBTV
//
//  Created by WangHui on 2016/12/8.
//  Copyright © 2016年 yijie. All rights reserved.
//

#import "WHNetworkActivityIndicator.h"

@interface WHNetworkActivityIndicator()

@property (nonatomic, assign) NSInteger counter;

@end

@implementation WHNetworkActivityIndicator

+ (instancetype)sharedActivityIndicator
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _counter = 0;
    }
    
    return self;
}

/**
 开始下载活动
 */
- (void)startActivity
{
    @synchronized(self)
    {
        _counter++;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

/**
 关闭下载活动
 */
- (void)stopActivity
{
    @synchronized(self)
    {
        if (_counter > 0 && --_counter == 0)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

/**
 关闭全部下载活动
 */
- (void)stopAllActivity
{
    @synchronized(self)
    {
        _counter = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
