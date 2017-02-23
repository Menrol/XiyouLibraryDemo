//
//  WRQCollectTableViewCell.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQCollectTableViewCell.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@implementation WRQCollectTableViewCell

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
        self.BookImageView=[[UIImageView alloc]init];
        self.BookImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.BookImageView];
        [self.BookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.02);
            make.left.equalTo(self).with.offset(W*0.11);
            make.size.mas_equalTo(CGSizeMake(W*0.3, H*0.25));
        }];
        
        self.nopictureImage=[[UIImageView alloc]init];
        [self.BookImageView addSubview:self.nopictureImage];
        [self.nopictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(self.BookImageView);
            make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
        }];
        self.nopictureImage.image=[UIImage imageNamed:@"final.png"];
        
        self.BooknameLabel=[[UILabel alloc]init];
        self.BooknameLabel.numberOfLines=0;
        self.BooknameLabel.font=[UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.BooknameLabel];
        [self.BooknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(H*0.02);
            make.left.equalTo(self.BookImageView.mas_right).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.51, H*0.13));
        }];
        
        UILabel *authoritleLabel=[[UILabel alloc]init];
        authoritleLabel.text=@"作者:";
        authoritleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:authoritleLabel];
        [authoritleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.BooknameLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.BookImageView.mas_right).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.1, H*0.03));
        }];
        
        self.authorLabel=[[UILabel alloc]init];
        self.authorLabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:self.authorLabel];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.BooknameLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(authoritleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.41, H*0.03));
        }];
        
        UILabel *pubtitleLabel=[[UILabel alloc]init];
        pubtitleLabel.text=@"出版社:";
        pubtitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:pubtitleLabel];
        [pubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authoritleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.BookImageView.mas_right).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.15, H*0.03));
        }];
        
        self.pubLabel=[[UILabel alloc]init];
        self.pubLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.pubLabel];
        [self.pubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.authorLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(pubtitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.36, H*0.03));
        }];
        
        UILabel *sorttitleLabel=[[UILabel alloc]init];
        sorttitleLabel.text=@"索书号:";
        sorttitleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:sorttitleLabel];
        [sorttitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pubtitleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.BookImageView.mas_right).with.offset(H*0.01);
            make.size.mas_equalTo(CGSizeMake(W*0.15, H*0.03));
        }];
        
        self.sortLabel=[[UILabel alloc]init];
        self.sortLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.sortLabel];
        [self.sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pubLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(sorttitleLabel.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(W*0.36, H*0.03));
        }];
    }
    return self;
}
@end
