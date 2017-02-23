//
//  nonetworkView.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/21.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "NoNetworkView.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation NoNetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self=[super init];
    if (self) {
        UIImageView *nonetworkImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fail.png"]];
        [self addSubview:nonetworkImageView];
        [nonetworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(H*0.15, H*0.15));
        }];
        
        UILabel *failLabel=[[UILabel alloc]init];
        failLabel.text=@"加载数据失败";
        failLabel.font=[UIFont systemFontOfSize:18];
        [self addSubview:failLabel];
        [failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nonetworkImageView.mas_bottom).with.offset(H*0.02);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(W*0.3, H*0.03));
        }];
        
        self.reloadButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.reloadButton setTitle:@"重试" forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.reloadButton.titleLabel.font=[UIFont systemFontOfSize:18];
        self.reloadButton.layer.borderWidth=1;
        self.reloadButton.layer.borderColor=[UIColor grayColor].CGColor;
        [self addSubview:self.reloadButton];
        [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(failLabel.mas_bottom).with.offset(H*0.02);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
    }
    return self;
}

@end
