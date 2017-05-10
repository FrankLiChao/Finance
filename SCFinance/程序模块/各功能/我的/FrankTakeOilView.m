//
//  FrankTakeOilView.m
//  SCFinance
//
//  Created by lichao on 16/7/28.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankTakeOilView.h"
#import "FrankAutoLayout.h"
#import "FrankCarNumberView.h"
#import "FrankSelectTime.h"
#import "FrankTools.h"

@interface FrankTakeOilView ()<UITextFieldDelegate,UIActionSheetDelegate>{
    UIView *oilMessageView;
    UIView *writeOilView;
    UIScrollView *myScrollView;
    UITextField *numberField;   //提油数量
    UITextField *carNumField;   //提油车牌号
    UITextField *nameField;     //姓名
    UITextField *idCardField;   //身份证
    UITextField *phoneField;    //手机号
    UILabel     *oilNumber;     //油号
}

@end

@implementation FrankTakeOilView
@synthesize carNum,oilData;

- (void)viewDidLoad {
    [super viewDidLoad];
    lhNavigationBar * nBar = [[lhNavigationBar alloc]initWithVC:self title:@"我要提油" isBackBtn:YES rightBtn:nil];
    [self.view addSubview:nBar];
    [self initFrameView];
}

-(void)initFrameView
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceMaxWidth, DeviceMaxHeight-64-45*widthRate)];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.backgroundColor = lhviewColor;
    [self.view addSubview:myScrollView];
    
    [self initOilMessageView];
    [self initWriteOilView];
    
    UIButton *takeOilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeOilBtn.frame = CGRectMake(0, DeviceMaxHeight-45*widthRate, DeviceMaxWidth, 45*widthRate);
    [takeOilBtn setTitle:@"提交" forState:UIControlStateNormal];
    takeOilBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [takeOilBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    takeOilBtn.backgroundColor = lhmainColor;
    [takeOilBtn addTarget:self action:@selector(clickConfirmEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeOilBtn];
}

-(void)clickConfirmEvent
{
    if ([numberField.text isEqualToString:@""] || numberField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入提油吨数~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([carNumField.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请输入车牌号~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if (carNumField.text.length !=5) {
        [lhUtilObject showAlertWithMessage:@"车牌号有误~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    
    if ([nameField.text isEqualToString:@""] || nameField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入提油人姓名~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([idCardField.text isEqualToString:@""] || idCardField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入提油人身份证~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if (idCardField.text.length != 15 || idCardField.text.length != 18) {
        [lhUtilObject showAlertWithMessage:@"身份证有误~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([phoneField.text isEqualToString:@""] || phoneField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入提油人手机号~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([oilData.text isEqualToString:@"预计提油日期"] || oilData.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请选择提油日期~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
    if (![FrankTools isValidateMobile:phoneField.text]) {
        [lhUtilObject showAlertWithMessage:@"手机号码有误~" withSuperView:self.view withHeih:DeviceMaxHeight/2];
        return;
    }
//    NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
//                          @"orderId":@"",
//                          @"type":@"",
//                          @"phone":phoneTextField.text,
//                          @"plate":[NSString stringWithFormat:@"%@%@",_carType.text,carTextField.text],
//                          @"idCard":jzTextField.text,
//                          @"deliverTimeStr":_dataField.text
//                          };
//    FLLog(@"dic = %@",dic);
//    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_transportOil") parameters:dic method:@"POST" success:^(id responseObject) {
//        if (_type == 1) {
//            [_directDelegate reloadPage];
//        }else{
//            [_groupDelegate reloadPage];
//        }
//        [UIView animateWithDuration:0.4 animations:^{
//            CGRect rect = popView.frame;
//            rect.origin.y = DeviceMaxHeight;
//            rect.size.height = 0;
//            popView.frame = rect;
//        }completion:^(BOOL finished) {
//            [bgView removeFromSuperview];
//            [popView removeFromSuperview];
//            [ws removeFromSuperview];
//        }];
    
//    } fail:nil];
}

-(void)initOilMessageView
{
    NSArray *oilNumberArray = @[@"国四93#",@"国四95#",@"国四97#"];
    NSArray *numberArray = @[@"16.7",@"21.7",@"28.9"];
    
    UILabel *oilMessageLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, DeviceMaxWidth-20*widthRate, 30*widthRate)];
    oilMessageLab.font = [UIFont systemFontOfSize:13];
    oilMessageLab.text = @"余油信息";
    oilMessageLab.textColor = lhcontentTitleColorStr1;
    [myScrollView addSubview:oilMessageLab];
    
    oilMessageView = [UIView new];
    oilMessageView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:oilMessageView];
    
    oilMessageView.sd_layout
    .leftEqualToView(myScrollView)
    .topSpaceToView(oilMessageLab,0)
    .rightEqualToView(myScrollView)
    .heightIs(40*widthRate+oilNumberArray.count*50*widthRate);
    
    UIImageView *hImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*widthRate, 10*widthRate, 20*widthRate, 20*widthRate)];
    [hImgView setImage:imageWithName(@"hangyoulogo")];
    [oilMessageView addSubview:hImgView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*widthRate+20*widthRate, 10*widthRate, DeviceMaxWidth-55*widthRate, 20*widthRate)];
    nameLabel.text = @"中航油四川公司";
    nameLabel.textColor = lhcontentTitleColorStr;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [oilMessageView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*widthRate-1, DeviceMaxWidth, 1)];
    lineView.backgroundColor = lhviewColor;
    [oilMessageView addSubview:lineView];
    
    CGFloat hight = 40*widthRate;
    for (int i=0; i<oilNumberArray.count; i++) {
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(40*widthRate, hight+i*50*widthRate, 150*widthRate, 50*widthRate)];
        nameLab.text = [NSString stringWithFormat:@"油品：%@",oilNumberArray[i]];
        nameLab.textColor = lhcontentTitleColorStr;
        nameLab.font = [UIFont systemFontOfSize:13];
        [oilMessageView addSubview:nameLab];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth-120*widthRate, hight+i*50*widthRate, 100*widthRate, 50*widthRate)];
        numberLab.text = [NSString stringWithFormat:@"剩余：%@吨",numberArray[i]];
        numberLab.textColor = lhcontentTitleColorStr1;
        numberLab.font = [UIFont systemFontOfSize:13];
        numberLab.textAlignment = NSTextAlignmentRight;
        [oilMessageView addSubview:numberLab];
        
        if (i != 0) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, hight+i*50*widthRate, DeviceMaxWidth-20*widthRate, 0.5)];
            lineV.backgroundColor = tableDefSepLineColor;
            [oilMessageView addSubview:lineV];
        }
    }
}

