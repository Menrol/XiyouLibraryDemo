//
//  WRQBorrowbookTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/9.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQBorrowbookTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *BookImageView;
@property(strong,nonatomic)UILabel *BooknameLabel;
@property(strong,nonatomic)UILabel *NumberLabel;
@property(strong,nonatomic)UILabel *AuthorLabel;
@property(strong,nonatomic)UILabel *TimeLabel;
@property(strong,nonatomic)UILabel *PublishLabel;
@end
