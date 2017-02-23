//
//  tableCirculationView.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "tableCirculationView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation tableCirculationView

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
        
        UIView *background=[[UIView alloc]initWithFrame:CGRectMake(W*0.05, H*0.07, W*0.9, H*0.04)];
        background.layer.masksToBounds=YES;
        background.layer.cornerRadius=10;
        background.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:background];
        
        UILabel *borrowtitle=[[UILabel alloc]initWithFrame:CGRectMake(W*0.15, H*0.08, W*0.2, H*0.02)];
        borrowtitle.text=@"可借图书：";
        borrowtitle.font=[UIFont systemFontOfSize:13];
        [self addSubview:borrowtitle];
        
        self.borrowLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.35, H*0.08, W*0.2, H*0.02)];
        self.borrowLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.borrowLabel];
        
        UILabel *totaltitle=[[UILabel alloc]initWithFrame:CGRectMake(W*0.55, H*0.08, W*0.2, H*0.02)];
        totaltitle.text=@"共有图书：";
        totaltitle.font=[UIFont systemFontOfSize:13];
        [self addSubview:totaltitle];
        
        self.totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.75, H*0.08, W*0.2, H*0.02)];
        self.totalLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.totalLabel];
    }
    return self;
}
@end
