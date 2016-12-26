//
//  WHImageCache.m
//  My
//
//  Created by WangHui on 2016/12/5.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import "WHImageCache.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "YYCache.h"

static const int kDefaultCacheMaxCacheTime = 60 * 5; // 5分钟

@interface WHImageCache()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation WHImageCache


- (instancetype)init
{
    if (self == [super init])
    {
        _cache = [[YYCache alloc] initWithName:@"VideoUrlThumbnailCache"];
    }
    return self;
}

/**
 image缓存到内存中

 @param image image
 @param Urlkey Urlkey
 */
- (void)cacheImage:(UIImage *)image forKey:(NSString *)Urlkey
{
    if (image && Urlkey)
    {
        [self setObject:image forKey:Urlkey];
        [self cacheDateWith:self.md5Key(Urlkey)];
    }
}

/**
 根据Key获取缓中的image
 
 @param Urlkey UrlKey
 @return 返回获取到image
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)Urlkey
{
    [self currentDateAndCahceDateTimeIntervalWithUrlkey:Urlkey];
    return [self objectForKey:Urlkey];
}

/**
 清空内存缓存
 */
- (void)clearMemory
{
    [self removeAllObjects];
}

/**
 根据urlKey判断当前时间和缓存的时间差，如果时间差超过5分钟那就清除缓存

 @param Urlkey URLkey
 */
- (void)currentDateAndCahceDateTimeIntervalWithUrlkey:(NSString *)Urlkey
{
    NSDate *oldDate = (NSDate *)[_cache objectForKey:self.md5Key(Urlkey)];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:oldDate];
    BOOL isEqual = lround(interval) > kDefaultCacheMaxCacheTime;
    if (isEqual)
    {
        [self removeObjectForKey:Urlkey]; 
    }
}

/**
 缓存URL存储时间

 @param Urlkey url
 */
- (void)cacheDateWith:(NSString *)Urlkey
{
    [_cache setObject:[NSDate date] forKey:Urlkey];
}

- (NSString *(^)(NSString *key))md5Key
{
    __weak typeof(self) weakSelf = self;
    return ^(NSString *key){
        return [weakSelf md5:key];
    };
}

- (NSString *)md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
