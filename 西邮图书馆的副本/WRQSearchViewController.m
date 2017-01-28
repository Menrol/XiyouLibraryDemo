//
//  WRQSearchViewController.m
//  西邮图书馆
//
//  Created by Apple on 2017/1/14.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "WRQSearchViewController.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "WRQBookModel.h"
#import "WRQBookdetailViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQSearchViewController ()
@property(strong,nonatomic)UISearchBar *searchbar;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)NSMutableArray *bookModelArray;
@property(strong,nonatomic)UILabel *notsearchLabel;
@end

@implementation WRQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"搜索";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.39 green:0.73 blue:0.94 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, W, H*0.06)];
    self.searchbar.placeholder=@"请输入书名关键字";
    self.searchbar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchbar.delegate=self;
    [self.view addSubview:self.searchbar];
    
    self.searchTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+H*0.06, W, H-64-H*0.06)];
    self.searchTableView.delegate=self;
    self.searchTableView.dataSource=self;
    self.searchTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.searchTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.searchTableView];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.searchTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==NULL) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    WRQBookModel *bookModel=self.bookModelArray[indexPath.row];
    cell.textLabel.text=bookModel.Title;
    return cell;
}

- (void)getlist:(NSString *)searchstr{
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:searchstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.bookModelArray=[[NSMutableArray alloc]init];
        NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
        if ([Detaildic isKindOfClass:[NSDictionary class]]) {
            NSArray *BookDataArray=[Detaildic objectForKey:@"BookData"];
            for (NSDictionary *dic in BookDataArray) {
                WRQBookModel *bookModel=[WRQBookModel yy_modelWithJSON:dic];
                [self.bookModelArray addObject:bookModel];
            }
            if (self.searchbar.text.length==0) {
                [self.bookModelArray removeAllObjects];
            }
        }
        [self.searchTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchbar resignFirstResponder];
    UIButton *cancelBtn=[self.searchbar valueForKey:@"cancelButton"];
    cancelBtn.enabled=YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WRQBookModel *bookModel=[[WRQBookModel alloc]init];
    bookModel=self.bookModelArray[indexPath.row];
    WRQBookdetailViewController *bookdetailViewController=[[WRQBookdetailViewController alloc]init];
    bookdetailViewController.ID=bookModel.ID;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:bookdetailViewController animated:YES];
    [self.searchbar resignFirstResponder];
    self.searchbar.showsCancelButton=NO;
    self.searchbar.text=nil;
    [self.bookModelArray removeAllObjects];
    [self.searchTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    UIButton *cancelBtn=[searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled=YES;
    [self.bookModelArray removeAllObjects];
    [self.searchTableView reloadData];
    NSString *searchstr=[[NSString alloc]initWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/search?matchMethod=jq&keyword=%@",searchBar.text];
    NSCharacterSet *characterset=[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> .~"]invertedSet];
    NSString *encodedstr=[searchstr stringByAddingPercentEncodingWithAllowedCharacters:characterset];
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    [session GET:encodedstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.bookModelArray=[[NSMutableArray alloc]init];
        NSDictionary *Detaildic=[responseObject objectForKey:@"Detail"];
        if ([Detaildic isKindOfClass:[NSDictionary class]]) {
            NSArray *BookDataArray=[Detaildic objectForKey:@"BookData"];
            for (NSDictionary *dic in BookDataArray) {
                WRQBookModel *bookModel=[WRQBookModel yy_modelWithJSON:dic];
                [self.bookModelArray addObject:bookModel];
            }
            [self.searchTableView reloadData];
        }
        else{
            self.notsearchLabel=[[UILabel alloc]initWithFrame:CGRectMake(W*0.3, H*0.5, W*0.4, H*0.03)];
            self.notsearchLabel.text=@"未找到相关书籍";
            self.notsearchLabel.font=[UIFont boldSystemFontOfSize:18];
            [self.view addSubview:self.notsearchLabel];
            self.notsearchLabel.hidden=NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length==0){
        [self.bookModelArray removeAllObjects];
        [self.searchTableView reloadData];
    }
    else{
        NSString *searchstr=[[NSString alloc]initWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/search?keyword=%@",searchText];
        NSCharacterSet *characterset=[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]invertedSet];
        NSString *encodedstr=[searchstr stringByAddingPercentEncodingWithAllowedCharacters:characterset];
        [self getlist:encodedstr];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.searchbar.showsCancelButton=NO;
    self.searchbar.text=nil;
    [self.bookModelArray removeAllObjects];
    [self.searchTableView reloadData];
    self.notsearchLabel.hidden=YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchbar.showsCancelButton=YES;
    self.notsearchLabel.hidden=YES;
    UIButton *btn=[searchBar valueForKey:@"cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
