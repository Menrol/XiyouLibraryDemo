//
//  WRQLoadViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQLoginViewController.h"
#import "WRQTabViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "WRQMyViewController.h"
#import "WRQMyModel.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQLoginViewController ()
@property(strong,nonatomic)UITextField *IDTextField;
@property(strong,nonatomic)UITextField *PasswordTextField;
@property(strong,nonatomic)UIButton *LoginButton;
@property(strong,nonatomic)UIButton *returnButton;
@property(copy,nonatomic)NSString *sessionstr;
@property(strong,nonatomic)UIActivityIndicatorView *activityindicatorView;
@property(strong,nonatomic)UIImageView *headImage;
@property(strong,nonatomic)UIView *backgroundView;
@end

@implementation WRQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.headImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nomalhead.png"]];
    self.headImage.frame=CGRectMake((W-H*0.15)/2, H*0.11, H*0.15, H*0.15);
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=H*0.075;
    self.headImage.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.headImage];
    
    self.returnButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self.returnButton addTarget:self action:@selector(pressreturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.returnButton];
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(H*0.03, H*0.03));
        make.top.equalTo(self.view).with.offset(30);
        make.left.equalTo(self.view).with.offset(H*0.01);
    }];
    
    self.IDTextField=[[UITextField alloc]initWithFrame:CGRectMake((W-W*0.79)/2, H*0.29, W*0.79, H*0.06)];
    self.IDTextField.backgroundColor=[UIColor whiteColor];
    
    UIImageView *IDlogoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user.png"]];
    IDlogoImage.frame=CGRectMake(0, 0, H*0.05, H*0.05);
    self.IDTextField.leftView=IDlogoImage;
    self.IDTextField.leftViewMode=UITextFieldViewModeAlways;
    self.IDTextField.borderStyle=UITextBorderStyleNone;
    self.IDTextField.placeholder=@"请输入学号";
    self.IDTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    UIImageView *lineupImageView=[[UIImageView alloc]initWithFrame:CGRectMake((W-W*0.79)/2, H*0.34, W*0.79, H*0.011)];
    lineupImageView.image=[UIImage imageNamed:@"line-1.png"];
    [self.view addSubview:lineupImageView];
    
    self.PasswordTextField=[[UITextField alloc]initWithFrame:CGRectMake((W-W*0.79)/2, H*0.38, W*0.79, H*0.06)];
    self.PasswordTextField.backgroundColor=[UIColor whiteColor];
    
    UIImageView *PasswordlogoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    PasswordlogoImage.frame=CGRectMake(0, 0, H*0.05, H*0.05);
    self.PasswordTextField.leftView=PasswordlogoImage;
    self.PasswordTextField.leftViewMode=UITextFieldViewModeAlways;
    self.PasswordTextField.borderStyle=UITextBorderStyleNone;
    self.PasswordTextField.placeholder=@"请输入密码";
    self.PasswordTextField.secureTextEntry=YES;
    self.PasswordTextField.returnKeyType=UIReturnKeyGo;
    self.PasswordTextField.delegate=self;
    [self.view addSubview:self.IDTextField];
    [self.view addSubview:self.PasswordTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.IDTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.PasswordTextField];
    
    UIImageView *linedownImageView=[[UIImageView alloc]initWithFrame:CGRectMake((W-W*0.79)/2, H*0.44, W*0.79, H*0.001)];
    linedownImageView.image=[UIImage imageNamed:@"line-1.png"];
    [self.view addSubview:linedownImageView];
    
    self.LoginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.LoginButton.frame=CGRectMake((W-W*0.7)/2, H*0.52, W*0.7, H*0.06);
    [self.LoginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.LoginButton addTarget:self action:@selector(pressLogin) forControlEvents:UIControlEventTouchUpInside];
    self.LoginButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.LoginButton.backgroundColor=[UIColor grayColor];
    self.LoginButton.layer.cornerRadius=10;
    self.LoginButton.layer.borderWidth=1;
    self.LoginButton.layer.masksToBounds=YES;
    self.LoginButton.alpha=0.5;
    self.LoginButton.userInteractionEnabled=NO;
    self.LoginButton.titleLabel.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:self.LoginButton];
    // Do any additional setup after loading the view.
    
    [self setactivityindicatorView];
}

