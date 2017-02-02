//
//  WRQBookdetailModel.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/20.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRQCirculationModel.h"
#import "WRQReferbooksModel.h"

@interface WRQBookdetailModel : NSObject
@property(strong,nonatomic)NSString *Author;
@property(strong,nonatomic)NSString *Sort;
@property(strong,nonatomic)NSString *Pub;
@property(strong,nonatomic)NSString *FavTimes;
@property(strong,nonatomic)NSString *RentTimes;
@property(strong,nonatomic)NSString *Image;
@property(strong,nonatomic)NSString *Title;
@property(strong,nonatomic)NSString *Subject;
@property(strong,nonatomic)NSString *Total;
@property(strong,nonatomic)NSString *Avaliable;
@property(strong,nonatomic)NSValue *size;
@end
