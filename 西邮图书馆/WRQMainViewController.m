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
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem=searchButton;
    
    UIButton *NoticeBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    NoticeBtn.frame=CGRectMake(0, 64, W/2.0, H*0.06);
    [NoticeBtn setTitle:@"公告信息" forState:UIControlStateNormal];
    NoticeBtn.tintColor=[UIColor blackColor];
    NoticeBtn.backgroundColor=[UIColor whiteColor];
    NoticeBtn.tag=101;
    self.preBtn=NoticeBtn;
    [NoticeBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NoticeBtn];
    
    UIButton *NewsBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    NewsBtn.frame=CGRectMake(W/2.0, 64, W/2.0, H*0.06);
    [NewsBtn setTitle:@"新闻信息" forState:UIControlStateNormal];
    NewsBtn.tintColor=[UIColor blackColor];
    NewsBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [NewsBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    NewsBtn.tag=102;
    [self.view addSubview:NewsBtn];
    
    
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+H*0.06, W, H-64-49-H*0.06)];
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
                self.NoticeTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.06)];
                self.NoticeTableView.tag=101;
                self.NoticeTableView.delegate=self;
                self.NoticeTableView.dataSource=self;
                self.NoticeTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                self.NoticeTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
                [self.ScrollView addSubview:self.NoticeTableView];
                break;
            case 1:
                self.NewsTableView=[[UITableView alloc]initWithFrame:CGRectMake(W*i, 0, W, H-64-49-H*0.06)];
                self.NewsTableView.tag=102;
                self.NewsTableView.delegate=self;
                self.NewsTableView.dataSource=self;
                self.NewsTableView.contentInset=UIEdgeInsetsMake(H*0.01, 0, 0, 0);
                self.NewsTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
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
        return size.height;
    }
    else{
        NSNumber *Rowheight=self.RowheightArray[indexPath.row];
        NSInteger height=[Rowheight integerValue];
        return height;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        UITableViewCell *cell=[self.NoticeTableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        if (cell==NULL) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines=0;
        }
        cell.imageView.image=[UIImage imageNamed:@"point"];
        WRQNoticeModel *NoticeModel=[[WRQNoticeModel alloc]init];
        NoticeModel=self.NoticeModelArray[indexPath.row];
        cell.textLabel.text=NoticeModel.finaltitle;
        return cell;
    }
    else{
        UITableViewCell *cell=[self.NewsTableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        if (cell==NULL) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
            cell.textLabel.font=[UIFont systemFontOfSize:15];
            cell.textLabel.numberOfLines=0;
        }
        cell.imageView.image=[UIImage imageNamed:@"point"];
        WRQNewsModel *newsModel=self.NewsModelArray[indexPath.row];
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

- (void)viewWillAppear:(BOOL)animated{
    [self.NoticeTableView deselectRowAtIndexPath:[self.NoticeTableView indexPathForSelectedRow] animated:NO];
    [self.NewsTableView deselectRowAtIndexPath:[self.NewsTableView indexPathForSelectedRow] animated:NO];
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
             if (self.NoticeIsfinsh&&self.NewsIsfinsh) {
                 [self.LoadView stopAnimating];
                 self.LoadView.hidden=YES;
                 [self.NoticeTableView reloadData];
                 [self.NewsTableView reloadData];
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
             if (self.NoticeIsfinsh&&self.NewsIsfinsh) {
                 [self.LoadView stopAnimating];
                 self.LoadView.hidden=YES;
                 [self.NewsTableView reloadData];
                 [self.NoticeTableView reloadData];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         }
     ];
}

- (void)setNoticerefreshHeader{
    self.NoticeRefreshHeader=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self getNoticedata];
    }];
    self.NoticeTableView.mj_header=self.NoticeRefreshHeader;
    NSMutableArray *imagesArray=[[NSMutableArray alloc]init];
    for (int i=1; i<=24; i++) {
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"1-%d",i]]];
    }
    [self.NoticeRefreshHeader setImages:imagesArray forState:MJRefreshStateRefreshing];
    self.NoticeRefreshHeader.lastUpdatedTimeLabel.hidden=YES;
    self.NoticeRefreshHeader.stateLabel.hidden=YES;
}

- (void)setNewsrefreshHeader{
    self.NewsRefreshHeader=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self getNewsdata];
    }];
    self.NewsTableView.mj_header=self.NewsRefreshHeader;
    NSMutableArray *imagesArray=[[NSMutableArray alloc]init];
    for (int i=1; i<=24; i++) {
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"1-%d",i]]];
    }
    [self.NewsRefreshHeader setImages:imagesArray forState:MJRefreshStateRefreshing];
    self.NewsRefreshHeader.lastUpdatedTimeLabel.hidden=YES;
    self.NewsRefreshHeader.stateLabel.hidden=YES;
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
        btn.backgroundColor=[UIColor whiteColor];
        self.preBtn.backgroundColor=[UIColor grayColor];
        if(btn.tag==101)
        {
            [self.ScrollView setContentOffset:CGPointMake(0, 0)];
        }
        else
        {
            [self.ScrollView setContentOffset:CGPointMake(self.ScrollView.bounds.size.width, 0)];
        }
    }
    self.preBtn=btn;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag==103) {
        if(scrollView.contentOffset.x==0)
        {
            UIButton *btn=[self.view viewWithTag:101];
            btn.backgroundColor=[UIColor whiteColor];
            if(self.preBtn!=btn)
            {
                self.preBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                self.preBtn=btn;
                [self.NoticeTableView setContentOffset:CGPointMake(0, H*0.01)];
            }
        }
        else if(scrollView.contentOffset.x==scrollView.bounds.size.width)
        {
            UIButton *btn=[self.view viewWithTag:102];
            btn.backgroundColor=[UIColor whiteColor];
            if(self.preBtn!=btn)
            {
                self.preBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                self.preBtn=btn;
                [self.NewsTableView setContentOffset:CGPointMake(0, H*0.01)];
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
