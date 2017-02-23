//
//  WRQAboutusViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/7.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQAboutusViewController.h"
#import "Masonry.h"
#import "WRQQuestionViewController.h"
#import "WRQQuestionsendViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQAboutusViewController ()
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSArray *titleArray;
@property(strong,nonatomic)UILabel *aboutusLabel;
@property(strong,nonatomic)UILabel *identifyLabel;
@end

@implementation WRQAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"关于我们";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *ReturnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=ReturnButton;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.26+64)];
    backgroundView.backgroundColor=[UIColor clearColor];
    
    UIImageView *LogoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((W-H*0.13)/2.0, 64+H*0.02, H*0.11, H*0.11)];
    LogoImageView.layer.masksToBounds=YES;
    LogoImageView.layer.cornerRadius=15;
    LogoImageView.image=[UIImage imageNamed:@"book.png"];
    [backgroundView addSubview:LogoImageView];
    
    UILabel *IntroduceLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.3, 64+H*0.14, W*0.8, H*0.06)];
    IntroduceLabel.text=@"西邮图书馆   V1.0.0";
    IntroduceLabel.textColor=[UIColor blackColor];
    [backgroundView addSubview:IntroduceLabel];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled=NO;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableHeaderView=backgroundView;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo([UIScreen mainScreen].bounds.size);
    }];
    
    self.titleArray=[NSArray arrayWithObjects:@"常见问题",@"问题反馈", nil];
    
    self.identifyLabel=[[UILabel alloc]init];
    self.identifyLabel.text=@"Copyright © 2017年 WRQ. All rights reserved";
    self.identifyLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:self.identifyLabel];
    [self.identifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).with.offset(-H*0.03);
        make.size.mas_equalTo(CGSizeMake(W*0.7, H*0.03));
    }];
    
    self.aboutusLabel=[[UILabel alloc]init];
    self.aboutusLabel.text=@"西邮移动应用开发实验室";
    self.aboutusLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:self.aboutusLabel];
    [self.aboutusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.identifyLabel.mas_top).with.offset(-H*0.01);
        make.size.mas_equalTo(CGSizeMake(W*0.5, H*0.03));
    }];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        WRQQuestionViewController *questionViewController=[[WRQQuestionViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:questionViewController animated:YES];
    }
    else{
        WRQQuestionsendViewController *questionsendViewController=[[WRQQuestionsendViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:questionsendViewController animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
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
