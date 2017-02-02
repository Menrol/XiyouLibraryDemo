//
//  WRQCirculationTableViewCell.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQCirculationTableViewCell : UITableViewCell
@property(strong,nonatomic)UILabel *barcodeLabel;
@property(strong,nonatomic)UILabel *stateLabel;
@property(strong,nonatomic)UILabel *departmentLabel;
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UILabel *datetitleLabel;
@end
