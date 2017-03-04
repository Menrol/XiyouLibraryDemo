//
//  WRQHistoryViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQHistoryViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "WRQHistoryTableViewCell.h"
#import "AppDelegate.h"
#import "WRQHistoryModel.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQHistoryViewController ()
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *historyModelArray;
@property(strong,nonatomic)UIImageView *feetImage;
@property(strong,nonatomic)NSMutableArray *colorArray;
@property(strong,nonatomic)NSMutableArray *cellColorArray;
@property(strong,nonatomic)UIImageView *headImageView;
@property(strong,nonatomic)UIImageView *barImageView;
@property(nonatomic,strong)NoNetworkView *nonetworkView;
@end

@implementation WRQHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getdata];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的足迹";
    self.barImageView=self.navigationController.navigationBar.subviews.firstObject;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    self.barImageView.alpha=0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIBarButtonItem *returnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=returnButton;
    
    self.feetImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feet-1"]];
    self.feetImage.hidden=YES;
    [self.view addSubview:self.feetImage];
    [self.feetImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W, H*0.3));
    }];
    
    self.headImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nomalhead.png"]];
    self.headImageView.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius=H*0.05;
    [self.feetImage addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feetImage).with.offset(W*0.14);
        make.bottom.equalTo(self.feetImage.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
    }];
    
    self.tableView=[[UITableView alloc]init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.dataSource=self;
    self.tableView.tableHeaderView=self.feetImage;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.bounces=NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W, H));
    }];
    
    [self setLoadAnimation];
    
    self.historyModelArray=[[NSMutableArray alloc]init];
    
    self.colorArray=[[NSMutableArray alloc]init];
    [self setcolor];
    
    self.cellColorArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

- (void)getdata{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/history?session=%@",Delegate.session] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.LoadView stopAnimating];
        id detail=[responseObject objectForKey:@"Detail"];
        if ([detail isKindOfClass:[NSString class]]) {
            self.tableView.hidden=YES;
            [self setnobookView];
        }
        else{
            NSArray *deatailArray=(NSArray *)detail;
            for (NSDictionary *dic in deatailArray) {
                WRQHistoryModel *historyModel=[WRQHistoryModel yy_modelWithDictionary:dic];
                CGSize size=[historyModel.Title boundingRectWithSize:CGSizeMake(W*0.63, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
                NSValue *value=[NSValue valueWithCGSize:size];
                historyModel.size=value;
                [self.historyModelArray addObject:historyModel];
            }
            int j=0;
            for (int i=0; i<self.historyModelArray.count; i++) {
                [self.cellColorArray addObject:self.colorArray[j]];
                j++;
                if (j>4) {
                    j=0;
                }
            }
            [self.cellColorArray addObject:self.colorArray[j]];
            self.feetImage.hidden=NO;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            NSTimer *timer=[NSTimer timerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.LoadView stopAnimating];
                self.tableView.hidden=YES;
                [self setnonetworkview];
            }];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
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

- (void)setnobookView{
    UIImageView *nobookImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-1.png"]];
    [self.view addSubview:nobookImage];
    [nobookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.3, H*0.3));
    }];
    
    UILabel *nobookLabel=[[UILabel alloc]init];
    nobookLabel.text=@"暂无借阅书籍";
    nobookLabel.font=[UIFont boldSystemFontOfSize:20];
    nobookLabel.transform=CGAffineTransformRotate(nobookLabel.transform, 0.12);
    CGSize size=[nobookLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [nobookImage addSubview:nobookLabel];
    [nobookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nobookImage).with.offset(H*0.03);
        make.top.equalTo(nobookImage).with.offset(H*0.08);
        make.size.mas_equalTo(CGSizeMake(size.width+1, H*0.03));
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQHistoryModel *historyModel=self.historyModelArray[indexPath.row];
    CGSize size=[historyModel.size CGSizeValue];
    return H*0.19+size.height+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQHistoryTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[WRQHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    WRQHistoryModel *historyModel=self.historyModelArray[indexPath.row];
    CGSize size=[historyModel.size CGSizeValue];
    UIColor *color=self.cellColorArray[indexPath.row];
    cell.titleLabel.text=historyModel.Title;
    cell.typeLabel.text=historyModel.Type;
    cell.dateLabel.text=historyModel.Date;
    cell.barcodeLabel.text=historyModel.Barcode;
    cell.circleView.backgroundColor=color;
    cell.lineupView.backgroundColor=color;
    cell.linedownView.backgroundColor=self.cellColorArray[indexPath.row+1];
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(H*0.1);
        make.left.equalTo(cell.circleView.mas_right).with.offset(H*0.02);
        make.size.mas_equalTo(CGSizeMake(W*0.63, size.height+1));
    }];
    [cell.linedownView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.circleView.mas_bottom);
        make.left.equalTo(cell.dateLabel.mas_right).with.offset(W*0.01);
        make.size.mas_equalTo(CGSizeMake(W*0.005, H*0.08+size.height+1));
    }];
//    UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    background.layer.masksToBounds=YES;
//    background.layer.cornerRadius=10;
//    background.backgroundColor=color;
//    cell.backgroundView=background;
//    [background mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(cell.circleView.mas_right).with.offset(H*0.01);
//        make.top.equalTo(cell).with.offset(H*0.09);
//        make.size.mas_equalTo(CGSizeMake(W*0.65, H*0.09+size.height));
//    }];
    return cell;
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getdata];
}

- (void)setcolor{
    UIColor *redColor=[UIColor colorWithRed:0.92 green:0.30 blue:0.24 alpha:1.00];
    UIColor *orangeColor=[UIColor colorWithRed:0.95 green:0.60 blue:0.22 alpha:1.00];
    UIColor *yellowColor=[UIColor colorWithRed:0.97 green:0.80 blue:0.27 alpha:1.00];
    UIColor *greenColor=[UIColor colorWithRed:0.47 green:0.84 blue:0.45 alpha:1.00];
    UIColor *blueColor=[UIColor colorWithRed:0.35 green:0.66 blue:0.84 alpha:1.00];
    [self.colorArray addObject:redColor];
    [self.colorArray addObject:orangeColor];
    [self.colorArray addObject:yellowColor];
    [self.colorArray addObject:greenColor];
    [self.colorArray addObject:blueColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat maxOffset=64;
    CGFloat offset=scrollView.contentOffset.y;
    CGFloat alpha=offset/maxOffset;
    self.barImageView.alpha=alpha;
    if (offset==0) {
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    }
    else{
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    }
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
    self.tableView.delegate=self;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *headimageData=[userDefaults objectForKey:@"headimage"];
    if (headimageData!=nil) {
        UIImage *headimage=[UIImage imageWithData:headimageData];
        self.headImageView.image=headimage;
    }
    else
        self.headImageView.image=[UIImage imageNamed:@"nomalhead.png"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tableView.delegate=nil;
    self.barImageView.alpha=1;
    [self.navigationController.navigationBar setShadowImage:nil];
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