-(void)initWriteOilView
{
    UILabel *writeOilLab = [UILabel new];
    writeOilLab.font = [UIFont systemFontOfSize:13];
    writeOilLab.text = @"提油信息填写";
    writeOilLab.textColor = lhcontentTitleColorStr1;
    [myScrollView addSubview:writeOilLab];
    
    writeOilLab.sd_layout
    .leftSpaceToView(myScrollView,15*widthRate)
    .rightSpaceToView(myScrollView,15*widthRate)
    .topSpaceToView(oilMessageView,0)
    .heightIs(30*widthRate);
    
    UIView *oilMessage = [UIView new];
    oilMessage.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:oilMessage];
    
    oilMessage.sd_layout
    .leftSpaceToView(myScrollView,0)
    .rightSpaceToView(myScrollView,0)
    .topSpaceToView(writeOilLab,0)
    .heightIs(150*widthRate);
    
    CGFloat heit = 0;
    NSArray * tArray = @[@"油品",@"数量",@"提油车牌"];
    for (int i = 0; i < tArray.count; i++) {
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, heit, 120*widthRate, 50*widthRate)];
        tLabel.font = [UIFont systemFontOfSize:13];
        tLabel.textColor = lhcontentTitleColorStr;
        tLabel.text = [tArray objectAtIndex:i];
        [oilMessage addSubview:tLabel];
        if (i == 0) {
            oilNumber = [[UILabel alloc] initWithFrame:CGRectMake(100, heit+15*widthRate, 60, 20*widthRate)];
            oilNumber.text = @"国四93 #";
            oilNumber.font = [UIFont systemFontOfSize:13];
            oilNumber.textAlignment = NSTextAlignmentRight;
            [oilMessage addSubview:oilNumber];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100+62, heit+21*widthRate, 10*widthRate, 10*widthRate)];
            [imageV setImage:imageWithName(@"xiajiantou2")];
            [oilMessage addSubview:imageV];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, heit+35*widthRate, oilNumber.frame.size.width+15*widthRate, 0.5)];
            line.backgroundColor = tableDefSepLineColor;
            [oilMessage addSubview:line];
            
            UIButton *oilTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oilTypeBtn.frame = CGRectMake(100, heit, 72, 50*widthRate);
            [oilTypeBtn addTarget:self action:@selector(clickSelectOilType) forControlEvents:UIControlEventTouchUpInside];
            [oilMessage addSubview:oilTypeBtn];
        }
        else if(i == 1){
            numberField = [[UITextField alloc]initWithFrame:CGRectMake(100, heit, DeviceMaxWidth-100-15*widthRate, 50*widthRate)];
            numberField.returnKeyType = UIReturnKeyDone;
            numberField.delegate = self;
            numberField.font = [UIFont systemFontOfSize:13];
            numberField.textColor = lhcontentTitleColorStr;
            numberField.placeholder = @"请输入提油数量";
            numberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [oilMessage addSubview:numberField];
            
            numberField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, heit-0.5, DeviceMaxWidth-15*widthRate, 0.5)];
            lineView.backgroundColor = tableDefSepLineColor;
            [oilMessage addSubview:lineView];
        }
        else if (i == 2) {
            carNumField = [[UITextField alloc]initWithFrame:CGRectMake(100, heit, DeviceMaxWidth-100*widthRate-15*widthRate, 50*widthRate)];
            carNumField.returnKeyType = UIReturnKeyDone;
            carNumField.delegate = self;
            carNumField.font = [UIFont systemFontOfSize:13];
            carNumField.textColor = lhcontentTitleColorStr;
            [oilMessage addSubview:carNumField];
            carNumField.placeholder = @"请输入提油车车牌号";
            carNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [carNumField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
            CGRect rect = carNumField.frame;
            rect.origin.x = 160;
            carNumField.frame = rect;
            carNum = [[UILabel alloc] initWithFrame:CGRectMake(100, heit+15*widthRate, 28, 20*widthRate)];
            carNum.text = @"川A";
            carNum.font = [UIFont systemFontOfSize:15];
            carNum.textAlignment = NSTextAlignmentRight;
            [oilMessage addSubview:carNum];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100+30, heit+21*widthRate, 10, 10)];
            [imageV setImage:imageWithName(@"xiajiantou2")];
            [oilMessage addSubview:imageV];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, heit+35*widthRate, carNum.frame.size.width+15*widthRate, 0.5)];
            line.backgroundColor = tableDefSepLineColor;
            [oilMessage addSubview:line];
            
            UIButton *carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            carTypeBtn.frame = CGRectMake(100, heit, 45, 50*widthRate);
            [carTypeBtn addTarget:self action:@selector(clickSelectCarType) forControlEvents:UIControlEventTouchUpInside];
            [oilMessage addSubview:carTypeBtn];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15*widthRate, heit-0.5, DeviceMaxWidth-15*widthRate, 0.5)];
            lineView.backgroundColor = tableDefSepLineColor;
            [oilMessage addSubview:lineView];
        }
        
        heit += 50*widthRate;
    }
    
    UIView *inforView = [UIView new];
    inforView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:inforView];
    
    inforView.sd_layout
    .leftSpaceToView(myScrollView,0)
    .rightSpaceToView(myScrollView,0)
    .topSpaceToView(oilMessage,10*widthRate)
    .heightIs(150*widthRate);
    
    NSArray *nameArray = @[@"姓名",@"身份证",@"手机号"];
    for (int i=0; i<nameArray.count; i++) {
        UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, i*50*widthRate, 120*widthRate, 50*widthRate)];
        tLabel.font = [UIFont systemFontOfSize:13];
        tLabel.textColor = lhcontentTitleColorStr;
        tLabel.text = [nameArray objectAtIndex:i];
        [inforView addSubview:tLabel];
        
        UITextField *inforField = [[UITextField alloc]initWithFrame:CGRectMake(100, i*50*widthRate, DeviceMaxWidth-100-15*widthRate, 50*widthRate)];
        inforField.returnKeyType = UIReturnKeyDone;
        inforField.delegate = self;
        inforField.font = [UIFont systemFontOfSize:13];
        inforField.textColor = lhcontentTitleColorStr;
        inforField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [inforView addSubview:inforField];
        
        if (i != 0) {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15*widthRate, i*50*widthRate-0.5, DeviceMaxWidth-15*widthRate, 0.5)];
            lineV.backgroundColor = tableDefSepLineColor;
            [inforView addSubview:lineV];
        }
        if (i == 0) {
            nameField = inforField;
            inforField.keyboardType = UIKeyboardTypeDefault;
            nameField.placeholder = @"输入提油人真实姓名";
        }else if (i == 1) {
            idCardField = inforField;
            idCardField.placeholder = @"提油人身份证";
        }else if (i == 2) {
            phoneField = inforField;
            phoneField.placeholder = @"提油人手机号";
        }
    }
    
    UIView *dataView = [UIView new];
    dataView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:dataView];
    
    dataView.sd_layout
    .leftSpaceToView(myScrollView,0)
    .rightSpaceToView(myScrollView,0)
    .topSpaceToView(inforView,10*widthRate)
    .heightIs(50*widthRate);
    
    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 100*widthRate, 50*widthRate)];
    dataLab.text = @"提油日期";
    dataLab.font = [UIFont systemFontOfSize:15];
    dataLab.textColor = lhcontentTitleColorStr;
    [dataView addSubview:dataLab];
    
    oilData = [[UILabel alloc] initWithFrame:CGRectMake(100, 15*widthRate, 80, 20*widthRate)];
    oilData.text = @"预计提油日期";
    oilData.font = [UIFont systemFontOfSize:13];
    oilData.textColor = lhcontentTitleColorStr2;
    oilData.textAlignment = NSTextAlignmentRight;
    [dataView addSubview:oilData];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100+90, 21*widthRate, 10*widthRate, 10*widthRate)];
    [imageV setImage:imageWithName(@"xiajiantou2")];
    [dataView addSubview:imageV];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, 35*widthRate, oilNumber.frame.size.width+20*widthRate, 0.5)];
    line.backgroundColor = tableDefSepLineColor;
    [dataView addSubview:line];
    
    UIButton *dataTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dataTypeBtn.frame = CGRectMake(100, 0, 120, 50*widthRate);
    [dataTypeBtn addTarget:self action:@selector(clickTimeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [dataView addSubview:dataTypeBtn];
    
    [myScrollView setupAutoContentSizeWithBottomView:dataView bottomMargin:10*widthRate];
}

-(void)clickSelectOilType
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择油号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"国四93 #",@"国四95 #",@"国四97 #", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FLLog(@"buttonIndex = %ld",buttonIndex);
    if (buttonIndex == 0) {
        oilNumber.text = @"国四93 #";
    }else if (buttonIndex == 1) {
        oilNumber.text = @"国四95 #";
    }else if (buttonIndex == 2) {
        oilNumber.text = @"国四97 #";
    }
}
//选择车牌号
-(void)clickSelectCarType
{
    FrankCarNumberView *carNumber = [[FrankCarNumberView alloc] initWithFrame:self.view.bounds];
    carNumber.delegate = self;
    [self.view addSubview:carNumber];
}

