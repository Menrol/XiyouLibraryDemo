//
//  WRQQuestionsendViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQQuestionsendViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQQuestionsendViewController ()
@property(strong,nonatomic)UITextView *SendquestionTextView;
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
    self.SendquestionTextView.text=@"请留下宝贵的意见，我们将不断完善，谢谢";
    [self.view addSubview:self.SendquestionTextView];
    // Do any additional setup after loading the view.
}

- (void)return{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send{
    [self.SendquestionTextView resignFirstResponder];
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
