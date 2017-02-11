//
//  WRQBorrowbookTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/9.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBorrowbookTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQBorrowbookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIImageView *logoView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhen.png"]];
        [self.contentView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        }];
        
        self.BookImageView=[[UIImageView alloc]initWithFrame:CGRectMake(W*0.08, H*0.06, W*0.3, H*0.25)];
        self.BookImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.BookImageView];
        
        self.nopictureImage=[[UIImageView alloc]init];
        [self.BookImageView addSubview:self.nopictureImage];
        [self.nopictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(self.BookImageView);
            make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
        }];
        self.nopictureImage.image=[UIImage imageNamed:@"final.png"];
        
        self.BooknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.42, H*0.06, W*0.5, H*0.1)];
        self.BooknameLabel.numberOfLines=0;
        self.BooknameLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.BooknameLabel];
        
        UILabel *AuthortitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.42, H*0.17, W*0.15, H*0.03)];
        AuthortitleLabel.text=@"作者:";
        AuthortitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:AuthortitleLabel];
        
        self.AuthorLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.57, H*0.17, W*0.2, H*0.03)];
        self.AuthorLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.AuthorLabel];
        
        UILabel *TimetitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.42, H*0.21, W*0.15, H*0.03)];
        TimetitleLabel.text=@"到期时间:";
        TimetitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:TimetitleLabel];
        
        self.TimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.42, H*0.25, W*0.2, H*0.03)];
        self.TimeLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.TimeLabel];
        
        UILabel *detailLabel=[[UILabel alloc]init];
        detailLabel.text=@"查看详情";
        detailLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-H*0.01);
            make.bottom.equalTo(self.mas_bottom).with.offset(-H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.2, H*0.03));
        }];
        
        
        UIImageView *background=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"paper"]];
        background.backgroundColor=[UIColor whiteColor];
        self.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.04);
            make.left.equalTo(self).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.3));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
