//
//  WRQCollectTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/2/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQCollectTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *BookImageView;
@property(strong,nonatomic)UILabel *BooknameLabel;
@property(strong,nonatomic)UILabel *pubLabel;
@property(strong,nonatomic)UILabel *authorLabel;
@property(strong,nonatomic)UILabel *sortLabel;
@property(strong,nonatomic)UIImageView *nopictureImage;
@end
