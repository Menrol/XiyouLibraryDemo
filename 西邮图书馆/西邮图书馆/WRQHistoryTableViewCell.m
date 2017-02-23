//
//  WRQHistoryTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQHistoryTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQHistoryTableViewCell

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
        
        self.dateLabel=[[UILabel alloc]init];
        self.dateLabel.font=[UIFont boldSystemFontOfSize:12];
        self.dateLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.09);
            make.left.equalTo(self).with.offset(W*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        self.lineupView=[[UIView alloc]init];
        [self.contentView addSubview:self.lineupView];
        [self.lineupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self.dateLabel.mas_right).with.offset(W*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.005, H*0.1));
        }];
        
        self.circleView=[[UIView alloc]init];
        self.circleView.layer.masksToBounds=YES;
        self.circleView.layer.cornerRadius=H*0.01;
        [self.contentView addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLabel);
            make.centerX.equalTo(self.lineupView);
            make.size.mas_equalTo(CGSizeMake(H*0.02, H*0.02));
        }];
        
        self.linedownView=[[UIView alloc]init];
        [self.contentView addSubview:self.linedownView];
        [self.linedownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.circleView.mas_bottom).with.offset(0);
            make.left.equalTo(self.dateLabel.mas_right).with.offset(W*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.005, H*0.2));
        }];
        
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.numberOfLines=0;
        self.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.1);
            make.left.equalTo(self.circleView.mas_right).with.offset(H*0.02);
            make.size.mas_equalTo(CGSizeMake(W*0.63, H*0.09));
        }];
        
        UILabel *typeitleLabel=[[UILabel alloc]init];
        typeitleLabel.text=@"类型:";
        typeitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:typeitleLabel];
        [typeitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.circleView.mas_right).with.offset(H*0.02);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.03));
        }];
        
        self.typeLabel=[[UILabel alloc]init];
        self.typeLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(typeitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.03));
        }];
        
        UILabel *barcodetitleLabel=[[UILabel alloc]init];
        barcodetitleLabel.text=@"条码:";
        barcodetitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:barcodetitleLabel];
        [barcodetitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.circleView.mas_right).with.offset(H*0.02);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.03));
        }];
        
        self.barcodeLabel=[[UILabel alloc]init];
        self.barcodeLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.barcodeLabel];
        [self.barcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(barcodetitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.03));
        }];
    }
    return self;
}

@end
