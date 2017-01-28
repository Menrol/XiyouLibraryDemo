//
//  WRQMyTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQMyTableViewCell.h"
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
        self.headImage=[[UIImageView alloc]initWithFrame:CGRectMake(W*0.05, H*0.11, H*0.1, H*0.1)];
        self.headImage.layer.masksToBounds=YES;
        self.headImage.layer.cornerRadius=H*0.05;
        self.headImage.image=[UIImage imageNamed:@"nomalhead.png"];
        self.headImage.backgroundColor=[UIColor whiteColor];
        self.headImage.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.headImage];
        
        self.loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.3, H*0.15, W*0.2, H*0.03)];
        self.loginLabel.text=@"请登录";
        self.loginLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:self.loginLabel];
        
        self.loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame=CGRectMake(W*0.85, H*0.05, H*0.06, H*0.06);
        self.loginButton.layer.masksToBounds=YES;
        self.loginButton.layer.cornerRadius=H*0.03;
        self.loginButton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.loginButton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        self.loginButton.contentMode=UIViewContentModeCenter;
        [self.contentView addSubview:self.loginButton];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.3, H*0.11, W*0.3, H*0.06)];
        self.nameLabel.font=[UIFont boldSystemFontOfSize:22];
        self.nameLabel.textColor=[UIColor whiteColor];
        self.nameLabel.hidden=YES;
        [self.contentView addSubview:self.nameLabel];
        
        self.classLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.3, H*0.18, W*0.2, H*0.03)];
        self.classLabel.font=[UIFont systemFontOfSize:16];
        self.classLabel.textColor=[UIColor whiteColor];
        self.classLabel.hidden=YES;
        [self.contentView addSubview:self.classLabel];
        
        self.numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.55, H*0.18, W*0.2, H*0.03)];
        self.numberLabel.font=[UIFont systemFontOfSize:16];
        self.numberLabel.textColor=[UIColor whiteColor];
        self.numberLabel.hidden=YES;
        [self.contentView addSubview:self.numberLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
