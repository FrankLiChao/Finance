//
//  FrankTgDetailsView.m
//  SCFinance
//
//  Created by lichao on 16/6/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankTgDetailsView.h"
#import "FrankTools.h"
#import "lhUtilObject.h"
#import "lhMainRequest.h"
#import "lhHubLoading.h"
#import "MJRefresh.h"
#import "FrankPopView.h"
#import "FrankSelectFaPiaoView.h"
#import "lhSelectCarIdViewController.h"
#import "selectCarIdAndFaPiaoTitleDelegate.h"
#import "FrankGroupView.h"
#import "lhAlertView.h"
#import "FrankAutoLayout.h"

@interface FrankTgDetailsView ()<UITextFieldDelegate,selectCarIdAndFaPiaoTitleDelegate,firmBtnClickProtocol>
{
    UIScrollView *myScrollView;
    UITextField *oilField;      //购油吨数
    UILabel *faPiaoLable;       //发票抬头
    NSInteger currentPromotion; //当前的价格
    NSInteger minQuantity; //最小吨数
    UILabel *djLable; //订金
    CGFloat payDeposit; //订金比例
    NSDictionary *invoiceTitleDic;  //发票信息
}

@end

@implementation UIScrollView (UITouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end

@implementation FrankTgDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nb = [[lhNavigationBar alloc]initWithVC:self title:@"报名详情" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nb];
    minQuantity = [[_tgDataDic objectForKey:@"minQuantity"] integerValue];
    payDeposit = [[_tgDataDic objectForKey:@"payDeposit"] floatValue];
    [self initData:minQuantity];
    [self initFrameView];
    invoiceTitleDic = [_tgDataDic objectForKey:@"invoiceTitle"];
}

-(void)initData:(NSInteger)minQuant
{
    NSArray *dataA = [_tgDataDic objectForKey:@"dataPrivateList"];
    NSInteger nowPrice = 0;
    for (int i=0; i<dataA.count; i++) {
        NSDictionary *dic = dataA[i];
        NSInteger amountStart = [[dic objectForKey:@"amountStart"] integerValue];
        NSInteger amountEnd = [[dic objectForKey:@"amountEnd"] integerValue];
        NSInteger currentP = [[dic objectForKey:@"currentPromotion"] integerValue];
        if (minQuant < amountStart) {
            nowPrice = [[_tgDataDic objectForKey:@"currentPromotion"] integerValue];
        }else if (minQuant >= amountStart && minQuant < amountEnd) {
            nowPrice = currentP;
            break;
        }else if (minQuant >= amountEnd) {
            nowPrice = [[dataA[dataA.count-1] objectForKey:@"currentPromotion"] integerValue];
        }
    }
    currentPromotion = nowPrice;
//    FLLog(@"currentPromotion = %ld,%ld",currentPromotion,minQuant);
}

-(void)requestTuanGouData
{
    NSString *userId =  [NSString stringWithFormat:@"%@",[lhUserModel shareUserModel].userId];
    NSString *invoiceId = [NSString stringWithFormat:@"%@",[invoiceTitleDic objectForKey:@"id"]];
    NSString *productGroupId = [NSString stringWithFormat:@"%@",[_tgDataDic objectForKey:@"id"]];
    NSDictionary *dic = @{@"productGroupId":productGroupId,
                          @"purchaseNumber":oilField.text,
                          @"invoiceId":invoiceId,
                          @"userId":userId};
    
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"purchase_genGroupPurchase") parameters:dic method:@"POST" success:^(id responseObject)
     {
         FLLog(@"%@",responseObject);
//         [UIView animateWithDuration:0.25 animations:^{
             [lhUtilObject showAlertWithMessage:@"报名成功~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
             [self performSelector:@selector(finishEvent) withObject:nil afterDelay:1.5];
//         }];
     }fail:nil];
}

-(void)finishEvent
{
    FrankGroupView *groupV = [FrankGroupView new];
    groupV.type = 5;
    [self.navigationController pushViewController:groupV animated:YES];
}

