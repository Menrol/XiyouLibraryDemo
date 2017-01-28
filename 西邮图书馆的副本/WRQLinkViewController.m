//
//  WRQLinkViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/24.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQLinkViewController.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQLinkViewController ()
@property(strong,nonatomic)UIWebView *webView;
@end

@implementation WRQLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"链接详情";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.webView=[[UIWebView alloc]init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.webView.delegate=self;
    self.webView.scalesPageToFit=YES;
    [self.webView loadRequest:self.request];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W, H-64));
        make.top.equalTo(self.view).with.offset(64);
    }];
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURLSessionTask *dataTask=[[NSURLSession sharedSession] dataTaskWithRequest:request
    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httprepose=(NSHTTPURLResponse *)response;
        if (httprepose.statusCode==404||httprepose.statusCode==403) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setfailView];
            });
        }
    }];
    [dataTask resume];
    return YES;
}

- (void)setfailView{
    UIView *failView=[[UIImageView alloc]init];
    failView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:failView];
    [failView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(W, H-64));
        make.top.equalTo(self.view).with.offset(64);
    }];
    UIImageView *imageView=[[UIImageView alloc]init];
    [failView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(failView);
        make.size.mas_equalTo(CGSizeMake(H*0.12, H*0.12));
        make.top.equalTo(failView).with.offset(H*0.3);
    }];
    imageView.image=[UIImage imageNamed:@"final-1.png"];
    
    UILabel *failLael=[[UILabel alloc]init];
    failLael.text=@"加载失败";
    failLael.font=[UIFont boldSystemFontOfSize:20];
    [failView addSubview:failLael];
    [failLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(H*0.02);
        make.centerX.equalTo(failView);
        make.size.mas_equalTo(CGSizeMake(W*0.22, H*0.03));
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self setfailView];
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
