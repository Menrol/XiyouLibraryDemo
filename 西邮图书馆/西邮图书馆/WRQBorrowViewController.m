//
//  WRQBorrowViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBorrowViewController.h"
#import "WRQBorrowbookTableViewCell.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQBorrowViewController ()
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIButton *returnBtn;
@property(strong,nonatomic)UIImageView *topView;
@property(strong,nonatomic)NSMutableArray *bookModelArray;
@end

@implementation WRQBorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getID];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.97 blue:0.98 alpha:1.00];
    
    self.topView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"borrow-1"]];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W, H*0.28));
    }];
    
    self.returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:[UIImage imageNamed:@"return-1.png"] forState:UIControlStateNormal];
    self.returnBtn.layer.masksToBounds=YES;
    self.returnBtn.layer.cornerRadius=H*0.03;
    self.returnBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.returnBtn addTarget:self action:@selector(pressreturn) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.returnBtn];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        make.top.equalTo(self.view).with.offset(30);
        make.left.equalTo(self.view).with.offset(H*0.01);
    }];
    
    UILabel *borrowLabel=[[UILabel alloc]init];
    borrowLabel.text=@"我的借阅";
    borrowLabel.font=[UIFont boldSystemFontOfSize:23];
    borrowLabel.textColor=[UIColor whiteColor];
    [self.topView addSubview:borrowLabel];
    [borrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).with.offset(-W*0.1);
        make.bottom.equalTo(self.topView.mas_bottom).with.offset(-H*0.01);
        make.size.mas_equalTo(CGSizeMake(W*0.3, H*0.03));
    }];
    
    self.tableView=[[UITableView alloc]init];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W, H-H*0.28));
    }];
    
    self.bookModelArray=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H*0.35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQBorrowbookTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[WRQBorrowbookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)getID{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/rent?session=%@",Delegate.session] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        id Detail=[responseObject objectForKey:@"Detail"];
        if([Detail isKindOfClass:[NSString class]]){
            [self setnobookView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)setnobookView{
    UIImageView *nobookImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"final-1.png"]];
    [self.view addSubview:nobookImage];
    [nobookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.12, H*0.12));
    }];
    
    UILabel *nobookLabel=[[UILabel alloc]init];
    nobookLabel.text=@"暂无借阅书籍";
    nobookLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:nobookLabel];
    [nobookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nobookImage.mas_bottom).with.offset(H*0.02);
        make.size.mas_equalTo(CGSizeMake(W*0.35, H*0.03));
    }];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden=YES;
}

- (void)pressreturn{
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
