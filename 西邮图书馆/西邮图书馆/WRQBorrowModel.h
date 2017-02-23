//
//  WRQBorrowModel.h
//  西邮图书馆
//
//  Created by Apple on 2017/2/12.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRQBorrowModel : NSObject
@property(copy,nonatomic)NSString *Title;
@property(copy,nonatomic)NSString *Barcode;
@property(copy,nonatomic)NSString *Date;
@property(copy,nonatomic)NSString *Department_id;
@property(copy,nonatomic)NSString *Library_id;
@property(copy,nonatomic)NSString *State;
@property(copy,nonatomic)NSString *CanRenew;
@property(strong,nonatomic)NSValue *size;
@end
