//
//  WRQLinkViewController.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/24.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQLinkViewController : UIViewController<UIWebViewDelegate>
@property(strong,nonatomic)NSURLRequest *request;
@end
