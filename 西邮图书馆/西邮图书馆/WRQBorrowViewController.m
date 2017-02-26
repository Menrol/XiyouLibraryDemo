//
//  WRQBorrowViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/2/10.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQBorrowViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "WRQBorrowModel.h"
#import "WRQBookdetailModel.h"
#import "WRQBookdetailViewController.h"
#import "AppDelegate.h"
#import "WRQLineLayout.h"
#import "NoNetworkView.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQBorrowViewController ()
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UIImageView *topView;
@property(strong,nonatomic)NSMutableArray *bookModelArray;
@property(strong,nonatomic)NSMutableArray *detailModelArray;
@property(strong,nonatomic)UIAlertController *alertController;
@property(strong,nonatomic)UIActivityIndicatorView *activityindicatorView;
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *summaryLabel;
@property(strong,nonatomic)UIImageView *LoadView;
@property(strong,nonatomic)NoNetworkView *nonetworkView;
@end

@implementation WRQBorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getID];
    
    self.navigationItem.title=@"我的借阅";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *returnButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return.png"] style:UIBarButtonItemStylePlain target:self action:@selector(return)];
    self.navigationItem.leftBarButtonItem=returnButton;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.topView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background-1"]];
    self.topView.userInteractionEnabled=YES;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W, H*0.25));
    }];

    WRQLineLayout *lineLayout=[[WRQLineLayout alloc]init];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:lineLayout];
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.backgroundColor=[UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(W, H*0.35));
    }];
    
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    self.titleLabel.numberOfLines=0;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
//    self.titleLabel.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W*0.8, H*0.03));
    }];
    
    self.summaryLabel=[[UILabel alloc]init];
    self.summaryLabel.font=[UIFont systemFontOfSize:15];
    self.summaryLabel.numberOfLines=0;
    self.summaryLabel.textAlignment=NSTextAlignmentCenter;
    self.summaryLabel.textColor=[UIColor grayColor];
//    self.summaryLabel.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.02);
        make.left.equalTo(self.view).with.offset(W*0.05);
        make.bottom.equalTo(self.view).with.offset(-H*0.03);
        make.width.mas_equalTo(W*0.9);
    }];
    
    self.bookModelArray=[[NSMutableArray alloc]init];
    
    self.detailModelArray=[[NSMutableArray alloc]init];
    
    [self setLoadAnimation];
    
    // Do any additional setup after loading the view.
}

- (void)networkstatus:(NSNotification *)notification{
    NSDictionary *networkDic=notification.userInfo;
    NSInteger status=[[networkDic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    if (status==AFNetworkReachabilityStatusNotReachable) {
        UIView *backgroundView=[[UIView alloc]init];
        backgroundView.layer.masksToBounds=YES;
        backgroundView.layer.cornerRadius=5;
        backgroundView.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
        [self.view addSubview:backgroundView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(W*0.31, H*0.06));
        }];
        
        UILabel *nonetworkLabel=[[UILabel alloc]init];
        nonetworkLabel.text=@"网络无法连接";
        nonetworkLabel.textColor=[UIColor whiteColor];
        nonetworkLabel.backgroundColor=[UIColor colorWithRed:0.05 green:0.10 blue:0.23 alpha:1.00];
        nonetworkLabel.layer.masksToBounds=YES;
        nonetworkLabel.layer.cornerRadius=5;
        nonetworkLabel.font=[UIFont systemFontOfSize:15];
        [backgroundView addSubview:nonetworkLabel];
        [nonetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backgroundView);
            make.size.mas_equalTo(CGSizeMake(W*0.25, H*0.06));
        }];
        NSTimer *timer=[NSTimer timerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
            backgroundView.hidden=YES;
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.detailModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *bookImageView=[[UIImageView alloc]init];
    bookImageView.backgroundColor=[UIColor grayColor];
    [cell.contentView addSubview:bookImageView];
    [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(W*0.35, H*0.28));
    }];
    UIImageView *nopictureImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"final.png"]];
    [bookImageView addSubview:nopictureImageView];
    [nopictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(H*0.1, H*0.1));
    }];
    WRQBookdetailModel *detailModel=self.detailModelArray[indexPath.row];
    CGSize size=[detailModel.size CGSizeValue];
    if (detailModel.Image.length!=0) {
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi||([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN&&Delegate.canLoadImage)) {
            nopictureImageView.hidden=YES;
            [bookImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.Image]];
        }
        else{
            nopictureImageView.hidden=NO;
        }
    }
    else{
        nopictureImageView.hidden=NO;
    }
    self.titleLabel.text=detailModel.Title;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W*0.8, size.height));
    }];
    self.summaryLabel.text=detailModel.Summary;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WRQBookdetailModel *bookdetailModel=self.detailModelArray[indexPath.row];
    WRQBookdetailViewController *bookdetailViewController=[[WRQBookdetailViewController alloc]init];
    bookdetailViewController.url=[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/id/%@",bookdetailModel.ID];
    [self.navigationController pushViewController:bookdetailViewController animated:YES];
}

