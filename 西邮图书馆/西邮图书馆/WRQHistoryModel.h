//
//  WRQHistoryModel.h
//  西邮图书馆
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRQHistoryModel : NSObject
@property(copy,nonatomic)NSString *Barcode;
@property(copy,nonatomic)NSString *Date;
@property(copy,nonatomic)NSString *Title;
@property(copy,nonatomic)NSString *Type;
@property(strong,nonatomic)NSValue *size;
@end
