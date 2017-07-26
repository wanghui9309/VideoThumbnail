//
//  WHNetworkActivityIndicator.h
//  NBTV
//
//  Created by WangHui on 2016/12/8.
//  Copyright © 2016年 yijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHNetworkActivityIndicator : NSObject

+ (id)sharedActivityIndicator;
/**
 开始下载活动
 */
- (void)startActivity;
/**
 关闭下载活动
 */
- (void)stopActivity;
/**
 关闭全部下载活动
 */
- (void)stopAllActivity;


@end