//选择时间
-(void)clickTimeButtonEvent
{
    FrankSelectTime *selectTime = [[FrankSelectTime alloc] initWithFrame:self.view.bounds];
    selectTime.delegate = self;
    [self.view addSubview:selectTime];
}

-(void)initOrderData
{
    NSString *userId = [lhUserModel shareUserModel].userId;
    NSDictionary *dic = @{@"plate":[NSString stringWithFormat:@"%@%@",carNum.text,carNumField.text],
                          @"userId":userId
                          };
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findMotorcadeByPlate") parameters:dic method:@"POST" success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        NSString *myPhone = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"phone"]];
        if (myPhone.length == 11) {
            idCardField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"idCard"]];
            nameField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"driver"]];
            phoneField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"phone"]];
        }
    } fail:^(id error){
        
    }];
}

-(void)clearOrderData
{
    idCardField.text = @"";
    nameField.text = @"";
    phoneField.text = @"";
}

-(void)textFieldChange
{
    if (carNumField.text.length == 5) {
        [self initOrderData];
    }else{
        [self clearOrderData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([@"" isEqualToString:string]){
        return YES;
    }
    if (textField == carNumField) {
        if (carNumField.text.length >=5) {
            return NO;
        }
    }
    if (textField == idCardField) {
        if (idCardField.text.length >= 18) {
            return NO;
        }
    }
    if (textField == phoneField) {
        if (phoneField.text.length >= 11) {
            return NO;
        }
    }
    return YES;
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
