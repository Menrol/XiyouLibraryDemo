//
//  WRQBookdetailViewController.h
//  西邮图书馆
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRQBookdetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSString *ID;
@end
