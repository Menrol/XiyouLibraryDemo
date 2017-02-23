//
//  WRQQuestionViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQQuestionViewController.h"
#import "WRQQuestionTableViewCell.h"
#import "Masonry.h"
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
    self.view.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.99 alpha:1.00];
    self.navigationItem.title=@"常见问题";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;
    
    UIImageView *questionImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"question.png"]];
    [self.view addSubview:questionImage];
    [questionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.size.mas_equalTo(CGSizeMake(W, H*0.28));
    }];
    
    self.TableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+H*0.26, W, H-64-H*0.22) style:UITableViewStylePlain];
    self.TableView.delegate=self;
    self.TableView.dataSource=self;
    self.TableView.separatorStyle=UITableViewCellSelectionStyleNone;
    self.TableView.backgroundColor=[UIColor clearColor];
    self.TableView.scrollEnabled=NO;
    [self.view addSubview:self.TableView];
    
    self.QuestionArray=[[NSArray alloc]initWithObjects:@"Q:登录时学号密码都指什么？",@"Q:学号和用户名安全么?",nil];
    self.AnswerArray=[[NSArray alloc]initWithObjects:@"学号即各位同学登录本校图书馆系统所使用的学号，密码及各位同学登陆本校图书馆系统所使用的密码。",@"为了提高查询速度和缓解服务器压力，我们只对一些图书信息进行了缓存，但不存任何用户密码信息，请放心使用。", nil];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H*0.26;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQQuestionTableViewCell *cell=[self.TableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[WRQQuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.questionLabel.text=self.QuestionArray[indexPath.row];
    cell.answerLabel.text=self.AnswerArray[indexPath.row];
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
