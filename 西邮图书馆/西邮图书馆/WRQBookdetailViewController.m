//
//  WRQBookdetailViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBookdetailViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "tableHeaderView.h"
#import "tableSectionView.h"
#import "tableCirculationView.h"
#import "WRQBooKbasicTableViewCell.h"
#import "WRQCirculationTableViewCell.h"
#import "WRQReferTableViewCell.h"
#import "WRQBookdetailModel.h"
#import "WRQCirculationModel.h"
#import "WRQReferbooksModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "WRQLoginViewController.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQBookdetailViewController ()
@property(strong,nonatomic)UITableView *tableview;
@property(strong,nonatomic)UIButton *returnBtn;
@property(strong,nonatomic)UIButton *upBtn;
@property(strong,nonatomic)NSMutableArray *bookdetailModelArray;
@property(strong,nonatomic)NSMutableArray *circulationModelArray;
@property(strong,nonatomic)NSMutableArray *referbooksModelArray;
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)UIActivityIndicatorView *activityindicatorView;
@property(nonatomic,strong)NoNetworkView *nonetworkView;
@end

@implementation WRQBookdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getdetaildata];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"书籍详情";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.74 green:0.78 blue:0.84 alpha:1.00];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    self.returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:[UIImage imageNamed:@"return-1.png"] forState:UIControlStateNormal];
    self.returnBtn.layer.masksToBounds=YES;
    self.returnBtn.layer.cornerRadius=H*0.03;
    self.returnBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.returnBtn addTarget:self action:@selector(pressreturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.returnBtn];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        make.top.equalTo(self.view).with.offset(30);
        make.left.equalTo(self.view).with.offset(H*0.01);
    }];
    
    self.upBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.upBtn setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    self.upBtn.layer.masksToBounds=YES;
    self.upBtn.layer.cornerRadius=H*0.03;
    self.upBtn.hidden=YES;
    self.upBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.upBtn addTarget:self action:@selector(pressup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upBtn ];
    [self.upBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(H*0.06, H*0.06));
        make.bottom.equalTo(self.view).with.offset(-H*0.05);
        make.right.equalTo(self.view).with.offset(-H*0.03);
    }];
    
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, W, H) style:UITableViewStyleGrouped];
    self.tableview.showsVerticalScrollIndicator=NO;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=UITableViewCellSelectionStyleNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableview.sectionFooterHeight=0;
    self.tableview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableview];
    self.tableview.hidden=YES;
    
    [self.view bringSubviewToFront:self.returnBtn];
    [self.view bringSubviewToFront:self.upBtn];
    
    [self setLoadAnimation];
    
    [self setactivityindicatorView];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number=1;
            break;
        case 1:
            number=1;
            break;
        case 2:
            number=self.circulationModelArray.count;
            break;
        case 3:
            number=1;
            break;
        case 4:
            number=self.referbooksModelArray.count;
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[indexPath.row];
        CGSize size=[bookdetailModel.size CGSizeValue];
        return H*0.01+size.height;
    }
    else if (indexPath.section==1) {
        return H*0.22;
    }
    else if (indexPath.section==2){
        WRQCirculationModel *circulationModel=self.circulationModelArray[indexPath.row];
        if (circulationModel.Date.length==0) {
            return H*0.14;
        }
        else
            return H*0.18;
    }
    else if (indexPath.section==4){
        WRQReferbooksModel *referbooksModel=self.referbooksModelArray[indexPath.row];
        CGSize size=[referbooksModel.size CGSizeValue];
        return H*0.11+size.height;
    }
    else
        return H*0.06;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
        cell.textLabel.numberOfLines=0;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[indexPath.row];
        cell.textLabel.text=bookdetailModel.Title;
        return cell;
    }
    else if (indexPath.section==1) {
        WRQBooKbasicTableViewCell *cell=[[WRQBooKbasicTableViewCell alloc]init];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[indexPath.row];
        cell.authorLabel.text=bookdetailModel.Author;
        cell.sortLabel.text=bookdetailModel.Sort;
        cell.PubLabel.text=bookdetailModel.Pub;
        cell.FavLabel.text=bookdetailModel.FavTimes;
        cell.renttimesLabel.text=bookdetailModel.RentTimes;
        return cell;
    }
    else if (indexPath.section==2){
        WRQCirculationTableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:@"circulation"];
        if (cell==NULL) {
            cell=[[WRQCirculationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"circulation"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        WRQCirculationModel *circulationModel=self.circulationModelArray[indexPath.row];
        if (circulationModel.Date.length==0) {
            cell.dateLabel.hidden=YES;
            cell.datetitleLabel.hidden=YES;
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            btn.layer.cornerRadius=10;
            cell.backgroundView=btn;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).with.offset(W*0.05);
                make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.11));
            }];
        }
        else{
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            btn.layer.cornerRadius=10;
            cell.backgroundView=btn;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).with.offset(W*0.05);
                make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.15));
            }];
        }
        cell.barcodeLabel.text=circulationModel.Barcode;
        cell.stateLabel.text=circulationModel.Status;
        cell.departmentLabel.text=circulationModel.Department;
        cell.dateLabel.text=circulationModel.Date;
        return cell;
    }
    else if (indexPath.section==4){
        WRQReferTableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:@"refer"];
        if (cell==NULL) {
            cell=[[WRQReferTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"refer"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        WRQReferbooksModel *referbooksModel=self.referbooksModelArray[indexPath.row];
        CGSize size=[referbooksModel.size CGSizeValue];
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(0);
            make.left.equalTo(cell).with.offset(W*0.1);
            make.size.mas_equalTo(CGSizeMake(W*0.8, size.height));
        }];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        btn.layer.cornerRadius=10;
        cell.backgroundView=btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, H*0.08+size.height));
        }];
        cell.titleLabel.text=referbooksModel.Title;
        cell.authorLabel.text=referbooksModel.Author;
        cell.IDLabel.text=referbooksModel.ID;
        return cell;
    }
    else{
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[0];
        cell.textLabel.text=bookdetailModel.Subject;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return H*0.12;
    }
    else if(section==0)
        return 0;
    else
        return H*0.08;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        tableSectionView *sectionView=[[tableSectionView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.06)];
        sectionView.numberImageView.image=[UIImage imageNamed:@"number-1.png"];
        sectionView.titleLabel.text=@"基本资料";
        [sectionView.collectBtn addTarget:self action:@selector(presscollect) forControlEvents:UIControlEventTouchUpInside];
        return sectionView;
    }
    else if (section==2){
        tableCirculationView *circulationView=[[tableCirculationView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.12)];
        circulationView.numberImageView.image=[UIImage imageNamed:@"number-2.png"];
        circulationView.titleLabel.text=@"流通情况";
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[0];
        circulationView.borrowLabel.text=bookdetailModel.Avaliable;
        circulationView.totalLabel.text=bookdetailModel.Total;
        return circulationView;
    }
    else{
        tableSectionView *sectionView=[[tableSectionView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.06)];
        sectionView.numberImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"number-%ld.png",(long)section]];
        if (section==3) {
            sectionView.titleLabel.text=@"图书主题";
        }
        else
            sectionView.titleLabel.text=@"相关推荐";
        sectionView.collectBtn.hidden=YES;
        sectionView.collectImageView.hidden=YES;
        return sectionView;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>0) {
        self.returnBtn.hidden=YES;
        if(scrollView.contentOffset.y<H/2.0){
            if (scrollView.contentOffset.y<H*0.1) {
                self.returnBtn.hidden=NO;
            }
            self.upBtn.hidden=YES;
        }
        else
            self.upBtn.hidden=NO;
    }
    else if (scrollView.contentOffset.y<=0){
        self.returnBtn.hidden=NO;
    }
}

