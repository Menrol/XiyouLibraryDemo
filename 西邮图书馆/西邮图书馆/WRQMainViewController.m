//
//  WRQMainViewController.m
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import "WRQMainViewController.h"
#import "AFNetworking.h"
#import "WRQNoticeModel.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "Masonry.h"
#import "WRQSearchViewController.h"
#import "WRQNewsModel.h"
#import "WRQDetailViewController.h"
#import "WRQMainTableViewCell.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQMainViewController ()
@property(nonatomic,strong)UIButton *preBtn;
@property(nonatomic,strong)UIScrollView *ScrollView;
@property(nonatomic,strong)UITableView *NoticeTableView;
@property(nonatomic,strong)UITableView *NewsTableView;
@property(nonatomic,strong)NSMutableArray *NoticeModelArray;
@property(nonatomic,strong)NSMutableArray *NewsModelArray;
@property(nonatomic,strong)UIImageView *LoadView;
@property(nonatomic,strong)MJRefreshGifHeader *NoticeRefreshHeader;
@property(nonatomic,strong)MJRefreshGifHeader *NewsRefreshHeader;
@property(nonatomic,strong)UIImageView *libraryImage;
@property(nonatomic,assign)BOOL NoticeIsfinsh;
@property(nonatomic,assign)BOOL NewsIsfinsh;
@property(nonatomic,strong)NoNetworkView *nonetworkView;
@end

@implementation WRQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getNoticedata];
    [self getNewsdata];

    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"首页";
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem=searchButton;
    
    UIView *btnbackground=[[UIView alloc]initWithFrame:CGRectMake(0, 64, W, H*0.12)];
    btnbackground.backgroundColor=[UIColor whiteColor];
    btnbackground.userInteractionEnabled=YES;
    [self.view addSubview:btnbackground];
    
    UIButton *NoticeBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    NoticeBtn.frame=CGRectMake(W*0.25, H*0.01, W*0.25, H*0.08);
    [NoticeBtn setTitle:@"公告信息" forState:UIControlStateNormal];
    NoticeBtn.backgroundColor=[UIColor colorWithRed:0.50 green:0.85 blue:0.77 alpha:1.00];
    [NoticeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NoticeBtn.layer.masksToBounds=YES;
    NoticeBtn.layer.cornerRadius=25;
    NoticeBtn.tag=101;
    NoticeBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    self.preBtn=NoticeBtn;
    [NoticeBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [btnbackground addSubview:NoticeBtn];
    
    UIButton *NewsBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    NewsBtn.frame=CGRectMake(W*0.5, H*0.01, W*0.25, H*0.08);
    [NewsBtn setTitle:@"新闻信息" forState:UIControlStateNormal];
    NewsBtn.backgroundColor=[UIColor whiteColor];
    [NewsBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.00] forState:UIControlStateNormal];
    [NewsBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    NewsBtn.layer.masksToBounds=YES;
    NewsBtn.layer.cornerRadius=25;
    NewsBtn.tag=102;
    NewsBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [btnbackground addSubview:NewsBtn];
    
    self.libraryImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"library"]];
    self.libraryImage.frame=CGRectMake(W*0.05, H*0.14+64, W*0.9, H*0.3);
    [self.view addSubview:self.libraryImage];
    
    
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, H*0.45+64, W, H-64-49-H*0.45)];
    self.ScrollView.showsHorizontalScrollIndicator=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    self.ScrollView.bounces=NO;
    self.ScrollView.pagingEnabled=YES;
    self.ScrollView.directionalLockEnabled=YES;
    self.ScrollView.contentSize=CGSizeMake(W*2, H-64-49-H*0.45);
    self.ScrollView.delegate=self;
    self.ScrollView.tag=103;
    [self.view addSubview:self.ScrollView];
    
    for (int i=0; i<2; i++) {
        switch (i) {
            case 0:
                self.NoticeTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.45)];
                self.NoticeTableView.tag=101;
                self.NoticeTableView.delegate=self;
                self.NoticeTableView.dataSource=self;
                self.NoticeTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                self.NoticeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
                self.NoticeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                self.NoticeTableView.backgroundColor=[UIColor clearColor];
                [self.ScrollView addSubview:self.NoticeTableView];
                break;
            case 1:
                self.NewsTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.45)];
                self.NewsTableView.tag=102;
                self.NewsTableView.delegate=self;
                self.NewsTableView.dataSource=self;
                self.NewsTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                self.NewsTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
                self.NewsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                self.NewsTableView.backgroundColor=[UIColor clearColor];
                [self.ScrollView addSubview:self.NewsTableView];
                break;
        }
    }
    
    [self setLoadAnimation];
    
    [self setNoticerefreshHeader];
    
    [self setNewsrefreshHeader];
}

