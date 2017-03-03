//
//  myView.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/8.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQMyView.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQMyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self=[super init];
    if (self) {
        self.classImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class.png"]];
        [self addSubview:self.classImageView];
        [self.classImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(W*0.2);
            make.top.equalTo(self).with.offset(H*0.005);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.classLabel=[[UILabel alloc]init];
        self.classLabel.font=[UIFont systemFontOfSize:14];
        self.classLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.classLabel];
        [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.classImageView.mas_bottom).with.offset(0);
            make.centerX.equalTo(self.classImageView);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"whiteline.png"]];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.01);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.08));
        }];
        
        self.numberImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"number.png"]];
        [self addSubview:self.numberImageView];
        [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.classImageView.mas_right).with.offset(W*0.4);
            make.top.equalTo(self).with.offset(H*0.005);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.numberLabel=[[UILabel alloc]init];
        self.numberLabel.font=[UIFont systemFontOfSize:14];
        self.numberLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.numberImageView);
            make.top.equalTo(self.numberImageView.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.18, H*0.03));
        }];
    }
    self.backgroundColor=[UIColor colorWithRed:0.24 green:0.55 blue:0.76 alpha:1.00];
    return self;
}
@end
