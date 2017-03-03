//
//  WRQRemindTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/18.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQRemindTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQRemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-2.png"]];
        [self.contentView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(W*0.02);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.numberOfLines=0;
        self.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.02);
            make.left.equalTo(self).with.offset(W*0.15);
            make.size.mas_equalTo(CGSizeMake(W*0.6, 1));
        }];
        
        UILabel *barcodetitleLabel=[[UILabel alloc]init];
        barcodetitleLabel.text=@"条码:";
        barcodetitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:barcodetitleLabel];
        [barcodetitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(W*0.15);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.03));
        }];
        
        self.barcodeLabel=[[UILabel alloc]init];
        self.barcodeLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.barcodeLabel];
        [self.barcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(barcodetitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.03));
        }];
        
        UILabel *datetitleLabel=[[UILabel alloc]init];
        datetitleLabel.text=@"到期时间:";
        datetitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:datetitleLabel];
        [datetitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(barcodetitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self).with.offset(W*0.15);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        self.dateLabel=[[UILabel alloc]init];
        self.dateLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.barcodeLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(datetitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.03));
        }];
        
        self.renewButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.renewButton setTitle:@"续借" forState:UIControlStateNormal];
        [self.renewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.renewButton.backgroundColor=[UIColor whiteColor];
        self.renewButton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        self.renewButton.layer.borderWidth=1;
        self.renewButton.layer.borderColor=[UIColor redColor].CGColor;
        [self.contentView addSubview:self.renewButton];
        [self.renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).with.offset(W*0.02);
            make.size.mas_equalTo(CGSizeMake(W*0.13, H*0.04));
        }];
    }
    return self;
}

@end
