//
//  WRQMainViewController.m
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import "WRQMainViewController.h"
#import "WRQBorrowbookTableViewCell.h"
#import "AFNetworking.h"
#import "WRQNoticeModel.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "Masonry.h"
#import "WRQSearchViewController.h"
#import "WRQNewsModel.h"
#import "WRQDetailViewController.h"
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
@property(nonatomic,strong)NSMutableArray *RowheightArray;
@property(nonatomic,strong)MJRefreshGifHeader *NoticeRefreshHeader;
@property(nonatomic,strong)MJRefreshGifHeader *NewsRefreshHeader;
@property(nonatomic,assign)BOOL NoticeIsfinsh;
@property(nonatomic,assign)BOOL NewsIsfinsh;
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
    
    UIImageView *library=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"library"]];
    library.frame=CGRectMake(W*0.05, H*0.14+64, W*0.9, H*0.3);
    [self.view addSubview:library];
    
    
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, H*0.46+64, W, H-64-49-H*0.46)];
    self.ScrollView.showsHorizontalScrollIndicator=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    self.ScrollView.bounces=NO;
    self.ScrollView.pagingEnabled=YES;
    self.ScrollView.directionalLockEnabled=YES;
    self.ScrollView.contentSize=CGSizeMake(W*2, H-64-49);
    self.ScrollView.delegate=self;
    self.ScrollView.tag=103;
    [self.view addSubview:self.ScrollView];
    
    for (int i=0; i<2; i++) {
        switch (i) {
            case 0:
                self.NoticeTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.46)];
                self.NoticeTableView.tag=101;
                self.NoticeTableView.delegate=self;
                self.NoticeTableView.dataSource=self;
                self.NoticeTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                [self.NoticeTableView setContentOffset:CGPointMake(0, 0)];
                self.NoticeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
                self.NoticeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                self.NoticeTableView.backgroundColor=[UIColor clearColor];
                [self.ScrollView addSubview:self.NoticeTableView];
                break;
            case 1:
                self.NewsTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.46)];
                self.NewsTableView.tag=102;
                self.NewsTableView.delegate=self;
                self.NewsTableView.dataSource=self;
                self.NewsTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                [self.NewsTableView setContentOffset:CGPointMake(0, 0)];
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
        return size.height+H*0.04;
    }
    else{
        NSNumber *Rowheight=self.RowheightArray[indexPath.row];
        NSInteger height=[Rowheight integerValue];
        return height+H*0.04;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        UITableViewCell *cell=[self.NoticeTableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        if (cell==NULL) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines=0;
            cell.backgroundColor=[UIColor clearColor];
        }
        cell.imageView.image=[UIImage imageNamed:@"point"];
        WRQNoticeModel *NoticeModel=[[WRQNoticeModel alloc]init];
        NoticeModel=self.NoticeModelArray[indexPath.row];
        NSNumber *Rowheight=self.RowheightArray[indexPath.row];
        NSInteger height=[Rowheight integerValue];
        UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        background.backgroundColor=[UIColor whiteColor];
        cell.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(W*0.03);
            make.size.mas_equalTo(CGSizeMake(W*0.94, height+H*0.02));
        }];
        cell.textLabel.text=NoticeModel.finaltitle;
        return cell;
    }
    else{
        UITableViewCell *cell=[self.NewsTableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        if (cell==NULL) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines=0;
            cell.backgroundColor=[UIColor clearColor];
        }
        cell.imageView.image=[UIImage imageNamed:@"point"];
        WRQNewsModel *newsModel=self.NewsModelArray[indexPath.row];
        CGSize size=[newsModel.size CGSizeValue];
        UIButton *background=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        background.backgroundColor=[UIColor whiteColor];
        cell.backgroundView=background;
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(W*0.03);
            make.size.mas_equalTo(CGSizeMake(W*0.94, size.height+H*0.02));
        }];
        cell.textLabel.text=newsModel.finaltitle;
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

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden=NO;
//}

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
             self.RowheightArray=[[NSMutableArray alloc]init];
             for (NSDictionary *dic in DataArray) {
                 WRQNoticeModel *NotiecModel=[[WRQNoticeModel alloc]init];
                 NotiecModel.date=[dic objectForKey:@"Date"];
                 NotiecModel.ID=[dic objectForKey:@"ID"];
                 NotiecModel.title=[dic objectForKey:@"Title"];
                 NSMutableString *str=[[NSMutableString alloc]initWithString:NotiecModel.title];
                 [str appendString:[NSString stringWithFormat:@" %@",NotiecModel.date]];
                 NotiecModel.finaltitle=str;
                 CGSize size=[str boundingRectWithSize:CGSizeMake(W*0.4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                 NSInteger height=size.height;
                 NSNumber *Rowheight=[NSNumber numberWithInteger:height];
                 [self.RowheightArray addObject:Rowheight];
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
                 self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.97 blue:0.98 alpha:1.00];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         }
     ];
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
                 NSMutableString *str=[[NSMutableString alloc]initWithString:newsModel.Title];
                 [str appendString:[NSString stringWithFormat:@" %@",newsModel.Date]];
                 newsModel.finaltitle=str;
                 CGSize size=[str boundingRectWithSize:CGSizeMake(W*0.4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
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
         }
     ];
}

- (void)setNoticerefreshHeader{
    self.NoticeTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNoticedata];
    }];
}

- (void)setNewsrefreshHeader{
    self.NewsTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsdata];
    }];
}

- (void)setLoadAnimation{
    self.LoadView=[[UIImageView alloc]initWithFrame:CGRectMake((W-H*0.8)/2, (H-H*0.6)/2, H*0.8, H*0.6)];
    [self.view addSubview:self.LoadView];
    NSMutableArray *ImageArray=[[NSMutableArray alloc]init];
    for (int i=1; i<18; i++) {
        [ImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
    }
    self.LoadView.animationImages=ImageArray;
    self.LoadView.animationDuration=2;
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
