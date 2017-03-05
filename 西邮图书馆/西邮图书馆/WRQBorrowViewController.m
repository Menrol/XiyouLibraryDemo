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
@property(assign,nonatomic)NSInteger count;
@property(strong,nonatomic)NSIndexPath *nowindexpath;
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
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(W*0.8, 1));
    }];
    
    self.summaryLabel=[[UILabel alloc]init];
    self.summaryLabel.font=[UIFont systemFontOfSize:13];
    self.summaryLabel.numberOfLines=0;
    self.summaryLabel.textAlignment=NSTextAlignmentCenter;
    self.summaryLabel.textColor=[UIColor grayColor];
    [self.view addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.02);
        make.left.equalTo(self.view).with.offset(W*0.05);
        make.size.mas_equalTo(CGSizeMake(W*0.9, 1));
    }];
    
    self.bookModelArray=[[NSMutableArray alloc]init];
    
    self.detailModelArray=[[NSMutableArray alloc]init];
    
    [self setLoadAnimation];
    
    [self setactivityindicatorView];

    // Do any additional setup after loading the view.
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
    WRQBookdetailModel *detailModel=self.detailModelArray[indexPath.item];
    if (detailModel.Image.length!=0) {
        AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi||([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN&&Delegate.canLoadImage)) {
            nopictureImageView.hidden=YES;
            [bookImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.Image]];
        }
        else{
            nopictureImageView.hidden=NO;
            bookImageView.image=nil;
        }
    }
    else{
        nopictureImageView.hidden=NO;
        bookImageView.image=nil;
    }
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.x>0&&self.nowindexpath.item+2>self.detailModelArray.count&&self.count<self.bookModelArray.count) {
        WRQBorrowModel *borrowModel=self.bookModelArray[self.count];
        [self getdetaildata:borrowModel.Barcode];
        [self.activityindicatorView startAnimating];
        self.collectionView.scrollEnabled=NO;
        self.collectionView.userInteractionEnabled=NO;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point=[self.view convertPoint:self.collectionView.center toView:self.collectionView];
    self.nowindexpath=[self.collectionView indexPathForItemAtPoint:point];
    if (self.nowindexpath.item<self.bookModelArray.count) {
        WRQBookdetailModel *detailModel=self.detailModelArray[self.nowindexpath.item];
        CGSize titlesize=[detailModel.size CGSizeValue];
        self.titleLabel.text=detailModel.Title;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(W*0.8, titlesize.height+1));
        }];
        self.summaryLabel.text=detailModel.Summary;
        CGSize summarysize=[detailModel.Summary boundingRectWithSize:CGSizeMake(W*0.9, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        [self.summaryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
            make.left.equalTo(self.view).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.9, summarysize.height+1));
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WRQBookdetailModel *bookdetailModel=self.detailModelArray[indexPath.item];
    WRQBookdetailViewController *bookdetailViewController=[[WRQBookdetailViewController alloc]init];
    bookdetailViewController.url=[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/id/%@",bookdetailModel.ID];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:bookdetailViewController animated:YES];
}

- (void)getdetaildata:(NSString *)barcode{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/barcode/%@",barcode] parameters:nil progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        self.count++;
        [self.activityindicatorView stopAnimating];
        self.collectionView.scrollEnabled=YES;
        self.collectionView.userInteractionEnabled=YES;
        [self.collectionView reloadData];
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

- (void)getfirstdetail:(NSString *)barcode{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/barcode/%@",barcode] parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
             self.count++;
             [self.LoadView stopAnimating];
             [self.collectionView reloadData];
             self.titleLabel.text=bookdetailModel.Title;
             [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
                 make.centerX.equalTo(self.view);
                 make.size.mas_equalTo(CGSizeMake(W*0.8, size.height+1));
             }];
             self.summaryLabel.text=bookdetailModel.Summary;
             CGSize summarysize=[bookdetailModel.Summary boundingRectWithSize:CGSizeMake(W*0.9, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
             [self.summaryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self.titleLabel.mas_bottom).with.offset(H*0.01);
                 make.left.equalTo(self.view).with.offset(W*0.05);
                 make.size.mas_equalTo(CGSizeMake(W*0.9, summarysize.height+1));
             }];
             self.nowindexpath=[NSIndexPath indexPathForItem:0 inSection:0];
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
        id Detail=[responseObject objectForKey:@"Detail"];
        if([Detail isKindOfClass:[NSString class]]){
            [self.LoadView stopAnimating];
            [self setnobookView];
            self.collectionView.hidden=YES;
        }
        else{
            NSArray *detailArray=(NSArray *)Detail;
            for (NSDictionary *dic in detailArray) {
                WRQBorrowModel *borrowModel=[WRQBorrowModel yy_modelWithDictionary:dic];
                [self.bookModelArray addObject:borrowModel];
            }
            self.count=0;
            WRQBorrowModel *borrowModel=self.bookModelArray[self.count];
            [self getfirstdetail:borrowModel.Barcode];
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
