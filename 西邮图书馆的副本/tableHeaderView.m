//
//  tableHeaderView.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "tableHeaderView.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation tableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.29)];
        backgroundImage.image=[UIImage imageNamed:@"background"];
        [self addSubview:backgroundImage];
        
        self.bookImageView=[[UIImageView alloc]initWithFrame:CGRectMake((W-W*0.35)/2, H*0.01, W*0.35, H*0.27)];
        self.bookImageView.backgroundColor=[UIColor grayColor];
        [backgroundImage addSubview:self.bookImageView];
        
        self.nopictureImage=[[UIImageView alloc]init];
        [self.bookImageView addSubview:self.nopictureImage];
        [self.nopictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(self.bookImageView);
            make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
        }];
        self.nopictureImage.image=[UIImage imageNamed:@"final.png"];
    }
    return self;
}

@end
