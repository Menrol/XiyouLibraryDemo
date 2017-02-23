//
//  WRQSetViewController.m
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import "WRQSetViewController.h"
#import "WRQAboutusViewController.h"
#import "WRQQuestionViewController.h"
#import "WRQQuestionsendViewController.h"
#import "WRQMyViewController.h"
#import "WRQMyModel.h"
#import "AppDelegate.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQSetViewController ()
@property(strong,nonatomic)UITableView *SetTableView;
@property(strong,nonatomic)NSArray *dataArray;
@property(strong,nonatomic)UIAlertController *alertController;
@end

@implementation WRQSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"设置";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.SetTableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.SetTableView.delegate=self;
    self.SetTableView.dataSource=self;
    self.SetTableView.scrollEnabled=NO;
    [self.view addSubview:self.SetTableView];
    
    self.dataArray=[[NSArray alloc]initWithObjects:@"消息通知", @"2G/3G/4G网下显示图片",@"关于我们", nil];
    
    self.alertController=[UIAlertController alertControllerWithTitle:@"确定要退出登录么？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        Delegate.islogin=NO;
        self.isLogin=NO;
        [self.SetTableView reloadData];
    }];
    UIAlertAction *noaction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [self.alertController addAction:yesaction];
    [self.alertController addAction:noaction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isLogin==NO) {
        return 1;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.dataArray.count;
    }
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H*0.06;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(indexPath.section==0){
        if (indexPath.row>=0&&indexPath.row<=1) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            UISwitch *setSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(W*0.85, H*0.01, W*0.15, H*0.03)];
            setSwitch.on=NO;
            setSwitch.tag=indexPath.row;
            [setSwitch addTarget:self action:@selector(isOnchange:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:setSwitch];
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text=self.dataArray[indexPath.row];
    }
    else{
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *ExitloadLabel=[[UILabel alloc]initWithFrame:CGRectMake((W-W*0.2)/2, H*0.01, W*0.2, H*0.03)];
        ExitloadLabel.text=@"退出登录";
        ExitloadLabel.textColor=[UIColor redColor];
        [cell.contentView addSubview:ExitloadLabel];
    }
    return cell;
}

- (void)isOnchange:(UISwitch *)setSwitch{
    if (setSwitch.tag==1) {
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        Delegate.canLoadImage=setSwitch.isOn;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQAboutusViewController *AboutusViewController=[[WRQAboutusViewController alloc]init];
    if(indexPath.row==2) {
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:AboutusViewController animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    if (indexPath.section==1) {
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.SetTableView deselectRowAtIndexPath:[self.SetTableView indexPathForSelectedRow] animated:NO];
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.isLogin!=Delegate.islogin){
        self.isLogin=Delegate.islogin;
        [self.SetTableView reloadData];
    }
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
