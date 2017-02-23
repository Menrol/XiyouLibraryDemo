//
//  WRQHistoryTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQHistoryTableViewCell : UITableViewCell
@property(strong,nonatomic)UIView *lineupView;
@property(strong,nonatomic)UIView *linedownView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *typeLabel;
@property(strong,nonatomic)UILabel *barcodeLabel;
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UIView *circleView;
@end
