//
//  WRQRemindViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQRemindViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "WRQRemindTableViewCell.h"
#import "WRQBorrowModel.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQRemindViewController ()
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *bookModelArray;
@property(strong,nonatomic)UIImageView *titleImageView;
@property(strong,nonatomic)NoNetworkView *nonetworkView;
@property(copy,nonatomic)NSString *newdateStr;
@end

@implementation WRQRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getdata];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"续借提醒";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *returnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=returnButton;
    
    self.tableView=[[UITableView alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W, H-64));
    }];
    
    self.bookModelArray=[[NSMutableArray alloc]init];
    
    [self setLoadAnimation];
    
    // Do any additional setup after loading the view.
}

- (void)getdata{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/rent?session=%@",Delegate.session] parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@",responseObject);
             id Detail=[responseObject objectForKey:@"Detail"];
             if([Detail isKindOfClass:[NSString class]]){
                 [self.LoadView stopAnimating];
//                 WRQBorrowModel *borrowModel=[[WRQBorrowModel alloc]init];
//                 borrowModel.Title=@"text";
//                 borrowModel.Barcode=@"text";
//                 borrowModel.Date=@"2016-2-3";
//                 [self.bookModelArray addObject:borrowModel];
//                 [self.tableView reloadData];
                 [self setnobookView];
             }
             else{
                 for (NSDictionary *dic in (NSArray *)Detail) {
                     WRQBorrowModel *borrowModel=[WRQBorrowModel yy_modelWithDictionary:dic];
                     CGSize size=[borrowModel.Title boundingRectWithSize:CGSizeMake(W*0.6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
                     NSValue *value=[NSValue valueWithCGSize:size];
                     borrowModel.size=value;
                     NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                     dateFormatter.dateFormat=@"yyyy-MM-dd";
                     NSDate *nowDate=[NSDate date];
                     NSString *nowDatestr=[dateFormatter stringFromDate:nowDate];
                     nowDate=[dateFormatter dateFromString:nowDatestr];
                     NSDate *lastDate=[dateFormatter dateFromString:borrowModel.Date];
                     NSCalendar *calendar=[NSCalendar currentCalendar];
                     NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
                     NSDateComponents *dateCom=[calendar components:unit fromDate:nowDate toDate:lastDate options:0];
                     if([borrowModel.CanRenew isEqualToString:@"true"]&&dateCom.year==0&&dateCom.month==0&&dateCom.day<=7){
                        [self.bookModelArray addObject:borrowModel];
                     }
                 }
                 [self.LoadView stopAnimating];
                 if (self.bookModelArray.count==0) {
                     [self setnobookView];
                 }
                 else{
                     [self.tableView reloadData];
                 }
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                 NSTimer *timer=[NSTimer timerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                     [self.LoadView stopAnimating];
                     [self setnonetworkview];
                 }];
                 [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
             }
         }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQBorrowModel *borrowModel=self.bookModelArray[indexPath.row];
    CGSize size=[borrowModel.size CGSizeValue];
    return H*0.15+size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQRemindTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[WRQRemindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    WRQBorrowModel *borrowModel=self.bookModelArray[indexPath.row];
    CGSize size=[borrowModel.size CGSizeValue];
    cell.titleLabel.text=borrowModel.Title;
    cell.dateLabel.text=borrowModel.Date;
    cell.barcodeLabel.text=borrowModel.Barcode;
    cell.renewButton.tag=indexPath.row;
    [cell.renewButton addTarget:self action:@selector(pressrenew:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *background=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alertbackground.png"]];
    cell.backgroundView=background;
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell);
        make.left.equalTo(cell).with.offset(W*0.05);
        make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.15+size.height));
    }];
    return cell;
}

- (void)pressrenew:(UIButton *)btn{
    WRQBorrowModel *borrowModel=self.bookModelArray[btn.tag];
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/renew?session=%@&barcode=%@&department_id=%@&library_id=%@",Delegate.session,borrowModel.Barcode,borrowModel.Department_id,borrowModel.Library_id] parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@",responseObject);
             self.newdateStr=[responseObject objectForKey:@"Detail"];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"续借失败" message:@"请检查网络状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"续借成功" message:[NSString stringWithFormat:@"新的到期时间为%@",self.newdateStr] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.bookModelArray removeObjectAtIndex:btn.tag];
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setnonetworkview{
    self.nonetworkView=[[NoNetworkView alloc]init];
    [self.nonetworkView.reloadButton addTarget:self action:@selector(tryagain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nonetworkView];
    [self.nonetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W, H*0.26));
    }];
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getdata];
}

- (void)setnobookView{
    UIImageView *nobookImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-1.png"]];
    [self.view addSubview:nobookImage];
    [nobookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.3, H*0.3));
    }];
    
    UILabel *nobookLabel=[[UILabel alloc]init];
    nobookLabel.text=@"暂无即将到期书籍";
    nobookLabel.font=[UIFont boldSystemFontOfSize:20];
    nobookLabel.transform=CGAffineTransformRotate(nobookLabel.transform, 0.12);
    CGSize size=[nobookLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [nobookImage addSubview:nobookLabel];
    [nobookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nobookImage).with.offset(H*0.01);
        make.top.equalTo(nobookImage).with.offset(H*0.08);
        make.size.mas_equalTo(CGSizeMake(size.width+1, H*0.03));
    }];
}

- (void)setLoadAnimation{
    self.LoadView=[[UIImageView alloc]init];
    [self.view addSubview:self.LoadView];
    [self.LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W, W*3/4.0));
    }];
    NSMutableArray *ImageArray=[[NSMutableArray alloc]init];
    for (int i=1; i<29; i++) {
        [ImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
    }
    self.LoadView.animationImages=ImageArray;
    self.LoadView.animationDuration=1;
    self.LoadView.animationRepeatCount=0;
    [self.LoadView startAnimating];
}

- (void)return{
    [self.LoadView stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
