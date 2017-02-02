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
        
        UILabel *borrowtitle=[[UILabel alloc]initWithFrame:CGRectMake(0, H*0.07, W*0.2, H*0.02)];
        borrowtitle.text=@"可借图书：";
        borrowtitle.font=[UIFont systemFontOfSize:13];
        [self addSubview:borrowtitle];
        
        self.borrowLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.2, H*0.07, W*0.2, H*0.02)];
        self.borrowLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.borrowLabel];
        
        UILabel *totaltitle=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.07, W*0.2, H*0.02)];
        totaltitle.text=@"共有图书：";
        totaltitle.font=[UIFont systemFontOfSize:13];
        [self addSubview:totaltitle];
        
        self.totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.7, H*0.07, W*0.2, H*0.02)];
        self.totalLabel.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.totalLabel];

    }
    return self;
}
@end
