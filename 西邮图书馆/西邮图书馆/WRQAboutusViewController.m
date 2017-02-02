//
//  WRQAboutusViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQAboutusViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQAboutusViewController ()

@end

@implementation WRQAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"关于我们";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStyleDone target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;
    
    UIImageView *LogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(W*0.4, H*0.2, W*0.2, W*0.2)];
    LogoImageView.image=[UIImage imageNamed:@"book.png"];
    [self.view addSubview:LogoImageView];
    
    UILabel *IntroduceLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.32, H*0.22+W*0.2, W*0.8, H*0.06)];
    IntroduceLabel.text=@"西邮图书馆 V1.0.0";
    IntroduceLabel.textColor=[UIColor redColor];
    [self.view addSubview:IntroduceLabel];
    // Do any additional setup after loading the view.
}

- (void)return{
    [self.navigationController popViewControllerAnimated:YES];
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
