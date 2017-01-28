//
//  WRQMyViewController.m
//  西邮图书馆
//
//  Created by wuruiqing on 16/11/14.
//  Copyright (c) 2016年 WRQ. All rights reserved.
//

#import "WRQMyViewController.h"
#import "WRQMyTableViewCell.h"
#import "WRQLoginViewController.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "WRQMyModel.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQMyViewController ()
@property(strong,nonatomic)UITableView *TableView;
@property(strong,nonatomic)NSArray *ChooseArray;
@property(strong,nonatomic)UITapGestureRecognizer *imagetap;
@property(strong,nonatomic)UITapGestureRecognizer *labeltap;
@property(strong,nonatomic)WRQMyModel *myModel;
@end

@implementation WRQMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.TableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, W, H) style:UITableViewStyleGrouped];
    self.TableView.delegate=self;
    self.TableView.dataSource=self;
    self.TableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, W, 0.1)];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.TableView.scrollEnabled=NO;
    [self.view addSubview:self.TableView];
    
    self.ChooseArray=[[NSArray alloc]initWithObjects:@"我的借阅",@"我的收藏",@"我的足迹",@"续借提醒",nil];
    
    self.isLogin=NO;
    
    self.imagetap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
    
    self.labeltap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else
        return self.ChooseArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return H*0.25;
    }
    else
        return H*0.06;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        WRQMyTableViewCell *cell=[[WRQMyTableViewCell alloc]init];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mybackground-1"]];
        if(self.isLogin==NO){
            cell.loginLabel.hidden=NO;
            cell.loginButton.hidden=NO;
            cell.numberLabel.hidden=YES;
            cell.classLabel.hidden=YES;
            cell.nameLabel.hidden=YES;
            [cell.loginButton addTarget:self action:@selector(pressloginButton) forControlEvents:UIControlEventTouchUpInside];
            cell.loginLabel.userInteractionEnabled=YES;
            cell.headImage.userInteractionEnabled=YES;
            [cell.headImage addGestureRecognizer:self.imagetap];
            [cell.loginLabel addGestureRecognizer:self.labeltap];
        }
        else{
            cell.numberLabel.hidden=NO;
            cell.classLabel.hidden=NO;
            cell.nameLabel.hidden=NO;
            cell.loginLabel.hidden=YES;
            cell.loginButton.hidden=YES;
            cell.nameLabel.text=self.myModel.Name;
            cell.classLabel.text=self.myModel.Department;
            cell.numberLabel.text=self.myModel.ID;
        }
        return cell;
    }
    else{
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=self.ChooseArray[indexPath.row];
        return cell;
    }
}

- (void)getdata{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/info?session=%@",self.session] parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
          self.myModel=[WRQMyModel yy_modelWithDictionary:Detaildic];
          [self.TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)pushLoginView{
    WRQLoginViewController *loginViewController=[[WRQLoginViewController alloc]init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section!=0){
        if (self.isLogin==NO) {
            [self pushLoginView];
        }
    }
}

- (void)doTap{
    if (self.isLogin==NO) {
        [self pushLoginView];
    }
}

- (void)pressloginButton{
    [self pushLoginView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.TableView deselectRowAtIndexPath:[self.TableView indexPathForSelectedRow] animated:NO];
    self.navigationController.navigationBarHidden=YES;
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.isLogin!=Delegate.islogin){
        self.isLogin=Delegate.islogin;
        if (self.isLogin==YES) {
            NSCharacterSet *characterset=[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> .~"]invertedSet];
            self.session=[Delegate.session stringByAddingPercentEncodingWithAllowedCharacters:characterset];
            [self getdata];
        }
        else
            [self.TableView reloadData];
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
