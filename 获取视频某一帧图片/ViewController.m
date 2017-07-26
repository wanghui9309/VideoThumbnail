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
    // 直播
//    NSString *m3u8Str = @"http://112.50.233.148/PLTV/88888888/224/3221226453/index.m3u8?rrsip=112.50.233.148&zoneoffset=0&servicetype=1&icpid=&accounttype=1&limitflux=-1&limitdur=-1&accountinfo=%2C7032e40715bc54283dc8f6652800319673108%2C58.240.69.198%2C20170725200713%2Cyestn_10000100000000050000000000846822%2C7032e40715bc54283dc8f665280031967310820170725200708%2C-1%2C0%2C1%2C%2C%2C2%2C%2C%2C%2C2%2C100002692%2C2%2C100002692%2C5811B4D6-BDEC-4433-8210-B0F61795C17D%2C%2C%2C3%2CEND&GuardEncType=2&it=H4sIAAAAAAAAADWOwU7DMBBE_8ZHy-vYbXzwqQgJCYVDA1e0WW_TqJsm2A0Sf08Tym00M280t4zEL0-xc45Sx7sqkHdQUW0rQApsvakpJKsKfzVTtIpQZLj2zZRW7ON4-ASw2htt7V4DONWui8-CfTRbuVnGjnO0u3_0yPl7II6pnPQs-LNk0WUeNv2e5RErbh_XwBsTajDgwt6r2-q2WC73RJ2xHKZxxszpdeo3IJ5QCqsZ6YI9NzhyvC4if9xbTvcrv4tw4j_0AAAA";
    
    // 电影
    NSString *m3u8Str = @"http://112.50.233.148/88888888/16/20170717/274459702/index.m3u8?rrsip=112.50.233.148&zoneoffset=0&servicetype=0&icpid=&accounttype=1&limitflux=-1&limitdur=-1&accountinfo=%2C7032e40715bc54283dc8f6661429901799391%2C58.240.69.198%2C20170725223524%2Cp_ystenappdb00000000000018494761%2C7032e40715bc54283dc8f6661429901799391%2C-1%2C1%2C0%2C%2C5%2C1%2C%2C%2C1603525%2C1%2C100002692%2C2%2C100002692%2C%2C%2C%2C3%2CEND&GuardEncType=2&it=H4sIAAAAAAAAADWOQQqDMBBFb5NlSLSiLrKyFAolLWi7LWMypmI0NrFCb18VuxiYgff-n8mDwvNRJFBzlmbZMvzAmjhPa60yrWPFtErznAR8SyciosDadjDS6VV7lMWT84gmjEZRSjk_kGpNPFkwgm2w_PQ1ehHHf7VEP7cKhQ4NnSFQMMajgal1A71Z-N693RGC1f4emdalgtCtxwtC4foRPOqLMxsjGrAByQiqA4MSetydq9dL-w9hekj_5wAAAA";
    
    WHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setUp:m3u8Str];
    
    return cell;
}


@end
