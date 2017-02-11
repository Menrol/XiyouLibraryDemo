//
//  WRQMyTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRQMyView.h"

@interface WRQMyTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *headImage;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)WRQMyView *myView;
@property(strong,nonatomic)UIButton *loginButton;
@property(strong,nonatomic)UILabel *loginLabel;
@end