- (void)setnonetworkView{
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        self.backgroundView=[[UIView alloc]init];
        self.backgroundView.layer.masksToBounds=YES;
        self.backgroundView.layer.cornerRadius=5;
        self.backgroundView.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
        [self.view addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.06));
        }];
        
        UILabel *nonetworkLabel=[[UILabel alloc]init];
        nonetworkLabel.text=@"网络无法连接";
        nonetworkLabel.textColor=[UIColor whiteColor];
        nonetworkLabel.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
        nonetworkLabel.layer.masksToBounds=YES;
        nonetworkLabel.layer.cornerRadius=5;
        nonetworkLabel.font=[UIFont systemFontOfSize:15];
        [self.backgroundView addSubview:nonetworkLabel];
        [nonetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backgroundView);
            make.size.mas_equalTo(CGSizeMake(W*0.25, H*0.06));
        }];
        
        NSTimer *timer=[NSTimer timerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
            self.backgroundView.hidden=YES;
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)networkstatus:(NSNotification *)notification{
    NSDictionary *networkDic=notification.userInfo;
    NSInteger status=[[networkDic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    if (status!=AFNetworkReachabilityStatusNotReachable) {
        self.backgroundView.hidden=YES;
    }
}

- (void)change:(NSNotification *)notification{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *ID=[userDefaults objectForKey:@"ID"];
    NSData *headImagedata=[userDefaults objectForKey:@"headimage"];
    if([self.IDTextField.text isEqualToString:ID]){
        if (headImagedata!=nil) {
            UIImage *headimage=[UIImage imageWithData:headImagedata];
            self.headImage.image=headimage;
        }
        else
            self.headImage.image=[UIImage imageNamed:@"nomalhead.png"];
    }
    else{
        self.headImage.image=[UIImage imageNamed:@"nomalhead.png"];
    }
    if (self.IDTextField.text.length!=0&&self.PasswordTextField.text.length!=0) {
        self.LoginButton.alpha=1;
        self.LoginButton.userInteractionEnabled=YES;
        self.LoginButton.backgroundColor=[UIColor redColor];
    }
    else{
        self.LoginButton.alpha=0.5;
        self.LoginButton.userInteractionEnabled=NO;
        self.LoginButton.backgroundColor=[UIColor grayColor];
    }
}

- (void)pressreturn{
    [self.IDTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setactivityindicatorView{
    self.activityindicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityindicatorView.hidesWhenStopped=YES;
    self.activityindicatorView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.activityindicatorView];
    [self.activityindicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
    }];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pressLogin];
    return YES;
}

- (void)getdetaidata:(NSString *)sessionstr{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/info?session=%@",sessionstr] parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
             WRQMyModel *myModel=[WRQMyModel yy_modelWithDictionary:Detaildic];
             AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
             Delegate.myModel=myModel;
             [self.activityindicatorView stopAnimating];
             [self dismissViewControllerAnimated:YES completion:nil];
             self.IDTextField.text=nil;
             self.PasswordTextField.text=nil;
             [self.PasswordTextField resignFirstResponder];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                 NSTimer *timer=[NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
                     [self.activityindicatorView stopAnimating];
                     [self setnonetworkView];
                     self.LoginButton.alpha=1;
                     self.LoginButton.userInteractionEnabled=YES;
                     self.LoginButton.backgroundColor=[UIColor redColor];
                 }];
                 [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
             }
         }];
}

- (void)login:(NSString *)session and:(BOOL)result{
    if (result==YES) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSString *ID=[userDefaults objectForKey:@"ID"];
        if (![ID isEqualToString:self.IDTextField.text]) {
            [userDefaults setObject:self.IDTextField.text forKey:@"ID"];
            [userDefaults removeObjectForKey:@"headimage"];
        }
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        Delegate.islogin=YES;
        NSCharacterSet *charactSet=[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> ~"].invertedSet;
        NSString *sessionstr=[session stringByAddingPercentEncodingWithAllowedCharacters:charactSet];
        Delegate.session=sessionstr;
        [self getdetaidata:sessionstr];
    }
    else{
        [self.activityindicatorView stopAnimating];
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"用户名或密码不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesaction];
        [self presentViewController:alertController animated:YES completion:nil];
        self.PasswordTextField.text=nil;
    }
}

-(void)pressLogin{
    [self.PasswordTextField resignFirstResponder];
    self.LoginButton.userInteractionEnabled=NO;
    self.LoginButton.alpha=0.5;
    self.LoginButton.backgroundColor=[UIColor grayColor];
    [self.activityindicatorView startAnimating];
    NSString *usernamestr=self.IDTextField.text;
    NSCharacterSet *charactSet=[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> ~"].invertedSet;
    NSString *passwordstr=[self.PasswordTextField.text stringByAddingPercentEncodingWithAllowedCharacters:charactSet];
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/login?username=%@&password=%@",usernamestr,passwordstr] parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          self.sessionstr=[responseObject objectForKey:@"Detail"];
          id value=[responseObject objectForKey:@"Result"];
          [self login:self.sessionstr and:[value boolValue]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            NSTimer *timer=[NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.activityindicatorView stopAnimating];
                [self setnonetworkView];
                self.LoginButton.alpha=1;
                self.LoginButton.userInteractionEnabled=YES;
                self.LoginButton.backgroundColor=[UIColor redColor];
            }];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"isFirst"]){
        NSString *ID=[userDefaults objectForKey:@"ID"];
        self.IDTextField.text=ID;
        NSData *headimagedata=[userDefaults objectForKey:@"headimage"];
        if (headimagedata!=nil) {
            UIImage *headimage=[UIImage imageWithData:headimagedata];
            self.headImage.image=headimage;
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkstatus:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.IDTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
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
