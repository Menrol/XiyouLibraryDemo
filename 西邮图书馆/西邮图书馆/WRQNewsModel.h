//
//  WRQNewsModel.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRQNewsModel : NSObject
@property(copy,nonatomic)NSString *Date;
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *Title;
@property(strong,nonatomic)NSValue *size;
@end
