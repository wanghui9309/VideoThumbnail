//
//  WHTableViewCell.m
//  My
//
//  Created by WangHui on 2016/12/5.
//  Copyright © 2016年 wanghui. All rights reserved.
//

#import "WHTableViewCell.h"

#import "WHVideoThumbnail.h"

@interface WHTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation WHTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUp:(NSString *)url index:(int)index
{
    [self.imageV wh_setThumbnailImageForVideoWithURL:url placeholderImage:[UIImage imageNamed:@"erweima"]];
    self.lab.text = [NSString stringWithFormat:@"%d", index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
