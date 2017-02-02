//
//  WRQBooKbasicTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/17.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBooKbasicTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQBooKbasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)init{
    self=[super init];
    if (self) {
        UILabel *authortitleLabel=[[UILabel alloc]init];
        authortitleLabel.text=@"作者:";
        authortitleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:authortitleLabel];
        [authortitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.03));
        }];
        
        self.authorLabel=[[UILabel alloc]init];
        self.authorLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.authorLabel];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.01);
            make.left.equalTo(authortitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.8, H*0.03));
        }];
        
        UILabel *sorttitleLabel=[[UILabel alloc]init];
        sorttitleLabel.text=@"索书号:";
        sorttitleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:sorttitleLabel];
        [sorttitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authortitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.15, H*0.03));
        }];
        
        self.sortLabel=[[UILabel alloc]init];
        self.sortLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.sortLabel];
        [self.sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.authorLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(sorttitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.6, H*0.03));
        }];
        
        UILabel *pubtitleLabel=[[UILabel alloc]init];
        pubtitleLabel.text=@"出版社:";
        pubtitleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:pubtitleLabel];
        [pubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sorttitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.15, H*0.03));
        }];
        
        self.PubLabel=[[UILabel alloc]init];
        self.PubLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.PubLabel];
        [self.PubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sortLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(pubtitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.6, H*0.03));
        }];
        
        UILabel *FavtitleLabel=[[UILabel alloc]init];
        FavtitleLabel.text=@"收藏次数:";
        FavtitleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:FavtitleLabel];
        [FavtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pubtitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        self.FavLabel=[[UILabel alloc]init];
        self.FavLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.FavLabel];
        [self.FavLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.PubLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(FavtitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.6, H*0.03));
        }];
        
        UILabel *renttimestitleLabel=[[UILabel alloc]init];
        renttimestitleLabel.text=@"借阅次数:";
        renttimestitleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:renttimestitleLabel];
        [renttimestitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FavtitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        self.renttimesLabel=[[UILabel alloc]init];
        self.renttimesLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.renttimesLabel];
        [self.renttimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.FavLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(renttimestitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.6, H*0.03));
        }];
    }
    return self;
}
@end
