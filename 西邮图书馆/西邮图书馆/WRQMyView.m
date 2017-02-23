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
        UIImageView *classImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class.png"]];
        [self addSubview:classImage];
        [classImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(W*0.2);
            make.top.equalTo(self).with.offset(H*0.005);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.classLabel=[[UILabel alloc]init];
        self.classLabel.font=[UIFont systemFontOfSize:16];
        self.classLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.classLabel];
        [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(classImage.mas_bottom).with.offset(0);
            make.centerX.equalTo(classImage);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        UIImageView *line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"whiteline.png"]];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.01);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.08));
        }];
        
        UIImageView *numberImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"number.png"]];
        [self addSubview:numberImage];
        [numberImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(classImage.mas_right).with.offset(W*0.4);
            make.top.equalTo(self).with.offset(H*0.005);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.numberLabel=[[UILabel alloc]init];
        self.numberLabel.font=[UIFont systemFontOfSize:16];
        self.numberLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(numberImage);
            make.top.equalTo(numberImage.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
    }
    self.backgroundColor=[UIColor colorWithRed:0.24 green:0.55 blue:0.76 alpha:1.00];
    return self;
}
@end