-(void)initFrameView
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64-45*widthRate)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = lhviewColor;
    [self.view addSubview:myScrollView];
    
    CGFloat hight = 0;
    
    UILabel *tglcLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 100*widthRate, 30*widthRate)];
    tglcLab.text = @"团购流程";
    tglcLab.font = [UIFont systemFontOfSize:13];
    tglcLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:tglcLab];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-26*widthRate, 7*widthRate, 16*widthRate, 16*widthRate)];
    imageV.layer.cornerRadius = 8*widthRate;
    imageV.layer.masksToBounds = YES;
    [imageV setImage:imageWithName(@"questionpicture")];
    [myScrollView addSubview:imageV];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(DeviceMaxWidth-40*widthRate, 0, 40*widthRate, 30*widthRate);
    [imageBtn addTarget:self action:@selector(clickImageEvent) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:imageBtn];
    
    hight += 30*widthRate;
    
    UIView *pcView =[[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 90*widthRate)];
    pcView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:pcView];
    
    NSInteger orderStatus = [[_tgDataDic objectForKey:@"process"] integerValue];
    if (orderStatus>4) {
        orderStatus = 4;
    }else if (orderStatus<0){
        orderStatus = 0;
    }
    NSArray *picA = @[@"tuangouweibaoming",@"baomingpicture",@"suodingjiagepicture",@"zhifuweikuanpicture",@"zizhutihuopicture"];
    UIImageView *picImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 10*widthRate, DeviceMaxWidth-30*widthRate, 46*widthRate)]
    ;
    [picImage setImage:imageWithName(picA[orderStatus])];
    [pcView addSubview:picImage];
    
    NSArray *picName = @[@"报名",@"支付定金",@"支付尾款",@"自主提货"];
    CGFloat nameWith = (DeviceMaxWidth-30*widthRate)/picName.count;
    for (int i=0; i<picName.count; i++) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate+i*nameWith, 60*widthRate, nameWith, 20*widthRate)];
        nameLable.text = picName[i];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:13];
        nameLable.textColor = lhcontentTitleColorStr2;
        [pcView addSubview:nameLable];
        if (i < orderStatus && orderStatus != 0) {
            nameLable.textColor = lhmainColor;
        }
    }
    
    hight += 90*widthRate;
    
    UILabel *deteilsLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, hight, 100*widthRate, 30*widthRate)];
    deteilsLab.text = @"详细信息";
    deteilsLab.font = [UIFont systemFontOfSize:13];
    deteilsLab.textColor = lhcontentTitleColorStr2;
    [myScrollView addSubview:deteilsLab];
    
    hight += 30*widthRate;
    
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 100*widthRate)];
    detailView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:detailView];
    
    UILabel *oilDetail = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40*widthRate)];
    oilDetail.text = [NSString stringWithFormat:@"%@ %@",[_tgDataDic objectForKey:@"name"],[_tgDataDic objectForKey:@"oilName"]];
    oilDetail.font = [UIFont systemFontOfSize:15];
    oilDetail.textColor = lhcontentTitleColorStr;
    [detailView addSubview:oilDetail];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 40*widthRate, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [detailView addSubview:lineV];
    
    UILabel *buyNumber = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 48*widthRate, 100*widthRate, 20*widthRate)];
    buyNumber.text = @"购买数量";
    buyNumber.font = [UIFont systemFontOfSize:15];
    buyNumber.textColor = lhcontentTitleColorStr;
    [detailView addSubview:buyNumber];
    
    minQuantity = [[_tgDataDic objectForKey:@"minQuantity"] integerValue];
    
    UILabel *buyDetails = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 72*widthRate, 200, 20*widthRate)];
    buyDetails.text = [NSString stringWithFormat:@"本团购最少订货%ld吨",(long)minQuantity];
    buyDetails.font = [UIFont systemFontOfSize:13];
    buyDetails.textColor = lhcontentTitleColorStr2;
    [detailView addSubview:buyDetails];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(DeviceMaxWidth-40*widthRate, 57*widthRate, 30*widthRate, 26*widthRate);
    [addButton setImage:imageWithName(@"plusimage") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(clickAddButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:addButton];
    
    oilField = [[UITextField alloc] initWithFrame:CGRectMake(DeviceMaxWidth-90*widthRate, 50*widthRate, 50*widthRate, 39*widthRate)];
    oilField.text = [NSString stringWithFormat:@"%ld",(long)minQuantity];
    oilField.delegate = self;
    oilField.textColor = lhcontentTitleColorStr;
    oilField.font = [UIFont systemFontOfSize:15];
    oilField.keyboardType = UIKeyboardTypePhonePad;
    oilField.textAlignment = NSTextAlignmentCenter;
    [detailView addSubview:oilField];
    
    UIButton *jianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jianButton.frame = CGRectMake(DeviceMaxWidth-120*widthRate, 57*widthRate, 30*widthRate, 26*widthRate);
    [jianButton setImage:imageWithName(@"jianImage") forState:UIControlStateNormal];
    [jianButton addTarget:self action:@selector(clickJianButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:jianButton];
    
    hight += 110*widthRate;
    
    UIView *faPiaoView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate)];
    faPiaoView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:faPiaoView];
    
    UILabel *fapiao = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 80*widthRate, 50*widthRate)];
    fapiao.text = @"公司名称";
    fapiao.font = [UIFont systemFontOfSize:15];
    fapiao.textColor = lhcontentTitleColorStr;
    [faPiaoView addSubview:fapiao];
    
    UIImageView *jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-18*widthRate, 21*widthRate, 8*widthRate, 8*widthRate)];
    [jiantou setImage:imageWithName(@"youjiantouImage")];
    [faPiaoView addSubview:jiantou];
    
    NSDictionary *fDic = [_tgDataDic objectForKey:@"invoiceTitle"];
    faPiaoLable = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-285*widthRate, 0, 260*widthRate, 50*widthRate)];
    faPiaoLable.textColor = lhcontentTitleColorStr;
    faPiaoLable.font = [UIFont systemFontOfSize:15];
    faPiaoLable.textAlignment = NSTextAlignmentRight;
    [faPiaoView addSubview:faPiaoLable];
    if (fDic.count) {
        faPiaoLable.text = [NSString stringWithFormat:@"%@",[fDic objectForKey:@"name"]];
    }else{
        faPiaoLable.text = @"";
    }
    
    UIButton *fapiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fapiaoBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 50*widthRate);
    [fapiaoBtn addTarget:self action:@selector(clickFaPiaoEvent) forControlEvents:UIControlEventTouchUpInside];
    [faPiaoView addSubview:fapiaoBtn];
    
    hight += 60*widthRate;
    
    /*
    UIView *carView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 50*widthRate)];
    carView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:carView];
    
    UILabel *carNumberTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 100*widthRate, 50*widthRate)];
    carNumberTitle.text = @"提油车牌号";
    carNumberTitle.font = [UIFont systemFontOfSize:15];
    carNumberTitle.textColor = lhcontentTitleColorStr;
    [carView addSubview:carNumberTitle];
    
    UIImageView *jiantou1 = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-18*widthRate, 21*widthRate, 8*widthRate, 8*widthRate)];
    [jiantou1 setImage:imageWithName(@"youjiantouImage")];
    [carView addSubview:jiantou1];
    
    NSDictionary *carDic = [_dataDic objectForKey:@"carNumber"];
    carNumber = [[UILabel alloc] initWithFrame:CGRectMake(120*widthRate, 0, DeviceMaxWidth-143*widthRate, 50*widthRate)];
    carNumber.textColor = lhcontentTitleColorStr;
    carNumber.font = [UIFont systemFontOfSize:15];
    carNumber.textAlignment = NSTextAlignmentRight;
    [carView addSubview:carNumber];
    if (carDic.count) {
        carNumber.text = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"name"]];
    }else{
        carNumber.text = @"";
    }
    
    UIButton *carNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    carNumberBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 50*widthRate);
    [carNumberBtn addTarget:self action:@selector(clickCarNumberEvent) forControlEvents:UIControlEventTouchUpInside];
    [carView addSubview:carNumberBtn];
    
    hight += 50*widthRate;
    */
    
    UIView * zftView = [UIView new];
    zftView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:zftView];
    
    zftView.sd_layout
    .widthIs(DeviceMaxWidth)
    .heightIs(100*widthRate)
    .xIs(0)
    .yIs(hight);
    
    UILabel *zftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 50*widthRate)];
    zftLabel.text = @"选择付款方式";
    zftLabel.font = [UIFont systemFontOfSize:15];
    zftLabel.textColor = lhcontentTitleColorStr;
    [zftView addSubview:zftLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [zftView addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50*widthRate-0.5, DeviceMaxWidth, 0.5)];
    lineView1.backgroundColor = tableDefSepLineColor;
    [zftView addSubview:lineView1];
    
    UILabel *zfLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 50*widthRate, DeviceMaxWidth-20*widthRate, 50*widthRate)];
    zfLabel1.text = @"1  预付定金";
    zfLabel1.font = [UIFont systemFontOfSize:15];
    zfLabel1.textColor = lhcontentTitleColorStr;
    [zftView addSubview:zfLabel1];
    
    //预付定金展开说明
    UIView * zfcontentView1 = [UIView new];
    zfcontentView1.backgroundColor = lhviewColor;
    [myScrollView addSubview:zfcontentView1];
    
    zfcontentView1.sd_layout
    .widthIs(DeviceMaxWidth)
    .heightIs(100*widthRate)
    .xIs(0)
    .topSpaceToView(zftView,0);
    
    UIView * zftView2 = [UIView new];
    zftView2.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:zftView2];

    zftView2.sd_layout
    .widthIs(DeviceMaxWidth)
    .heightIs(50*widthRate)
    .xIs(0)
    .topSpaceToView(zfcontentView1,0);
    
    //支付全款展开说明
    UIView * zfcontentView2 = [UIView new];
    zfcontentView2.backgroundColor = lhviewColor;
    [myScrollView addSubview:zfcontentView2];
    
    zfcontentView2.sd_layout
    .widthIs(DeviceMaxWidth)
    .heightIs(100*widthRate)
    .xIs(0)
    .topSpaceToView(zftView2,0);

    [myScrollView setupAutoContentSizeWithBottomView:zfcontentView2 bottomMargin:10*widthRate];
    
    UIView *bmView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight-45*widthRate, DeviceMaxWidth, 45*widthRate)];
    bmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bmView];
    
    CGFloat mString = [[_tgDataDic objectForKey:@"payDeposit"] floatValue];
    NSString *str = [NSString stringWithFormat:@"订金：%0.2f元",mString*currentPromotion*minQuantity];
    djLable = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 150, 45*widthRate)];
    djLable.textAlignment = NSTextAlignmentCenter;
    djLable.font = [UIFont systemFontOfSize:15];
    djLable.textColor = lhcontentTitleColorStr;
    djLable.adjustsFontSizeToFitWidth = YES;
    djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(3, str.length-3)];
    [bmView addSubview:djLable];
    
    UIButton *bmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bmButton.frame = CGRectMake(160, 0, DeviceMaxWidth-160, 45*widthRate);
    bmButton.backgroundColor = lhmainColor;
    [bmButton setTitle:@"确定报名" forState:UIControlStateNormal];
    [bmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bmButton addTarget:self action:@selector(clickConfirmEvent) forControlEvents:UIControlEventTouchUpInside];
    [bmView addSubview:bmButton];
}

