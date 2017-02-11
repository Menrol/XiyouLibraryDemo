//
//  WRQQuestionTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQQuestionTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQQuestionTableViewCell

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
        self.questionLabel=[[UILabel alloc]init];
        self.questionLabel.textColor=[UIColor colorWithRed:0.34 green:0.72 blue:0.59 alpha:1.00];
        self.questionLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.questionLabel];
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.02);
            make.size.mas_equalTo(CGSizeMake(W*0.6, H*0.05));
            make.left.equalTo(self).with.offset(W*0.1);
        }];
        
        self.lineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line2.png"]];
        [self.contentView addSubview:self.lineImageView];
        [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionLabel.mas_bottom).with.offset(0);
            make.left.equalTo(self).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.016));
        }];
        
        self.answerLabel=[[UILabel alloc]init];
        self.answerLabel.textColor=[UIColor blackColor];
        self.answerLabel.font=[UIFont systemFontOfSize:16];
        self.answerLabel.numberOfLines=0;
        [self.contentView addSubview:self.answerLabel];
        [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineImageView.mas_bottom).with.offset(0);
            make.left.equalTo(self).with.offset(W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.8, H*0.15));
        }];
        
        UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        background.backgroundColor=[UIColor whiteColor];
        background.layer.masksToBounds=YES;
        background.layer.cornerRadius=15;
        self.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.24));
        }];
    }
    return self;
}
@end