- (void)setnonetworkAlert{
    UIView *backgroundView=[[UIView alloc]init];
    backgroundView.layer.masksToBounds=YES;
    backgroundView.layer.cornerRadius=5;
    backgroundView.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.06));
    }];
        
    UILabel *nonetworkLabel=[[UILabel alloc]init];
    nonetworkLabel.text=@"网络无法连接";
    nonetworkLabel.textColor=[UIColor whiteColor];
    nonetworkLabel.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
    nonetworkLabel.layer.masksToBounds=YES;
    nonetworkLabel.layer.cornerRadius=5;
    nonetworkLabel.font=[UIFont systemFontOfSize:15];
    [backgroundView addSubview:nonetworkLabel];
    [nonetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgroundView);
        make.size.mas_equalTo(CGSizeMake(W*0.25, H*0.06));
    }];
    NSTimer *timer=[NSTimer timerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        backgroundView.hidden=YES;
    }];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==101) {
        return self.NoticeModelArray.count;
    }
    else
        return self.NewsModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==102){
        WRQNewsModel *newsModel=self.NewsModelArray[indexPath.row];
        CGSize size=[newsModel.size CGSizeValue];
        return size.height+H*0.07;
    }
    else{
        WRQNoticeModel *noticeModel=self.NoticeModelArray[indexPath.row];
        CGSize size=[noticeModel.size CGSizeValue];
        return size.height+H*0.07;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        WRQMainTableViewCell *cell=[self.NoticeTableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        if (cell==NULL) {
            cell=[[WRQMainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeCell"];
            cell.backgroundColor=[UIColor clearColor];
        }
        WRQNoticeModel *NoticeModel=[[WRQNoticeModel alloc]init];
        NoticeModel=self.NoticeModelArray[indexPath.row];
        cell.titleLabel.text=NoticeModel.title;
        cell.dateLabel.text=NoticeModel.date;
        CGSize size=[NoticeModel.size CGSizeValue];
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(H*0.01);
            make.left.equalTo(cell).with.offset(W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.8, size.height));
        }];
        UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        background.backgroundColor=[UIColor whiteColor];
        cell.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, size.height+H*0.05));
        }];
        return cell;
    }
    else{
        WRQMainTableViewCell *cell=[self.NewsTableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        if (cell==NULL) {
            cell=[[WRQMainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
            cell.backgroundColor=[UIColor clearColor];
        }
        WRQNewsModel *newsModel=self.NewsModelArray[indexPath.row];
        cell.titleLabel.text=newsModel.Title;
        cell.dateLabel.text=newsModel.Date;
        CGSize size=[newsModel.size CGSizeValue];
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(H*0.01);
            make.left.equalTo(cell).with.offset(W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.8, size.height));
        }];
        UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        background.backgroundColor=[UIColor whiteColor];
        cell.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, size.height+H*0.05));
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQDetailViewController *DetailViewController=[[WRQDetailViewController alloc]init];
    if (tableView.tag==101) {
        WRQNoticeModel *NoticeModel=self.NoticeModelArray[indexPath.row];
        DetailViewController.ID=NoticeModel.ID;
        DetailViewController.tag=tableView.tag;
    }
    else{
        WRQNewsModel *NewsModel=self.NewsModelArray[indexPath.row];
        DetailViewController.ID=NewsModel.ID;
        DetailViewController.tag=tableView.tag;
    }
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:DetailViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (void)search{
    WRQSearchViewController *searchViewController=[[WRQSearchViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (void)getNoticedata{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:@"http://api.xiyoumobile.com/xiyoulibv2/news/getList/announce/1" parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
             NSDictionary *DetailDictionary=[responseObject objectForKey:@"Detail"];
             NSArray *DataArray=[DetailDictionary objectForKey:@"Data"];
             self.NoticeModelArray=[[NSMutableArray alloc]init];
             for (NSDictionary *dic in DataArray) {
                 WRQNoticeModel *NotiecModel=[[WRQNoticeModel alloc]init];
                 NotiecModel.date=[dic objectForKey:@"Date"];
                 NotiecModel.ID=[dic objectForKey:@"ID"];
                 NotiecModel.title=[dic objectForKey:@"Title"];
                 CGSize size=[NotiecModel.title boundingRectWithSize:CGSizeMake(W*0.8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
                 NSValue *value=[NSValue valueWithCGSize:size];
                 NotiecModel.size=value;
                 [self.NoticeModelArray addObject:NotiecModel];
             }
             self.NoticeIsfinsh=YES;
             [self.NoticeTableView.mj_header endRefreshing];
             [self.NoticeTableView setContentOffset:CGPointMake(0, 0)];
             if (self.NoticeIsfinsh&&self.NewsIsfinsh) {
                 [self.LoadView stopAnimating];
                 self.LoadView.hidden=YES;
                 [self.NoticeTableView reloadData];
                 [self.NewsTableView reloadData];
                 self.NoticeTableView.mj_header.hidden=NO;
                 self.NewsTableView.mj_header.hidden=NO;
                 self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.97 blue:0.98 alpha:1.00];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                 NSTimer *timer=[NSTimer timerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                     [self.LoadView stopAnimating];
                     [self setnonetworkview];
                     self.NewsTableView.mj_header.hidden=YES;
                     self.NoticeTableView.mj_header.hidden=YES;
                 }];
                 [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
             }
         }];
}

- (void)getNewsdata{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:@"http://api.xiyoumobile.com/xiyoulibv2/news/getList/news/1" parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
             NSDictionary *DetailDictionary=[responseObject objectForKey:@"Detail"];
             NSArray *DataArray=[DetailDictionary objectForKey:@"Data"];
             self.NewsModelArray=[[NSMutableArray alloc]init];
             for (NSDictionary *dic in DataArray) {
                 WRQNewsModel *newsModel=[WRQNewsModel yy_modelWithDictionary:dic];
                 CGSize size=[newsModel.Title boundingRectWithSize:CGSizeMake(W*0.8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
                     NSValue *value=[NSValue valueWithCGSize:size];
                newsModel.size=value;
                [self.NewsModelArray addObject:newsModel];
             }
             self.NewsIsfinsh=YES;
             [self.NewsTableView.mj_header endRefreshing];
             [self.NewsTableView setContentOffset:CGPointMake(0, 0)];
             if (self.NoticeIsfinsh&&self.NewsIsfinsh) {
                [self.LoadView stopAnimating];
                self.LoadView.hidden=YES;
                [self.NewsTableView reloadData];
                [self.NoticeTableView reloadData];
                self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.97 blue:0.98 alpha:1.00];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
    }];
}

- (void)setnonetworkview{
    self.nonetworkView=[[NoNetworkView alloc]init];
    [self.nonetworkView.reloadButton addTarget:self action:@selector(tryagain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nonetworkView];
    [self.nonetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.libraryImage.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W, H*0.26));
    }];
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getNewsdata];
    [self getNoticedata];
}