-(void)clickFaPiaoEvent
{
    FrankSelectFaPiaoView *fapView = [FrankSelectFaPiaoView new];
    fapView.delegate = self;
    [self.navigationController pushViewController:fapView animated:YES];
}

//-(void)clickCarNumberEvent
//{
//    lhSelectCarIdViewController *carView = [lhSelectCarIdViewController new];
//    carView.delegate = self;
//    [self.navigationController pushViewController:carView animated:YES];
//}

-(void)clickImageEvent
{
    FrankPopView *popView = [[FrankPopView alloc] initWithFrame:self.view.bounds withType:0];
    popView.nameArray = @[@"报名",@"支付定金",@"支付尾款",@"自主提货"];
    [self.view addSubview:popView];
}

- (void)setCarIdDic:(NSDictionary *)carIdDic withType:(NSInteger)type
{
    if (type == 6) {
        faPiaoLable.text = [NSString stringWithFormat:@"%@",[carIdDic objectForKey:@"name"]];
        invoiceTitleDic = carIdDic;
    }
}

-(void)clickConfirmEvent
{
    if ([oilField.text integerValue] < minQuantity) {
        [lhUtilObject showAlertWithMessage:[NSString stringWithFormat:@"本团购最少订货%ld吨~",(long)minQuantity] withSuperView:self.view withHeih:DeviceMaxHeight/2];
        oilField.text = [NSString stringWithFormat:@"%ld",(long)minQuantity];
        return;
    }
    if ([oilField.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请输入购买数量~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([faPiaoLable.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请选择一个公司名称~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    NSString * yhStr = [NSString stringWithFormat:@"油号：%@",[_tgDataDic objectForKey:@"oilName"]];
    NSMutableAttributedString * att1 = [[NSMutableAttributedString alloc]initWithString:yhStr];
    [att1 addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(3, yhStr.length-3)];
    
    NSString * priceStr = [NSString stringWithFormat:@"自提价：%ld元/吨",(long)currentPromotion];
    NSMutableAttributedString * att2 = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [att2 addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(4, priceStr.length-4)];
    
    NSString * countStr = [NSString stringWithFormat:@"吨数：%@吨",oilField.text];
    NSMutableAttributedString * att3 = [[NSMutableAttributedString alloc]initWithString:countStr];
    [att3 addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(3, countStr.length-3)];
    
    NSString * addStr = [NSString stringWithFormat:@"油库：%@",[_tgDataDic objectForKey:@"name"]];
    NSMutableAttributedString * att4 = [[NSMutableAttributedString alloc]initWithString:addStr];
    [att4 addAttribute:NSForegroundColorAttributeName value:lhredColorStr range:NSMakeRange(3, addStr.length-3)];
    
    NSString * noticeStr = [NSString stringWithFormat:@"%@",[_tgDataDic objectForKey:@"toastNote"]];
    
    lhAlertView * alertView = [[lhAlertView alloc]initWithFrame:self.view.bounds noticeStr:@"您好，您要购买的是：" attributedS1:att1 attributedS2:att2 attributedS3:att3 attributedS4:att4 noticeStr2:noticeStr];
    alertView.delegate = self;
    [self.view addSubview:alertView];
}

#pragma mark - alterViewDelegate
- (void)firmBtnClick:(lhAlertView *)alertView
{
    [self requestTuanGouData];
}

-(void)clickAddButtonEvent
{
    FLLog(@"点击加号按钮");
    NSInteger oilNumber = [oilField.text integerValue];
    oilField.text = [NSString stringWithFormat:@"%ld",(long)oilNumber+1];
    [self initData:[oilField.text integerValue]];
    NSString *str = [NSString stringWithFormat:@"订金：%0.2f元",payDeposit*currentPromotion*[oilField.text integerValue]];
    djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(3, str.length-3)];
}

-(void)clickJianButtonEvent
{
    FLLog(@"点击减号按钮");
    NSInteger oilNumber = [oilField.text integerValue];
    if (oilNumber == 1) {
        return;
    }
    if (oilNumber == minQuantity) {
        [lhUtilObject showAlertWithMessage:[NSString stringWithFormat:@"本团购最少订货%ld吨~",(long)minQuantity] withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    oilField.text = [NSString stringWithFormat:@"%ld",(long)oilNumber-1];
    [self initData:[oilField.text integerValue]];
    NSString *str = [NSString stringWithFormat:@"订金：%0.2f元",payDeposit*currentPromotion*[oilField.text integerValue]];
    djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(3, str.length-3)];
}

#pragma mark - touch事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([oilField.text integerValue]<minQuantity) {
        [lhUtilObject showAlertWithMessage:[NSString stringWithFormat:@"本团购最少订货%ld吨~",(long)minQuantity] withSuperView:self.view withHeih:DeviceMaxHeight/2];
        oilField.text = [NSString stringWithFormat:@"%ld",(long)minQuantity];
    }
    [self initData:[oilField.text integerValue]];
    NSString *str = [NSString stringWithFormat:@"订金：%0.2f元",payDeposit*currentPromotion*[oilField.text integerValue]];
    djLable.attributedText = [FrankTools setFontColor:lhredColorStr WithString:str WithRange:NSMakeRange(3, str.length-3)];
    [UIView animateWithDuration:0.4 animations:^{
        [oilField resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
