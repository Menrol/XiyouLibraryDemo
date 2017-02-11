//
//  WRQQuestionsendViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQQuestionsendViewController.h"
#import "Masonry.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQQuestionsendViewController ()
@property(strong,nonatomic)UITextView *SendquestionTextView;
@property(strong,nonatomic)UILabel *placeholderLabel;
@end

@implementation WRQQuestionsendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.navigationItem.title=@"问题反馈";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStyleDone target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;
    
    UIBarButtonItem *SendButton=[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem=SendButton;
    
    self.SendquestionTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.4)];
    self.SendquestionTextView.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:self.SendquestionTextView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextViewTextDidChangeNotification object:self.SendquestionTextView];
    
    self.placeholderLabel=[[UILabel alloc]init];
    self.placeholderLabel.text=@"请留下宝贵的意见，我们将不断完善，谢谢";
    self.placeholderLabel.font=[UIFont systemFontOfSize:15];
    self.placeholderLabel.textColor=[UIColor colorWithRed:0.74 green:0.78 blue:0.84 alpha:1.00];
    [self.SendquestionTextView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SendquestionTextView).with.offset(H*0.01);
        make.left.equalTo(self.SendquestionTextView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W*0.8, H*0.03));
    }];
    // Do any additional setup after loading the view.
}

- (void)change:(NSNotification *)notification{
    if (self.SendquestionTextView.text.length>0) {
        self.placeholderLabel.hidden=YES;
    }
    else{
        self.placeholderLabel.hidden=NO;
    }
}

- (void)return{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send{
    [self.SendquestionTextView resignFirstResponder];
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"发送成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.SendquestionTextView.text=nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.SendquestionTextView resignFirstResponder];
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
