//
//  WRQBorrowbookTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/9.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBorrowbookTableViewCell.h"
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
        self.BookImageView=[[UIImageView alloc]initWithFrame:CGRectMake(W*0.1, H*0.02, W*0.3, H*0.25)];
        self.BookImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.BookImageView];
        
        self.BooknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.02, W*0.4, H*0.1)];
        self.BooknameLabel.numberOfLines=0;
        self.BooknameLabel.font=[UIFont boldSystemFontOfSize:22];
        self.BooknameLabel.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.BooknameLabel];
        
        UILabel *AuthortitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.13, W*0.15, H*0.03)];
        AuthortitleLabel.text=@"作者:";
        AuthortitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:AuthortitleLabel];
        
        self.AuthorLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.65, H*0.13, W*0.2, H*0.03)];
        self.AuthorLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.AuthorLabel];
        
        UILabel *NumbertitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.17, W*0.15, H*0.03)];
        NumbertitleLabel.text=@"序书号:";
        NumbertitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:NumbertitleLabel];
        
        self.NumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.65, H*0.17, W*0.2, H*0.03)];
        self.NumberLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.NumberLabel];
        
        UILabel *PublishtitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.21, W*0.15, H*0.03)];
        PublishtitleLabel.text=@"出版社:";
        PublishtitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:PublishtitleLabel];
        
        self.PublishLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.65, H*0.21, W*0.2, H*0.03)];
        self.PublishLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.PublishLabel];
        
        UILabel *TimetitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, H*0.25, W*0.15, H*0.03)];
        TimetitleLabel.text=@"到期时间:";
        TimetitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:TimetitleLabel];
        
        self.TimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.65, H*0.25, W*0.2, H*0.03)];
        self.TimeLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.TimeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
