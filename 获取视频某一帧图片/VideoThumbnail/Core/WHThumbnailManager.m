//
//  WHThumbnailManager.m
//  My
//
//  Created by WangHui on 2016/12/1.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import "WHThumbnailManager.h"

#import "WHMovieDecode.h"

#import "WHNetworkActivityIndicator.h"

#define TimeInterval 60 * 5 //5分钟清空一次缓存

@interface WHThumbnailManager()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSOperation *currentOperation;
@property (nonatomic, strong, readwrite) WHImageCache *imageCache;
@property (nonatomic, strong) NSMutableSet *downloadInURLs;

@end

@implementation WHThumbnailManager

#pragma mark -
#pragma mark sharedManager & init
+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    if (self == [super init])
    {
        _imageCache = [WHImageCache new];
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 3;
        _downloadInURLs = [NSMutableSet new];
        
#if TARGET_OS_IOS
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemoryCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOperationQueue) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif
    }
    return self;
}

#pragma mark -
#pragma mark downloadImage
/**
 根据视频URL截图某一秒的图片

 @param url 视频URL
 @param minDuration 秒数
 @param success 成功回调
 return operation
 */
- (NSOperation *)downloadImageWithVideoURL:(NSString *)url atTime:(CGFloat)minDuration success:(void (^)(UIImage *image))success
{
    if (!url || url.length == 0) return nil;
    
    //1.判断内存缓存有没有image，如果有直接返回
    if ([self queryImageFromMemoryCacheWithUrlkey:url success:success]) return nil;
    
    //2.判断当前url是不是正在下载，如果在下载，用NSOperationQueue依赖进行拦截，然后重缓存中读取image进行返回
    BOOL isDownloadIn = NO;
    @synchronized (self.downloadInURLs)
    {//判断当前URL是不是正在下载，防止重复添加下载
        isDownloadIn = [self.downloadInURLs containsObject:url];
    }
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation new];
    if (isDownloadIn)
    {//如果当前URL在下载过程中，就添加依赖等待第一个URL下载结束后，存到内存缓存，然后去缓存中读取image刷新界面
        [operation addExecutionBlock:^{
            [weakSelf queryImageFromMemoryCacheWithUrlkey:url success:success];
        }];
        [operation addDependency:self.currentOperation];
        [self.queue addOperation:operation];
        return operation;
    }
    
    [[WHNetworkActivityIndicator sharedActivityIndicator] startActivity];
    [operation addExecutionBlock:^{
        @synchronized (weakSelf.downloadInURLs)
        {
            [weakSelf.downloadInURLs addObject:url];
        }
        
        // 获取指定时间第一帧图片
        UIImage *imageFrame = [WHMovieDecode.new movieDecode:url withDuration:minDuration];
        
        @synchronized (weakSelf.downloadInURLs)
        {
            [weakSelf.downloadInURLs removeObject:url];
            [[WHNetworkActivityIndicator sharedActivityIndicator] stopActivity];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(imageFrame, 0.2f);
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && imageData)
        {
            [weakSelf.imageCache cacheImage:image forKey:url];
            
            if (success) success(image);
        }
    }];
    [_queue addOperation:operation];
    self.currentOperation = operation;
    return operation;
}

/**
 根据key从内存缓存中查询图片

 @param url key
 @param success 成功回调
 */
- (BOOL)queryImageFromMemoryCacheWithUrlkey:(NSString *)url success:(void (^)(UIImage *image))success
{
    UIImage *image = [_imageCache imageFromMemoryCacheForKey:url];
    if (image && success)
    {// 内存缓存中读取
        success(image);
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark dealloc
/**
 取消正在下载的队列
 */
- (void)cancelOperationQueue
{
    @synchronized (self.downloadInURLs)
    {
        [self.downloadInURLs removeAllObjects];
    }
    
    [_queue cancelAllOperations];
    [[WHNetworkActivityIndicator sharedActivityIndicator] stopAllActivity];
}

/**
 清空内存缓存
 */
- (void)clearMemoryCache
{
    [_imageCache clearMemory];
}

- (void)dealloc
{
    [self cancelOperationQueue];
    [self clearMemoryCache];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
