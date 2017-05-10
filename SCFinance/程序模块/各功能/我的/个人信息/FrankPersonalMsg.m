//
//  FrankPersonalMsg.m
//  SCFinance
//
//  Created by lichao on 16/6/6.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankPersonalMsg.h"
#import "FrankAutoLayout.h"
#import "lhUtilObject.h"
#import "FrankTools.h"
#import "lhHubLoading.h"
#import "lhMainRequest.h"
#import "lhMergeNameViewController.h"

#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface FrankPersonalMsg ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIScrollView *myScrollView;
    NSArray *titleArray;
    UITextField *nickLable;         //昵称
    
    //头像上传
    UIImageView *headImageView; //头像
    NSInteger currentType_;//上传头像类型
    UIImage * tempImg;//从相册选择的头像图片
    NSString * headStr;//头像连接
}

@end

@implementation FrankPersonalMsg

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"个人信息" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];
    
    [self initFrameView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFrameView
{
    titleArray = @[@"头像",@"昵称",@"手机号"];
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = lhviewColor;
    [self.view addSubview:myScrollView];
    
    CGFloat hight = 15*widthRate;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 88*widthRate)];
    headView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:headView];
    
    UILabel *headlab = [UILabel new];
    headlab.font = [UIFont systemFontOfSize:14];
    headlab.textColor = lhcontentTitleColorStr;
    headlab.text = titleArray[0];
    [headView addSubview:headlab];
    
    headlab.sd_layout
    .leftSpaceToView(headView,15*widthRate)
    .centerYEqualToView(headView)
    .widthIs(100*widthRate)
    .heightIs(20*widthRate);
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-75*widthRate, 14*widthRate, 60*widthRate, 60*widthRate)];
    headImageView.layer.cornerRadius = 30*widthRate;
    headImageView.layer.allowsEdgeAntialiasing = YES;
    headImageView.layer.masksToBounds = YES;
    [headImageView addGestureRecognizer:tapGesture];
    headImageView.userInteractionEnabled = YES;
    NSString * allStr = [NSString stringWithFormat:@"%@%@",[lhUtilObject shareUtil].webImgUrl,[lhUserModel shareUserModel].photo];
    [lhUtilObject checkImageWithImageView:headImageView withImage:[lhUserModel shareUserModel].photo withImageUrl:allStr withPlaceHolderImage:imageWithName(@"defaultUserHeadImageGray")];
    
    [headView addSubview:headImageView];
    
    UIView *lineHead = [[UIView alloc] initWithFrame:CGRectMake(15*widthRate, 88*widthRate-0.5, DeviceMaxWidth-15*widthRate, 0.5)];
    lineHead.backgroundColor = tableDefSepLineColor;
    [headView addSubview:lineHead];
    
    hight += 88*widthRate;
    
    UIView *nicknameView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 44*widthRate)];
    nicknameView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:nicknameView];
    
    UILabel *nickname = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 100*widthRate, 44*widthRate)];
    nickname.font = [UIFont systemFontOfSize:14];
    nickname.textColor = lhcontentTitleColorStr;
    nickname.text = titleArray[1];
    [nicknameView addSubview:nickname];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-23*widthRate, 18*widthRate, 8*widthRate, 8*widthRate)];
    [arrowView setImage:imageWithName(@"youjiantouImage")];
    [nicknameView addSubview:arrowView];
    
    nickLable = [UITextField new];
    nickLable.userInteractionEnabled = NO;
    nickLable.font = [UIFont systemFontOfSize:14];
    nickLable.textColor = lhcontentTitleColorStr2;
    nickLable.textAlignment = NSTextAlignmentRight;
    nickLable.placeholder = @"添加";
    [nicknameView addSubview:nickLable];
    
    nickLable.sd_layout
    .rightSpaceToView(arrowView,10*widthRate)
    .topEqualToView(nicknameView)
    .widthIs(200*widthRate)
    .heightRatioToView(nicknameView,1);
    
    UIButton * nBtn = [UIButton new];
    [nBtn addTarget:self action:@selector(nBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [nicknameView addSubview:nBtn];
    
    nBtn.sd_layout
    .xIs(0)
    .yIs(0)
    .widthIs(DeviceMaxWidth)
    .heightIs(44*widthRate);
    
    hight += 44*widthRate+15*widthRate;
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 44*widthRate)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:phoneView];
    
    UILabel *phLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 100*widthRate, 44*widthRate)];
    phLab.font = [UIFont systemFontOfSize:14];
    phLab.textColor = lhcontentTitleColorStr;
    phLab.text = titleArray[2];
    [phoneView addSubview:phLab];
    
    NSString *phoneStr = [lhUserModel shareUserModel].phone;