- (void)getdetaildata:(NSString *)barcode{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/barcode/%@",barcode] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
        WRQBookdetailModel *bookdetailModel=[WRQBookdetailModel yy_modelWithDictionary:Detaildic];
        NSDictionary *Doubandic=[Detaildic objectForKey:@"DoubanInfo"];
        if ([Doubandic isEqual:[NSNull null]]) {
            bookdetailModel.Image=nil;
        }
        else{
            NSDictionary *Imagedic=[Doubandic objectForKey:@"Images"];
            bookdetailModel.Image=[Imagedic objectForKey:@"large"];
        }
        CGSize size=[bookdetailModel.Title boundingRectWithSize:CGSizeMake(W*0.8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil].size;
        NSValue *value=[NSValue valueWithCGSize:size];
        bookdetailModel.size=value;
        [self.detailModelArray addObject:bookdetailModel];
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

- (void)getID{
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/rent?session=%@",Delegate.session] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        id Detail=[responseObject objectForKey:@"Detail"];
        if([Detail isKindOfClass:[NSString class]]){
            [self.LoadView stopAnimating];
            [self setnobookView];
            self.collectionView.hidden=YES;
        }
        else{
            for (NSDictionary *dic in (NSArray *)Detail) {
                WRQBorrowModel *borrowModel=[WRQBorrowModel yy_modelWithDictionary:dic];
                [self.bookModelArray addObject:borrowModel];
                [self getdetaildata:borrowModel.Barcode];
            }
            [self.collectionView reloadData];
            [self.LoadView stopAnimating];
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

- (void)setnonetworkview{
    self.nonetworkView=[[NoNetworkView alloc]init];
    [self.nonetworkView.reloadButton addTarget:self action:@selector(tryagain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nonetworkView];
    [self.nonetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W, H*0.26));
    }];
}

- (void)tryagain{
    self.nonetworkView.hidden=YES;
    [self.LoadView startAnimating];
    [self getID];
}

- (void)setnobookView{
    UIImageView *nobookImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-1.png"]];
    [self.view addSubview:nobookImage];
    [nobookImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(H*0.3, H*0.3));
    }];
    
    UILabel *nobookLabel=[[UILabel alloc]init];
    nobookLabel.text=@"暂无借阅书籍";
    nobookLabel.font=[UIFont boldSystemFontOfSize:20];
    nobookLabel.transform=CGAffineTransformMakeRotation(0.12);
    CGSize size=[nobookLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [nobookImage addSubview:nobookLabel];
    [nobookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nobookImage).with.offset(H*0.03);
        make.top.equalTo(nobookImage).with.offset(H*0.08);
        make.size.mas_equalTo(CGSizeMake(size.width+1, H*0.03));
    }];
}

//- (void)updatedata{
//    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
//    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/rent?session=%@",Delegate.session] parameters:nil progress:nil
//    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *detailArray=[responseObject objectForKey:@"Detail"];
//        [self.bookModelArray removeAllObjects];
//        for (NSDictionary *dic in detailArray) {
//            WRQBorrowModel *borrowModel=[WRQBorrowModel yy_modelWithDictionary:dic];
//            [self.bookModelArray addObject:borrowModel];
//        }
//        [self.collectionView reloadData];
//        [self.activityindicatorView stopAnimating];
//        [self presentViewController:self.alertController animated:YES completion:nil];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}

//- (void)pressrenew:(UIButton *)btn{
//    [self.activityindicatorView startAnimating];
//    WRQBorrowModel *borrowModel=self.bookModelArray[btn.tag];
//    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
//    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/renew?session=%@&barcode=%@&department_id=%@&library_id=%@",Delegate.session,borrowModel.Barcode,borrowModel.Department_id,borrowModel.Library_id] parameters:nil progress:nil
//    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        NSString *datestr=[responseObject objectForKey:@"Detail"];
//        self.alertController=[UIAlertController alertControllerWithTitle:@"续借成功" message:[NSString stringWithFormat:@"新的还书日期为%@",datestr] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [self.alertController addAction:yesAction];
//        [self updatedata];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}

- (void)setLoadAnimation{
    self.LoadView=[[UIImageView alloc]init];
    [self.view addSubview:self.LoadView];
    [self.LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
