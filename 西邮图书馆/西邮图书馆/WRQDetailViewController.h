//
//  WRQDetailViewController.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQDetailViewController : UIViewController<UIWebViewDelegate>
@property(copy,nonatomic)NSString *ID;
@property(assign,nonatomic)NSInteger tag;
@end
