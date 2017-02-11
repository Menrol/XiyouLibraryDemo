//
//  WRQTabViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQTabViewController.h"
#import "WRQMainViewController.h"
#import "WRQMyViewController.h"
#import "WRQSetViewController.h"

@interface WRQTabViewController ()

@end

@implementation WRQTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WRQMainViewController *MainViewController=[[WRQMainViewController alloc]init];
    UINavigationController *MainNavigationController=[[UINavigationController alloc]initWithRootViewController:MainViewController];
    UITabBarItem *MainTabBarItem=[[UITabBarItem alloc]init];
    MainTabBarItem.title=@"主页";
    MainTabBarItem.image=[UIImage imageNamed:@"zhuye"];
    MainTabBarItem.selectedImage=[UIImage imageNamed:@"zhuye1"];
    MainNavigationController.tabBarItem=MainTabBarItem;
    
    WRQMyViewController *MyViewController=[[WRQMyViewController alloc]init];
    UINavigationController *MyNavigationController=[[UINavigationController alloc]initWithRootViewController:MyViewController];
    UITabBarItem *MyTabBarItem=[[UITabBarItem alloc]init];
    MyTabBarItem.title=@"我的";
    MyTabBarItem.image=[UIImage imageNamed:@"wode"];
    MyTabBarItem.selectedImage=[UIImage imageNamed:@"wode1"];
    MyNavigationController.tabBarItem=MyTabBarItem;
    
    WRQSetViewController *SetViewController=[[WRQSetViewController alloc]init];
    UINavigationController *SetNavigationController=[[UINavigationController alloc]initWithRootViewController:SetViewController];
    UITabBarItem *SetTabBarItem=[[UITabBarItem alloc]init];
    SetTabBarItem.title=@"设置";
    SetTabBarItem.image=[UIImage imageNamed:@"shezhi"];
    SetTabBarItem.selectedImage=[UIImage imageNamed:@"shezhi1"];
    SetNavigationController.tabBarItem=SetTabBarItem;
    
    NSArray *TabArray=[[NSArray alloc]initWithObjects:MainNavigationController,MyNavigationController,SetNavigationController,nil];
    
    self.viewControllers=TabArray;
    self.tabBar.barTintColor=[UIColor whiteColor];
    self.tabBar.tintColor=[UIColor colorWithRed:0.74 green:0.78 blue:0.84 alpha:1.00];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.74 green:0.78 blue:0.84 alpha:1.00],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.tabBar.translucent=NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
