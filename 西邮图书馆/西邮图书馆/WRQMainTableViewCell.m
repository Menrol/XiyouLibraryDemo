//
//  WRQMainTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/17.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQMainTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        self.titleLabel.numberOfLines=0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.8, H*0.03));
        }];
        
        self.dateLabel=[[UILabel alloc]init];
        self.dateLabel.font=[UIFont systemFontOfSize:13];
        self.dateLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
    }
    return self;
}

@end
