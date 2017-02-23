//
//  WRQRemindTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/2/18.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQRemindTableViewCell : UITableViewCell
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *barcodeLabel;
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UIButton *renewButton;
@end
