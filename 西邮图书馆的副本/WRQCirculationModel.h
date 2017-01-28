//
//  WRQCirculationModel.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRQCirculationModel : NSObject
@property(strong,nonatomic)NSString *Barcode;
@property(strong,nonatomic)NSString *Date;
@property(strong,nonatomic)NSString *Department;
@property(strong,nonatomic)NSString *Sort;
@property(strong,nonatomic)NSString *Status;
@end
