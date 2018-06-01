//
//  WHMovieDecode.m
//  获取视频某一帧图片
//
//  Created by WangHui on 2017/7/26.
//  Copyright © 2017年 wanghui. All rights reserved.
//

#import "WHMovieDecode.h"

#import <VideoToolbox/VideoToolbox.h>
#import <libavcodec/avcodec.h>
#import <libavformat/avformat.h>
#import <libswscale/swscale.h>
#import <libavutil/imgutils.h>

@implementation WHMovieDecode

static UIImage *image;

+ (void)initialize
{
    // 所有的存储格式和编码格式
    av_register_all();
    avformat_network_init();
}

/**
 根据 URL 解码视频, 并返回指定时间的第一帧图片

 @param url 路径
 @param duration 指定时间
 */
- (UIImage *)movieDecode:(NSString *)url withDuration:(int64_t)duration
{
    int ret = GetDurationFirstIFrameAndConvertToPic(url.UTF8String, duration);
    if (ret < 0) image = nil;
    NSLog(@"%d", ret);
    return image;
}

/**
 得到指定时间第一个I帧并且转换成图片

 @param url 文件路径
 @param duration 指定时间
 @return 0 : 成功, 其余都是失败
 */
int GetDurationFirstIFrameAndConvertToPic(const char *url, int64_t duration)
{
    // 视频流的格式内容
    AVFormatContext *pFormatCtx = NULL;
    // 读取文件的头部并且把信息保存到我们给的AVFormatContext结构
    if (avformat_open_input(&pFormatCtx, url, NULL, NULL) != 0)
    {
        NSLog(@"打开文件失败");
        return -1;
    }
    
    // 检查在文件中的流的信息
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0)
    {
        NSLog(@"文件中没有流的信息");
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    // 打印有关输入或输出格式的详细信息
    av_dump_format(pFormatCtx, 0, url, 0);
    
    int videoStream = -1;
    // 找到第一个视频流
    for (int i = 0; i < pFormatCtx->nb_streams; i++)
    {
        if(pFormatCtx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO)
        {
            videoStream = i;
            break;
        }
    }
    if (videoStream == -1)
    {
        NSLog(@"没有找到第一个视频流");
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    // 流中关于编解码器的信息就是被我们叫做"codec context"（编解码器上下文）的东西。
    // 这里面包含了流中所使用的关于编解码器的所有信息，现在我们有了一个指向他的指针。
    // 但是我们必需要找到真正的编解码器并且打开它
    // 创建编码器上下文
    AVCodecContext *pCodecCtx = avcodec_alloc_context3(NULL);
    if (pCodecCtx == NULL)
    {
        NSLog(@"创建编码器上下文失败");
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    if (avcodec_parameters_to_context(pCodecCtx, pFormatCtx->streams[videoStream]->codecpar) < 0)
    {
        NSLog(@"AVCodecContext 赋值失败");
        avcodec_free_context(&pCodecCtx);
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    AVCodec *pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (pCodec == NULL)
    {
        NSLog(@"没找到解码器");
        avcodec_free_context(&pCodecCtx);
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    // 打开avcodec
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0)
    {
        NSLog(@"解码器打开失败");
        avcodec_free_context(&pCodecCtx);
        avformat_close_input(&pFormatCtx);
        return -1;
    }
    
    // YUV帧, 原始帧
    AVFrame *pFrame = av_frame_alloc();
    
    // 因为我们准备输出保存24位RGB色的PPM文件，我们必需把帧的格式从原来的转换为RGB。
    // FFMPEG将为我们做这些转换。
    // 在大多数项目中（包括我们的这个）我们都想把原始的帧转换成一个特定的格式。
    // 让我们先为转换来申请一帧的内存
    AVFrame *pFrameRGB = av_frame_alloc();
    
    // 即使我们申请了一帧的内存，当转换的时候，我们仍然需要一个地方来放置原始的数据。
    // 我们使用avpicture_get_size来获得我们需要的大小，然后手工申请内存空间：
    int numBytes = av_image_get_buffer_size(AV_PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height, 1);
    uint8_t *buffer = (uint8_t *)av_malloc(numBytes * sizeof(uint8_t));
    
    // 现在我们使用avpicture_fill来把帧和我们新申请的内存来结合。
    // 关于AVPicture的结成：AVPicture结构体是AVFrame结构体的子集
    // ――AVFrame结构体的开始部分与AVPicture结构体是一样的。
    av_image_fill_arrays(pFrameRGB->data, pFrameRGB->linesize, buffer, AV_PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height, 1);
    
    if (pFormatCtx->duration > duration)
    {
        // 播放指定duration的任意帧
        av_seek_frame(pFormatCtx, -1, duration * AV_TIME_BASE, AVSEEK_FLAG_ANY);
        // 清空解码器的缓存
        avcodec_flush_buffers(pCodecCtx);
    }
    
    // 视频像素上下文
    struct SwsContext *sws_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_RGB24, SWS_POINT, NULL, NULL, NULL);
    
    // 最后，我们已经准备好来从流中读取数据了。
    // 读取数据
    // 我们将要做的是通过读取包来读取整个视频流，
    // 然后把它解码成帧，最好后转换格式并且保存。
    AVPacket packet;
    
    while (av_read_frame(pFormatCtx, &packet) >= 0)
    {
        // Is this a packet from the video stream?
        if (packet.stream_index == videoStream)
        {
            // Decode video frame
            int result = avcodec_send_packet(pCodecCtx, &packet);
            while (result >= 0)
            {
                // Did we get a video frame?
                result = avcodec_receive_frame(pCodecCtx, pFrame);
                if (result >= 0)
                {
                    // 将图像从原始格式转换为RGB
                    sws_scale(sws_ctx, (uint8_t const * const *)pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameRGB->data, pFrameRGB->linesize);
                    
                    // 帧转成图片,保存在内存
                    image = frameConvertImage(pFrameRGB, pCodecCtx->width, pCodecCtx->height);
                    
                    // Save the frame to disk.
//                    SaveFrameToPPM(pFrameRGB, pCodecCtx->width, pCodecCtx->height);
                    av_packet_unref(&packet);
                    break;
                }
            }
            
            if (packet.data == NULL)
                break;
        }
        av_packet_unref(&packet);
    }
    
    sws_freeContext(sws_ctx);
    
    // Free the RGB image.
    av_free(buffer);
    av_frame_free(&pFrameRGB);
    
    // Free the YUV frame.
    av_frame_free(&pFrame);
    
    avcodec_free_context(&pCodecCtx);
    
    // Close the codecs.
    avcodec_close(pCodecCtx);
    
    // Close the video file.
    avformat_close_input(&pFormatCtx);
    
    return 0;
}

/**
 帧转换成图片

 @param pFrameRGB RGB格式帧
 @param width 图像的宽度
 @param height 图像的宽度
 */
UIImage *frameConvertImage(AVFrame *pFrameRGB, int width, int height)
{
    int linesize = pFrameRGB->linesize[0];
    
    NSData *data = [NSData dataWithBytes:pFrameRGB->data[0] length:linesize * height];
    
    UIImage *image = nil;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
    if (provider)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace)
        {
            CGImageRef imageRef = CGImageCreate(width, height, 8, 24, linesize, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, YES, kCGRenderingIntentDefault);
            
            if (imageRef)
            {
                image = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
            }
            CGColorSpaceRelease(colorSpace);
        }
        CGDataProviderRelease(provider);
    }
    
    return image;
}

/**
 文件的头部表示了图像的宽度和高度以及最大的RGB值的大小。
 保存帧数据为PPM图片

 @param pFrame 帧
 @param width 图像的宽度
 @param height 图像的高度
 */
void SaveFrameToPPM(AVFrame *pFrame, int width, int height)
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ppm", getTimeNow()]];
    
    // Open file.
    FILE *pFile = fopen(filePath.UTF8String, "wb");
    if (pFile == NULL)
    {
        return;
    }
    
    // Write header.
    fprintf(pFile, "P6\n%d %d\n255\n", width, height);
    
    // Write pixel data.
    for (int y = 0; y < height; y++)
    {
        fwrite(pFrame->data[0] + y * pFrame->linesize[0], 1, width * 3, pFile);
    }
    
    // Close file.
    fclose(pFile);
}

/**
 得到当前时间
 
 @return 时间-随机数
 */
NSString *getTimeNow()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    return timeNow;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
