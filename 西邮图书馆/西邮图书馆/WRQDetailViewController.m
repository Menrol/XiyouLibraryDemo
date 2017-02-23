//
//  WRQDetailViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/23.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQDetailViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "WRQLinkViewController.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQDetailViewController ()
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UILabel *publishLabel;
@property(strong,nonatomic)NSString *titlestr;
@property(strong,nonatomic)NSString *datestr;
@property(strong,nonatomic)NSString *passagestr;
@property(strong,nonatomic)NSString *publishstr;
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)UIWebView *webView;
@property(assign,nonatomic)CGFloat webViewheight;
@property(nonatomic,strong)NoNetworkView *nonetworkView;
@end

@implementation WRQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getdetaildata];
    
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *titlestr;
    if (self.tag==101) {
        titlestr=[[NSString alloc]initWithFormat:@"公告详情"];
    }
    else{
        titlestr=[[NSString alloc]initWithFormat:@"新闻详情"];
    }
    self.navigationItem.title=titlestr;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;

    [self setLoadAnimation];
    // Do any additional setup after loading the view.
}

- (void)getdetaildata{
    NSString *url;
    if (self.tag==101) {
        url=[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getDetail/announce/html/%@",self.ID];
    }
    else{
        url=[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getDetail/news/html/%@",self.ID];
    }
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *detailDictionary=[responseObject objectForKey:@"Detail"];
             self.datestr=[[NSString alloc]initWithString:[detailDictionary objectForKey:@"Date"]];
             self.passagestr=[[NSString alloc]initWithString:[detailDictionary objectForKey:@"Passage"]];
             self.publishstr=[[NSString alloc]initWithString:[detailDictionary objectForKey:@"Publisher"]];
             self.titlestr=[[NSString alloc]initWithString:[detailDictionary objectForKey:@"Title"]];
             [self loadhtml];
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

- (void)loadhtml{
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, W, 1)];
    self.webView.opaque=NO;
    self.webView.backgroundColor=[UIColor clearColor];
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    self.webView.scalesPageToFit=NO;
    self.webView.delegate=self;
    self.webView.scrollView.contentInset=UIEdgeInsetsMake(H*0.06, 0, H*0.085, 0);
    if (self.tag==101) {
        [self.webView loadHTMLString:self.passagestr baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getDetail/announce/html/%@",self.ID]]];
    }
    else{
        [self.webView loadHTMLString:self.passagestr baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getDetail/news/html/%@",self.ID]]];
    }
    [self.view addSubview:self.webView];
}

- (void)loadheadView{
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.1, -H*0.06, W*0.8, H*0.06)];
    self.titleLabel.numberOfLines=0;
    self.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.text=self.titlestr;
    [self.webView.scrollView addSubview:self.titleLabel];
}

- (void)loadfootView{
    UILabel *publishtitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, self.webViewheight+H*0.02, W*0.2, H*0.03)];
    publishtitleLabel.font=[UIFont systemFontOfSize:15];
    publishtitleLabel.text=@"发布单位:";
    [self.webView.scrollView addSubview:publishtitleLabel];
    
    self.publishLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.7, self.webViewheight+H*0.02, W*0.3, H*0.03)];
    self.publishLabel.font=[UIFont systemFontOfSize:15];
    self.publishLabel.text=self.publishstr;
    [self.webView.scrollView addSubview:self.publishLabel];
    
    UILabel *datetitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.5, self.webViewheight+H*0.055, W*0.2, H*0.03)];
    datetitleLabel.font=[UIFont systemFontOfSize:15];
    datetitleLabel.text=@"发布日期:";
    [self.webView.scrollView addSubview:datetitleLabel];
    
    self.dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.7, self.webViewheight+H*0.055, W*0.3, H*0.03)];
    self.dateLabel.font=[UIFont systemFontOfSize:15];
    self.dateLabel.text=self.datestr;
    [self.webView.scrollView addSubview:self.dateLabel];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *scrollArry=[webView subviews];
    UIScrollView *scrollview=[scrollArry objectAtIndex:0];
    self.webViewheight=scrollview.contentSize.height;
    self.webView.frame=CGRectMake(0, 64, W, H-64);
    webView.scrollView.contentOffset=CGPointMake(0, -H*0.06);
    [self.LoadView stopAnimating];
    self.LoadView.hidden=YES;
    [self loadheadView];
    [self loadfootView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        WRQLinkViewController *LinkViewController=[[WRQLinkViewController alloc]init];
        LinkViewController.request=request;
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:LinkViewController animated:YES];
        return NO;
    }
    else
        return YES;
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.nonetworkView.hidden=YES;
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getdetaildata];
}

- (void)return{
    [self.LoadView stopAnimating];
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
