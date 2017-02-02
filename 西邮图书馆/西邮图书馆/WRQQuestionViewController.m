//
//  WRQQuestionViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQQuestionViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQQuestionViewController ()
@property(strong,nonatomic)UITableView *TableView;
@property(strong,nonatomic)NSArray *QuestionArray;
@property(strong,nonatomic)NSArray *AnswerArray;
@end

@implementation WRQQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.navigationItem.title=@"常见问题";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStyleDone target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;
    
    self.TableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.TableView.delegate=self;
    self.TableView.dataSource=self;
    self.TableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.TableView];
    
    self.QuestionArray=[[NSArray alloc]initWithObjects:@"1.登录时学号密码都指什么？",@"2.学号和用户名安全么?",nil];
    self.AnswerArray=[[NSArray alloc]initWithObjects:@"学号即各位同学登录本校图书馆系统所使用的学号，密码及各位同学登陆本校图书馆系统所使用的密码。",@"为了提高查询速度和缓解服务器压力，我们只对一些图书信息进行了缓存，但不存任何用户密码信息，请放心使用。", nil];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return H*0.05;
    }
    else
        return H*0.25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        UILabel *QuestionLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.03, H*0.01, W-W*0.03, H*0.03)];
        QuestionLabel.text=self.QuestionArray[indexPath.section];
        [cell.contentView addSubview:QuestionLabel];
    }
    else{
        UILabel *AnswerLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.03, 0, W-W*0.03, H*0.1)];
        AnswerLabel.numberOfLines=0;
        AnswerLabel.text=self.AnswerArray[indexPath.section];
        [cell.contentView addSubview:AnswerLabel];
    }
    return cell;
}

- (void)return{
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
