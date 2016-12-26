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
    NSString *m3u8Str = @"http://117.148.136.28/PLTV/88888888/224/3221225696/index.m3u8?rrsip=117.148.136.26,rrsip=117.148.136.27&zoneoffset=0&servicetype=1&icpid=&accounttype=1&limitflux=-1&limitdur=-1&accountinfo=%7E%7EV2.0%7E6MXvTBbUVaUZMATL0Wydgg%7EPVFd54lMy2QdOQZfiLOPzp7KRmCrnnLiEo98JCinQCwx4kTMQ7Ne7ihMWOoG_N0GzABTUj6q4A98B-suKZ0A3NkLu-JKAxiprojg_62CSesBm2aCgNY-ELVe5mBiCMMv%2C110252382222909628%2C58.240.115.2%2C20161201103828%2CXTV100000302%2C2D5DB350D5D784D30FB24AC1810561DF%2C-1%2C0%2C1%2C%2C%2C2%2C%2C%2C%2C2%2Cguest%2C0%2Cguest%2Cf0e7028b-2b99-4ca5-9f0d-daadeda869df%2C1%2CEND&GuardEncType=2|http://117.148.136.28/PLTV/88888888/224/3221225696/index.m3u8?rrsip=117.148.136.26,rrsip=117.148.136.27&zoneoffset=0&servicetype=2&icpid=&accounttype=1&limitflux=-1&limitdur=-1&accountinfo=%7E%7EV2.0%7E6MXvTBbUVaUZMATL0Wydgg%7EPVFd54lMy2QdOQZfiLOPzp7KRmCrnnLiEo98JCinQCwx4kTMQ7Ne7ihMWOoG_N0GzABTUj6q4A98B-suKZ0A3NkLu-JKAxiprojg_62CSesBm2aCgNY-ELVe5mBiCMMv%2C110252382222909628%2C58.240.115.2%2C20161201103828%2CXTV100000302%2C2D5DB350D5D784D30FB24AC1810561DF%2C-1%2C0%2C1%2C%2C%2C7%2C%2C%2C%2C4%2Cguest%2C0%2Cguest%2Cf0e7028b-2b99-4ca5-9f0d-daadeda869df%2C1%2CEND&GuardEncType=2";
    WHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setUp:m3u8Str];
    
    return cell;
}


@end
