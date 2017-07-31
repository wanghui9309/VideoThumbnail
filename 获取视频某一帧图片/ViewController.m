//
//  ViewController.m
//  获取视频第一帧图片
//
//  Created by WangHui on 2016/12/26.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import "ViewController.h"

#import "WHTableViewCell.h"

@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mTableView.estimatedRowHeight = 500;
    self.mTableView.rowHeight = 200;
    [self.mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WHTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.mTableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 香港卫视
    NSString *rtmp = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    // 大熊兔（点播）
    NSString *rtsp = @"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov";
    // 香港卫视
    NSString *hks = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    // CCTV1高清
    NSString *cctv1 = @"http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8";
    // CCTV3高清
    NSString *cctv3 = @"http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8";
    // CCTV5高清
    NSString *cctv5 = @"http://ivi.bupt.edu.cn/hls/cctv5hd.m3u8";
    // CCTV5+高清
    NSString *cctv5phd = @"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8";
    // CCTV6高清
    NSString *cctv6 = @"http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8";
    
    NSArray *arr = @[rtmp, rtsp, hks, cctv1, cctv3, cctv5, cctv5phd, cctv6];
    
    WHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setUp:arr[arc4random_uniform((int)arr.count)]];
    
    return cell;
}


@end