//    [NSString stringWithFormat:@"%@",[[lhUtilObject shareUtil].userInfor objectForKey:@"phone"]];
    UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-200*widthRate, 0, 185*widthRate, 44*widthRate)];
    phoneLable.font = [UIFont systemFontOfSize:14];
    phoneLable.textColor = lhcontentTitleColorStr2;
    phoneLable.textAlignment = NSTextAlignmentRight;
    phoneLable.text = [FrankTools replacePhoneNumber:phoneStr];
    
    [phoneView addSubview:phoneLable];
    
    hight += 44*widthRate;
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth, hight);
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-60*widthRate)/2, DeviceMaxHeight-25*widthRate, 60*widthRate, 18*widthRate)];
    logo.image = imageWithName(@"refreshLogo");
    [self.view addSubview:logo];
}

#pragma mark - 修改昵称
- (void)nBtnEvent
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeNameEvent:) name:@"mergeNameEvent" object:nil];
    
    lhMergeNameViewController * mnVC = [[lhMergeNameViewController alloc]init];
    [self.navigationController pushViewController:mnVC animated:YES];
}

//- (void)mergeNameEvent:(NSNotification *)noti
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:noti.name object:nil];
//    nickLable.text = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"content"]];
//
//    [self submitPersonInfo];
//}
//
//#pragma mark - 提交修改
//- (void)submitPersonInfo
//{
//    FLLog(@"提交修改信息");
//}

#pragma mark - 点击头像
-(void)tapGestureEvent
{
    FLLog(@"点击头像");
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看大图",@"拍照上传",@"相册选取", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 2){//头像点击
        if (buttonIndex == 0) {
            [self performSelector:@selector(selectActionBigImage) withObject:nil afterDelay:0.45];
        }
        else{
            [self takePhotoAndVidoeWithIndex:buttonIndex];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    ////NSLog(@"开始上传头像 %ld",(long)buttonIndex);
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }];
        }
        else{
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//                [lhHubLoading addActivityView:self.view];
                NSArray *array = @[tempImg];
                NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
                                      @"image":tempImg};
                [lhMainRequest uploadPhotos:PATH(@"clientInfo_uploadHeadurl") parameters:dic imageD:array success:^(id responseObject) {
                    [lhUserModel shareUserModel].photo = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"photo"]];

                }];
                headImageView.image = tempImg;
            }];
        }
    }
}

#pragma mark - 上传头像
- (void)takePhotoAndVidoeWithIndex:(NSInteger)index
{
    currentType_ = index;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    UIImagePickerController * mpic = [[UIImagePickerController alloc]init];
    
    switch (index) {
        case 1:{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备没有相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            mpic.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
            break;
        case 2:{
            mpic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
            break;
            
        default:
            break;
    }
    if (index < 3) {
        mpic.delegate = self;
        mpic.allowsEditing = YES;//是否允许编辑照片
        mpic.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];//只可看见相册中的照片
        [self presentViewController:mpic animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
    }
    
}


-(void)selectActionBigImage
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.image = headImageView.image; //图片
    photo.srcImageView = headImageView;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info //选取成功
{
    UIAlertView * alse = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定上传该图片作为头像？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alse.tag = 2;
    [alse show];
    
    UIImage * img;
    if (currentType_ == 2) {
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    if (currentType_ == 1) {
        img = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:),@"finish");//把照片存储到相册中
    }
    
    tempImg = img;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker//选取图片失败或取消
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

//固定的视频存储完成之后调用的方法
- (void)video: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    ////NSLog(@"视频存储完成");
}

//固定的图片存储完成之后调用的方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    ////NSLog(@"图片存储完成");
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    nickLable.text = [lhUserModel shareUserModel].name;
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