- (void)setNoticerefreshHeader{
    self.NoticeTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([AFNetworkReachabilityManager sharedManager].isReachable) {
            [self getNoticedata];
        }
        else{
            NSTimer *timer=[NSTimer timerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.NoticeTableView.mj_header endRefreshing];
                [self setnonetworkAlert];
            }];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)setNewsrefreshHeader{
    self.NewsTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([AFNetworkReachabilityManager sharedManager].isReachable) {
            [self getNewsdata];
        }
        else{
            NSTimer *timer=[NSTimer timerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.NewsTableView.mj_header endRefreshing];
                [self setnonetworkAlert];
            }];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)setLoadAnimation{
    self.LoadView=[[UIImageView alloc]init];
    [self.view addSubview:self.LoadView];
    [self.LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.libraryImage.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(H*0.4, H*0.3));
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

- (void)press:(UIButton *)btn{
    if(self.preBtn!=btn){
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor colorWithRed:0.50 green:0.85 blue:0.77 alpha:1.00];
        self.preBtn.backgroundColor=[UIColor whiteColor];
        [self.preBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.00] forState:UIControlStateNormal];
        if(btn.tag==101)
        {
            [self.ScrollView setContentOffset:CGPointMake(0, 0)];
            [self.NoticeTableView setContentOffset:CGPointMake(0, 0)];
        }
        else
        {
            [self.ScrollView setContentOffset:CGPointMake(self.ScrollView.bounds.size.width, 0)];
            [self.NewsTableView setContentOffset:CGPointMake(0, 0)];
        }
    }
    self.preBtn=btn;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag==103) {
        if(scrollView.contentOffset.x==0)
        {
            UIButton *btn=[self.view viewWithTag:101];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor colorWithRed:0.50 green:0.85 blue:0.77 alpha:1.00];
            if(self.preBtn!=btn)
            {
                self.preBtn.backgroundColor=[UIColor whiteColor];
                [self.preBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.00] forState:UIControlStateNormal];
                self.preBtn=btn;
                [self.NoticeTableView setContentOffset:CGPointMake(0, 0)];
            }
        }
        else if(scrollView.contentOffset.x==scrollView.bounds.size.width)
        {
            UIButton *btn=[self.view viewWithTag:102];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor colorWithRed:0.50 green:0.85 blue:0.77 alpha:1.00];
            if(self.preBtn!=btn)
            {
                self.preBtn.backgroundColor=[UIColor whiteColor];
                [self.preBtn setTitleColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.00] forState:UIControlStateNormal];
                self.preBtn=btn;
                [self.NewsTableView setContentOffset:CGPointMake(0, 0)];
            }
        }
    }
}

//去掉导航栏黑线
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.NoticeTableView deselectRowAtIndexPath:[self.NoticeTableView indexPathForSelectedRow] animated:NO];
    [self.NewsTableView deselectRowAtIndexPath:[self.NewsTableView indexPathForSelectedRow] animated:NO];
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden=YES;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.00];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    [self.tabBarController.tabBar setShadowImage:[UIImage new]];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
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
