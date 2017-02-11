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
#import "Masonry.h"
#import "WRQCollectViewController.h"
#import "WRQBorrowViewController.h"
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

@interface WRQMyViewController ()
@property(strong,nonatomic)UITableView *TableView;
@property(strong,nonatomic)NSArray *ChooseArray;
@property(strong,nonatomic)UITapGestureRecognizer *imagetap;
@property(strong,nonatomic)UITapGestureRecognizer *labeltap;
@property(strong,nonatomic)WRQMyModel *myModel;
@property(strong,nonatomic)UIImage *headImage;
@property(strong,nonatomic)UIImagePickerController *imagePickerController;
@property(strong,nonatomic)NSArray *imageArray;
@end

@implementation WRQMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.headImage=[UIImage imageNamed:@"nomalhead.png"];
    
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
    
    self.imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"borrow.png"], [UIImage imageNamed:@"collect-1.png"],[UIImage imageNamed:@"feet.png"],[UIImage imageNamed:@"alert.png"],nil];
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
        return H*0.36;
    }
    else
        return H*0.07;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        WRQMyTableViewCell *cell=[[WRQMyTableViewCell alloc]init];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mybackground-1"]];
        if(self.isLogin==NO){
            cell.loginLabel.hidden=NO;
            cell.loginButton.hidden=NO;
            cell.myView.hidden=YES;
            cell.nameLabel.hidden=YES;
            [cell.loginButton addTarget:self action:@selector(pressloginButton) forControlEvents:UIControlEventTouchUpInside];
            cell.loginLabel.userInteractionEnabled=YES;
            cell.headImage.userInteractionEnabled=YES;
            cell.headImage.image=[UIImage imageNamed:@"nomalhead.png"];
            [cell.headImage addGestureRecognizer:self.imagetap];
            [cell.loginLabel addGestureRecognizer:self.labeltap];
        }
        else{
            cell.myView.hidden=NO;
            cell.nameLabel.hidden=NO;
            cell.loginLabel.hidden=YES;
            cell.loginButton.hidden=YES;
            [cell.headImage addGestureRecognizer:self.imagetap];
            cell.headImage.userInteractionEnabled=YES;
            cell.headImage.image=self.headImage;
            cell.nameLabel.text=self.myModel.Name;
            CGSize size=[self.myModel.Name boundingRectWithSize:CGSizeMake(MAXFLOAT, H*0.03) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]} context:nil].size;
            [cell.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell);
                make.top.equalTo(cell.headImage.mas_bottom).with.offset(H*0.01);
                make.size.mas_equalTo(CGSizeMake(size.width, H*0.03));
            }];
            cell.myView.classLabel.text=self.myModel.Department;
            cell.myView.numberLabel.text=self.myModel.ID;
        }
        return cell;
    }
    else{
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *logoImage=[[UIImageView alloc]init];
        [cell.contentView addSubview:logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(H*0.01);
            make.left.equalTo(cell).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(H*0.05, H*0.05));
        }];
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:20];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(H*0.005);
            make.left.equalTo(logoImage.mas_right).with.offset(W*0.05);
            make.size.mas_equalTo(CGSizeMake(W*0.3, H*0.06));
        }];
        logoImage.image=self.imageArray[indexPath.row];
        titleLabel.text=self.ChooseArray[indexPath.row];
        return cell;
    }
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
        else{
            if (indexPath.row==0) {
                WRQBorrowViewController *borrowViewController=[[WRQBorrowViewController alloc]init];
                self.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:borrowViewController animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
        }
    }
}

- (void)doTap{
    if (self.isLogin==NO) {
        [self pushLoginView];
    }
    else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *selectAction=[UIAlertAction actionWithTitle:@"从相册中选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                // 1.调用系统相册,不可多选照片
                self.imagePickerController=[[UIImagePickerController alloc]init];
                self.imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePickerController.allowsEditing=NO;
                self.imagePickerController.delegate=self;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
            else{
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"西邮图书馆没有权限访问您的照片" message:@"请在隐私中允许西邮图书馆访问照片" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.imagePickerController=[[UIImagePickerController alloc]init];
                self.imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                self.imagePickerController.allowsEditing=NO;
                self.imagePickerController.delegate=self;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
            else{
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"西邮图书馆没有权限访问您的相机" message:@"请在隐私中允许西邮图书馆访问相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:selectAction];
        [alertController addAction:cameraAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)writetofile:(UIImage *)image{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *imagedata=UIImageJPEGRepresentation(image, 100);
    [userDefaults setObject:imagedata forKey:@"headimage"];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect{
    self.headImage=croppedImage;
    [self.TableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self writetofile:croppedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    RSKImageCropViewController *imageCropViewController=[[RSKImageCropViewController alloc]initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropViewController.delegate=self;
    imageCropViewController.maskLayerStrokeColor=[UIColor whiteColor];
    [picker presentViewController:imageCropViewController animated:YES completion:nil];
}

- (void)pressloginButton{
    [self pushLoginView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.TableView deselectRowAtIndexPath:[self.TableView indexPathForSelectedRow] animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    AppDelegate *Delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(self.isLogin!=Delegate.islogin){
        self.isLogin=Delegate.islogin;
        if (self.isLogin==YES) {
            self.myModel=Delegate.myModel;
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString *ID=[userDefaults objectForKey:@"ID"];
            if ([self.myModel.ID isEqualToString:ID]) {
                NSData *headimageData=[userDefaults objectForKey:@"headimage"];
                if (headimageData!=nil) {
                    UIImage *headimage=[UIImage imageWithData:headimageData];
                    self.headImage=headimage;
                }
                else
                    self.headImage=[UIImage imageNamed:@"nomalhead.png"];
            }
            else{
                self.headImage=[UIImage imageNamed:@"nomalhead.png"];
                [userDefaults removeObjectForKey:@"headimage"];
            }
        }
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
