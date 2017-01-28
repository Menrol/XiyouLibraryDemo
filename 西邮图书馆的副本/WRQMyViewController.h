//
//  WRQMyViewController.h
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRQLoginViewController.h"
#import "WRQSetViewController.h"
#import "AppDelegate.h"

@interface WRQMyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(assign,nonatomic)BOOL isLogin;
@property(copy,nonatomic)NSString *session;
@end
