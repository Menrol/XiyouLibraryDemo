//
//  WRQCollectViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQCollectViewController.h"
#import "WRQCollectTableViewCell.h"
#import "WRQCollectModel.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQCollectViewController ()
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *collectModelArray;
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)UIBarButtonItem *returnButton;
@property(strong,nonatomic)UIBarButtonItem *editButton;
@property(strong,nonatomic)UIBarButtonItem *deleteButton;
@property(strong,nonatomic)UIBarButtonItem *finishButton;
@property(strong,nonatomic)NSMutableArray *selectArray;
@property(strong,nonatomic)NoNetworkView *nonetworkView;
@end

@implementation WRQCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self isHaveCollection];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的收藏";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.returnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=self.returnButton;
    
    self.editButton=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressedit)];
    
    self.finishButton=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressfinish)];
    
    self.deleteButton=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(pressdelete)];
    
    self.tableView=[[UITableView alloc]init];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
        make.size.mas_equalTo(CGSizeMake(W, H-64));
    }];
    
    self.collectModelArray=[[NSMutableArray alloc]init];
    
    self.selectArray=[[NSMutableArray alloc]init];
    
    [self setLoadAnimation];
    
    // Do any additional setup after loading the view.
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

- (void)setnobookView{
    UIImageView *nobookImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-1.png"]];
    [self.view addSubview:nobookImage];
    [nobookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.3, H*0.3));
    }];
    
    UILabel *nobookLabel=[[UILabel alloc]init];
    nobookLabel.text=@"暂无收藏书籍";
    nobookLabel.font=[UIFont boldSystemFontOfSize:20];
    nobookLabel.transform=CGAffineTransformRotate(nobookLabel.transform, 0.12);
    CGSize size=[nobookLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [nobookImage addSubview:nobookLabel];
    [nobookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nobookImage).with.offset(H*0.03);
        make.top.equalTo(nobookImage).with.offset(H*0.08);
        make.size.mas_equalTo(CGSizeMake(size.width+1, H*0.03));
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H*0.29;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQCollectTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[WRQCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    WRQCollectModel *collectModel=self.collectModelArray[indexPath.row];
    if (collectModel.Image.length!=0) {
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi||([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN&&Delegate.canLoadImage)) {
            cell.nopictureImage.hidden=YES;
            [cell.BookImageView sd_setImageWithURL:[NSURL URLWithString:collectModel.Image]];
        }
        else{
            cell.nopictureImage.hidden=NO;
            cell.BookImageView.image=nil;
        }
    }
    else{
        cell.nopictureImage.hidden=NO;
        cell.BookImageView.image=nil;
    }
    cell.BooknameLabel.text=collectModel.Title;
    cell.authorLabel.text=collectModel.Author;
    cell.sortLabel.text=collectModel.Sort;
    cell.pubLabel.text=collectModel.Pub;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        WRQCollectModel *collectModel=self.collectModelArray[indexPath.row];
        if (![self.selectArray containsObject:collectModel]) {
            [self.selectArray addObject:collectModel];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        WRQCollectModel *collectModel=self.collectModelArray[indexPath.row];
        if ([self.selectArray containsObject:collectModel]) {
            [self.selectArray removeObject:collectModel];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        WRQCollectModel *collectModel=[self.collectModelArray objectAtIndex:indexPath.row];
        [self.collectModelArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSTimer *timer=[NSTimer timerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            if(self.collectModelArray.count==0){
                [self setnobookView];
                self.navigationItem.rightBarButtonItem=nil;
            }
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        [self deletecollect:collectModel];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)pressedit{
    self.navigationItem.leftBarButtonItem=self.deleteButton;
    self.navigationItem.rightBarButtonItem=self.finishButton;
    self.tableView.editing=YES;
    self.tableView.allowsSelection=YES;
}

- (void)pressfinish{
    [self.selectArray removeAllObjects];
    self.navigationItem.leftBarButtonItem=self.returnButton;
    self.navigationItem.rightBarButtonItem=self.editButton;
    self.tableView.editing=NO;
    self.tableView.allowsSelection=NO;
}

- (void)pressdelete{
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"删除失败" message:@"请检查网络状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSMutableArray *indexpathArray=[[NSMutableArray alloc]init];
        for (WRQCollectModel *collectModel in self.selectArray) {
            NSInteger index=[self.collectModelArray indexOfObject:collectModel];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:index inSection:0];
            [indexpathArray addObject:indexpath];
        }
        [self.collectModelArray removeObjectsInArray:self.selectArray];
        [self.tableView deleteRowsAtIndexPaths:indexpathArray withRowAnimation:UITableViewRowAnimationFade];
        NSTimer *timer=[NSTimer timerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            if(self.collectModelArray.count==0){
                [self setnobookView];
                self.navigationItem.rightBarButtonItem=nil;
            }
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        for (WRQCollectModel *collectModel in self.selectArray) {
            [self deletecollect:collectModel];
        }
    }
    [self.selectArray removeAllObjects];
    self.navigationItem.leftBarButtonItem=self.returnButton;
    self.navigationItem.rightBarButtonItem=self.editButton;
    self.tableView.editing=NO;
    self.tableView.allowsSelection=NO;
}

- (void)isHaveCollection{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/favorite?session=%@",Delegate.session] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id detail=[responseObject objectForKey:@"Detail"];
        if ([detail isKindOfClass:[NSString class]]) {
            [self.LoadView stopAnimating];
            [self setnobookView];
            self.navigationItem.rightBarButtonItem=nil;
        }
        else{
            NSArray *detailArray=(NSArray *)detail;
            if (detailArray.count==0) {
                [self.LoadView stopAnimating];
                [self setnobookView];
                self.navigationItem.rightBarButtonItem=nil;
            }
            else{
                [self getdata];
            }
        }
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

- (void)getdata{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/favoriteWithImg?session=%@",Delegate.session] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *DetailArray=[responseObject objectForKey:@"Detail"];
        for (NSDictionary *dic in DetailArray) {
            WRQCollectModel *collectModel=[WRQCollectModel yy_modelWithDictionary:dic];
            NSDictionary *imagesdic=[dic objectForKey:@"Images"];
            if (![imagesdic isEqual:[NSNull null]]) {
                collectModel.Image=[imagesdic objectForKey:@"large"];
            }
            else{
                collectModel.Image=nil;
            }
            [self.collectModelArray addObject:collectModel];
        }
        [self.LoadView stopAnimating];
        self.navigationItem.rightBarButtonItem=self.editButton;
        [self.tableView reloadData];
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

- (void)deletecollect:(WRQCollectModel *)collectModel{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/delFav?session=%@&id=%@&username=%@",Delegate.session,collectModel.ID,Delegate.myModel.ID] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self isHaveCollection];
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

- (void)return{
    [self.LoadView stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