- (void)getdetaildata{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:self.url parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.bookdetailModelArray=[[NSMutableArray alloc]init];
        self.circulationModelArray=[[NSMutableArray alloc]init];
        self.referbooksModelArray=[[NSMutableArray alloc]init];
        NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
        WRQBookdetailModel *bookdetailModel=[WRQBookdetailModel yy_modelWithDictionary:Detaildic];
        NSDictionary *Doubandic=[Detaildic objectForKey:@"DoubanInfo"];
        if ([Doubandic isEqual:[NSNull null]]) {
            tableHeaderView *headerView=[[tableHeaderView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.29)];
            self.tableview.tableHeaderView=headerView;
        }
        else{
            NSDictionary *Imagedic=[Doubandic objectForKey:@"Images"];
            bookdetailModel.Image=[Imagedic objectForKey:@"large"];
            tableHeaderView *headerView=[[tableHeaderView alloc]initWithFrame:CGRectMake(0, 0, W, H*0.29)];
            NSURL *imageurl=[NSURL URLWithString:bookdetailModel.Image];
            self.tableview.tableHeaderView=headerView;
            AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi||([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN&&Delegate.canLoadImage)) {
                headerView.nopictureImage.hidden=YES;
                [headerView.bookImageView sd_setImageWithURL:imageurl];
            }
        }
        CGSize size=[bookdetailModel.Title boundingRectWithSize:CGSizeMake(W*0.9, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil].size;
        NSValue *value=[NSValue valueWithCGSize:size];
        bookdetailModel.size=value;
        [self.bookdetailModelArray addObject:bookdetailModel];
        NSArray *circulationArray=[Detaildic objectForKey:@"CirculationInfo"];
        for (NSDictionary *dic in circulationArray) {
            WRQCirculationModel *circulationModel=[WRQCirculationModel yy_modelWithDictionary:dic];
            [self.circulationModelArray addObject:circulationModel];
        }
        NSArray *referbooksArray=[Detaildic objectForKey:@"ReferBooks"];
        for (NSDictionary *dic in referbooksArray) {
            WRQReferbooksModel *referbooksModel=[WRQReferbooksModel yy_modelWithDictionary:dic];
            CGSize size=[referbooksModel.Title boundingRectWithSize:CGSizeMake(W*0.8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            NSValue *value=[NSValue valueWithCGSize:size];
            referbooksModel.size=value;
            [self.referbooksModelArray addObject:referbooksModel];
        }
        [self.LoadView stopAnimating];
        self.LoadView.hidden=YES;
        [self.tableview reloadData];
        self.tableview.hidden=NO;
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            NSTimer *timer=[NSTimer timerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self.LoadView stopAnimating];
                [self setnonetworkview];
            }];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getdetaildata];
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
    for (int i=1; i<17; i++) {
        [ImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
    }
    self.LoadView.animationImages=ImageArray;
    self.LoadView.animationDuration=1;
    self.LoadView.animationRepeatCount=0;
    [self.LoadView startAnimating];
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

- (void)pressup{
    [self.tableview setContentOffset:CGPointMake(0, 0)];
    self.upBtn.hidden=YES;
    self.returnBtn.hidden=NO;
}

- (void)presscollect{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (Delegate.islogin==YES) {
        WRQBookdetailModel *bookdetailModel=self.bookdetailModelArray[0];
        AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
        [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/addFav?session=%@&id=%@",Delegate.session,bookdetailModel.ID] parameters:nil progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *result=[responseObject objectForKey:@"Detail"];
            [self.activityindicatorView stopAnimating];
            self.returnBtn.userInteractionEnabled=YES;
            if ([result isEqualToString:@"ADDED_SUCCEED"]) {
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"收藏成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([result isEqualToString:@"ALREADY_IN_FAVORITE"]){
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"已收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([result isEqualToString:@"ADDED_FAILED"]){
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"收藏失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(![AFNetworkReachabilityManager sharedManager].isReachable){
                [self.activityindicatorView stopAnimating];
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"网络无法连接" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        [self.activityindicatorView startAnimating];
        self.returnBtn.userInteractionEnabled=NO;
    }
    else{
        WRQLoginViewController *loginViewController=[[WRQLoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)pressreturn{
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
