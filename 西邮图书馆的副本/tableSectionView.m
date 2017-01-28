
//
//  tableSectionView.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "tableSectionView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation tableSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.numberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, H*0.06, H*0.06)];
        [self addSubview:self.numberImageView];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(H*0.07, H*0.01, W*0.3, H*0.05)];
        self.titleLabel.font=[UIFont boldSystemFontOfSize:23];
        [self addSubview:self.titleLabel];
        
        self.collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(W*0.5+H*0.08, 0, H*0.06, H*0.06)];
        self.collectImageView.image=[UIImage imageNamed:@"collect.png"];
        [self addSubview:self.collectImageView];
        
        self.collectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.collectBtn.frame=CGRectMake(W*0.5+H*0.13, H*0.01, W*0.2, H*0.05);
        [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectBtn setTintColor:[UIColor blackColor]];
        self.collectBtn.titleLabel.font=[UIFont boldSystemFontOfSize:23];
        [self addSubview:self.collectBtn];
    }
    return self;
}

@end
