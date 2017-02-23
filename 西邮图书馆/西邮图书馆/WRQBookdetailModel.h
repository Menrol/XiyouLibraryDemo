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
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *Author;
@property(copy,nonatomic)NSString *Sort;
@property(copy,nonatomic)NSString *Pub;
@property(copy,nonatomic)NSString *FavTimes;
@property(copy,nonatomic)NSString *RentTimes;
@property(copy,nonatomic)NSString *Image;
@property(copy,nonatomic)NSString *Title;
@property(copy,nonatomic)NSString *Subject;
@property(copy,nonatomic)NSString *Total;
@property(copy,nonatomic)NSString *Avaliable;
@property(copy,nonatomic)NSString *Summary;
@property(strong,nonatomic)NSValue *size;
@end
