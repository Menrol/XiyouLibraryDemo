//
//  WRQMyTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQMyTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQMyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init{
    self=[super init];
    if (self) {
        self.headImage=[[UIImageView alloc]init];
        self.headImage.layer.masksToBounds=YES;
        self.headImage.layer.cornerRadius=H*0.065;
        self.headImage.backgroundColor=[UIColor whiteColor];
        self.headImage.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(H*0.05);
            make.size.mas_equalTo(CGSizeMake(H*0.13, H*0.13));
        }];
        
        self.loginLabel=[[UILabel alloc]init];
        self.loginLabel.text=@"请登录";
        self.loginLabel.font=[UIFont systemFontOfSize:20];
        self.loginLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:self.loginLabel];
        [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImage.mas_bottom).with.offset(H*0.02);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(W*0.17, H*0.03));
        }];
        
        self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame=CGRectMake(W*0.87, H*0.04, H*0.05, H*0.05);
        [self.loginButton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        self.loginButton.contentMode=UIViewContentModeCenter;
        [self.contentView addSubview:self.loginButton];
        
        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.font=[UIFont boldSystemFontOfSize:22];
        self.nameLabel.textColor=[UIColor whiteColor];
        self.nameLabel.hidden=YES;
        [self.contentView addSubview:self.nameLabel];
        
        self.myView=[[WRQMyView alloc]init];
        self.myView.hidden=YES;
        [self.contentView addSubview:self.myView];
        [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).with.offset(H*0.04);
            make.left.equalTo(self).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W, H*0.1));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
