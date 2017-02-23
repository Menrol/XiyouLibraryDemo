//
//  AppDelegate.h
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRQMyModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(assign,nonatomic)BOOL islogin;
@property(strong,nonatomic)WRQMyModel *myModel;
@property(copy,nonatomic)NSString *session;
@property(assign,nonatomic)BOOL canLoadImage;
@end

