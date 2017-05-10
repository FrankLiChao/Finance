//
//  FrankOilView.m
//  SCFinance
//
//  Created by lichao on 16/7/7.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankOilView.h"
#import "FrankTools.h"
#import "FrankAutoLayout.h"
#import "FrankCarNumberView.h"
#import "FrankSelectTime.h"
#import "FrankTools.h"

@interface FrankOilView()<UITextFieldDelegate>

@end

@implementation FrankOilView
{
    UITextField *jzTextField;       //驾照编号
    UITextField *carTextField;      //车牌号
    UITextField *tempTextField;
    UITextField *nameTextField;     //姓名
    UITextField *phoneTextField;    //手机号码
    
    UILabel *titleLab; //油号+名字
    UILabel *currentP; //当前价格
    UILabel *priceL;   //原价
    UILabel *purchaseL; //吨数
    UILabel *xiaoji;    //小计
    UILabel *savemoney; //已省
    UILabel * nLabel; //提示
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        bgView.showsVerticalScrollIndicator = NO;
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:bgView];
        
        CGFloat hight = 0;
        
        UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, DeviceMaxHeight-485)];
        popView.backgroundColor = lhviewColor;
        [bgView addSubview:popView];
        
        UIView *oilDetail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 120)];
        oilDetail.backgroundColor = [UIColor whiteColor];
        [popView addSubview:oilDetail];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(DeviceMaxWidth-45*widthRate, 5*widthRate, 35*widthRate, 35*widthRate);
        [cancelButton setImage:imageWithName(@"close") forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clickCloseEvent:) forControlEvents:UIControlEventTouchUpInside];
        [oilDetail addSubview:cancelButton];
        
        [self initPriceView:oilDetail];
        
        hight += 130;
        
        UIView *carView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 100)];
        carView.backgroundColor = [UIColor whiteColor];
        [popView addSubview:carView];
        
        CGFloat heit = 0;
        NSArray * tArray = @[@"车牌号",@"驾照"];
        for (int i = 0; i < 2; i++) {
            UILabel * tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, heit, 120*widthRate, 50)];
            tLabel.font = [UIFont systemFontOfSize:15];
            tLabel.textColor = lhcontentTitleColorStr;
            tLabel.text = [tArray objectAtIndex:i];
            [carView addSubview:tLabel];
            
            UITextField * cTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, heit, DeviceMaxWidth-100-15, 50)];
            cTextField.returnKeyType = UIReturnKeyDone;
            cTextField.delegate = self;
            cTextField.font = [UIFont systemFontOfSize:13];
            cTextField.textColor = lhcontentTitleColorStr;
            [carView addSubview:cTextField];
            
            if (i == 0) {
                cTextField.placeholder = @"请输入提油车车牌号";
                carTextField = cTextField;
                carTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                [carTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
                CGRect rect = carTextField.frame;
                rect.origin.x = 160;
                carTextField.frame = rect;
                _carType = [[UILabel alloc] initWithFrame:CGRectMake(100, heit+15, 28, 20)];
                _carType.text = @"川A";
                _carType.font = [UIFont systemFontOfSize:15];
                _carType.textAlignment = NSTextAlignmentRight;
                [carView addSubview:_carType];
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100+30, heit+21, 10, 10)];
                [imageV setImage:imageWithName(@"xiajiantou2")];
                [carView addSubview:imageV];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(100, heit+35, _carType.frame.size.width+15*widthRate, 0.5)];
                line.backgroundColor = tableDefSepLineColor;
                [carView addSubview:line];
                
                UIButton *carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                carTypeBtn.frame = CGRectMake(100, heit, 30, 50);
                [carTypeBtn addTarget:self action:@selector(clickSelectCarType) forControlEvents:UIControlEventTouchUpInside];
                [carView addSubview:carTypeBtn];
                
            }
            else if(i == 1){
                cTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
                cTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cTextField.placeholder = @"驾照或行驶证编号";
                jzTextField = cTextField;
                
                UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(6*widthRate, heit-0.5, DeviceMaxWidth-6*widthRate, 0.5)];
                lineView.backgroundColor = tableDefSepLineColor;
                [carView addSubview:lineView];
            }
            
            heit += 50;
        }
        
        hight += 110;
        
        UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 150)];
        personView.backgroundColor = [UIColor whiteColor];
        [popView addSubview:personView];
        
        NSArray *personA = @[@"时间",@"姓名",@"手机号"];
        NSArray *placeA = @[@"选择您预计提油时间",@"提油人真实姓名",@"联系提油人手机"];
        CGFloat phight = 0;
        for (int i=0;i<personA.count;i++) {
            UILabel * pLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, phight, 120*widthRate, 50)];
            pLabel.font = [UIFont systemFontOfSize:15];
            pLabel.textColor = lhcontentTitleColorStr;
            pLabel.text = [personA objectAtIndex:i];
            [personView addSubview:pLabel];
            
            UITextField * personField = [[UITextField alloc]initWithFrame:CGRectMake(100, phight, DeviceMaxWidth-115, 50)];
            personField.returnKeyType = UIReturnKeyDone;
            personField.font = [UIFont systemFontOfSize:13];
            personField.placeholder = placeA[i];
            personField.delegate = self;
            personField.tag = 100+i;
            personField.textColor = lhcontentTitleColorStr;
            [personView addSubview:personField];
            if (i == 0) {
                UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                timeButton.frame = CGRectMake(0, 0, DeviceMaxWidth, 50);
                [timeButton addTarget:self action:@selector(clickTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                [personField addSubview:timeButton];
            }
            
            if (i == 2) {
                personField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            
            
            if (i == 1 || i == 2) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, phight-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
                line.backgroundColor = tableDefSepLineColor;
                [personView addSubview:line];
                
                if (i == 1) {
                    nameTextField = personField;
                }else if (i == 2){
                    phoneTextField = personField;
                }
            }
            
            phight += 50;
        }
        if (iPhone4) {
            hight += 150+5;
        }else{
            hight += 150+10;
        }
        
        nLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*widthRate, hight, DeviceMaxWidth-30*widthRate, 30)];
        nLabel.numberOfLines = 2;
        nLabel.textColor = lhmainColor;
        nLabel.font = [UIFont systemFontOfSize:12];
        nLabel.adjustsFontSizeToFitWidth = YES;
        [popView addSubview:nLabel];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (iPhone4) {
            confirmButton.frame = CGRectMake(0, 480-45, DeviceMaxWidth, 45);
        }else{
            confirmButton.frame = CGRectMake(0, 485-45, DeviceMaxWidth, 45);
        }
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.backgroundColor = lhmainColor;
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmButton addTarget:self action:@selector(clickConfirmEvent:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:confirmButton];
        
        bgView.contentSize = CGSizeMake(DeviceMaxWidth, DeviceMaxHeight);
        
        CGRect rect1 = popView.frame;
        rect1.origin.y = DeviceMaxHeight;
        popView.frame = rect1;
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect = popView.frame;
            if (iPhone6 || iPhone6plus || iPhone5) {
                rect.origin.y = DeviceMaxHeight-485;
                rect.size.height = 485;
            }else{
                rect.origin.y = DeviceMaxHeight-480;
                rect.size.height = 480;
            }
            
            popView.frame = rect;
            
        }];
    }
    return self;
}

-(void)initPriceView:(UIView *)oilDetail
{
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 30, DeviceMaxWidth-20*widthRate, 20)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = lhcontentTitleColorStr;
//    titleLab.text = [NSString stringWithFormat:@"国四汽油93#"];
    [oilDetail addSubview:titleLab];
    
    currentP = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 55, 80*widthRate, 20)];
    currentP.font = [UIFont systemFontOfSize:15];
    currentP.textColor = lhcontentTitleColorStr;
//    currentP.text = [NSString stringWithFormat:@"5730元/吨"];
    [oilDetail addSubview:currentP];
    
    CGRect rect = currentP.frame;
    rect.size.width = [FrankTools sizeForString:currentP.text withSizeOfFont:[UIFont systemFontOfSize:15]];
    currentP.frame = rect;
    
    priceL = [UILabel new];
    priceL.font = [UIFont systemFontOfSize:13];
//    priceL.text = [NSString stringWithFormat:@"5900元"];
    priceL.textColor = lhcontentTitleColorStr2;
    [oilDetail addSubview:priceL];
    
    priceL.sd_layout
    .leftSpaceToView(currentP,6*widthRate)
    .topEqualToView(currentP)
    .heightIs(20);
    
    [priceL setSingleLineAutoResizeWithMaxWidth:100];
    
    UILabel *priceLine = [UILabel new];
    priceLine.backgroundColor = lhcontentTitleColorStr2;
    [oilDetail addSubview:priceLine];
    
    priceLine.sd_layout
    .leftSpaceToView(currentP,4*widthRate)
    .centerYEqualToView(priceL)
    .heightIs(1)
    .widthRatioToView(priceL,1.1);
    
    purchaseL = [UILabel new];
    purchaseL.font = [UIFont systemFontOfSize:13];
//    purchaseL.text = [NSString stringWithFormat:@"x5"];
    purchaseL.textColor = lhcontentTitleColorStr2;
    [oilDetail addSubview:purchaseL];
    
    purchaseL.sd_layout
    .leftSpaceToView(oilDetail,12*widthRate)
    .topSpaceToView(currentP,20)
    .heightIs(15)
    .widthIs(100);
    
    
    xiaoji = [UILabel new];
//    xiaoji.text = [NSString stringWithFormat:@"小计：￥28650"];
    xiaoji.textColor = lhredColorStr;
    xiaoji.font = [UIFont systemFontOfSize:15];
    xiaoji.textAlignment = NSTextAlignmentRight;
    [oilDetail addSubview:xiaoji];
    
    xiaoji.sd_layout
    .rightSpaceToView(oilDetail,10*widthRate)
    .topEqualToView(currentP)
    .heightIs(20);
    [xiaoji setSingleLineAutoResizeWithMaxWidth:200];
    
    savemoney = [UILabel new];
//    savemoney.text = [NSString stringWithFormat:@"已省：￥850"];
    savemoney.textColor = lhcontentTitleColorStr2;
    savemoney.font = [UIFont systemFontOfSize:13];
    savemoney.textAlignment = NSTextAlignmentRight;
    [oilDetail addSubview:savemoney];
    
    savemoney.sd_layout
    .rightSpaceToView(oilDetail,10*widthRate)
    .topSpaceToView(xiaoji,5)
    .heightIs(20)
    .widthIs(200);
}

-(void)setOilDetailDic:(NSDictionary *)oilDetailDic
{
    NSInteger currentPromotion = [[oilDetailDic objectForKey:@"currentPromotion"] integerValue];
    NSInteger price = [[oilDetailDic objectForKey:@"price"] integerValue];
    NSInteger purchaseNumber = [[oilDetailDic objectForKey:@"purchaseNumber"] integerValue];
    titleLab.text = [NSString stringWithFormat:@"%@ %@",[oilDetailDic objectForKey:@"name"],[oilDetailDic objectForKey:@"oilName"]];
    currentP.text = [NSString stringWithFormat:@"%ld元/吨",(long)(long)currentPromotion];
    CGRect rect = currentP.frame;
    rect.size.width = [FrankTools sizeForString:currentP.text withSizeOfFont:[UIFont systemFontOfSize:15]];
    currentP.frame = rect;
    priceL.text = [NSString stringWithFormat:@"%ld元",(long)price];
    priceL.sd_layout
    .leftSpaceToView(currentP,6*widthRate)
    .topEqualToView(currentP)
    .heightIs(20*widthRate);
    [priceL setSingleLineAutoResizeWithMaxWidth:100];
    purchaseL.text = [NSString stringWithFormat:@"x%ld",(long)purchaseNumber];
    xiaoji.text = [NSString stringWithFormat:@"小计：%ld元",(long)currentPromotion*purchaseNumber];
    savemoney.text = [NSString stringWithFormat:@"已省%ld元",(long)(price-currentPromotion)*purchaseNumber];
    nLabel.text = [NSString stringWithFormat:@"%@",[oilDetailDic objectForKey:@"depotNote"]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)clickTimeButtonEvent:(UIButton *)button_
{
//    _dataField = (UITextField *)button_.superview;
//    [UIView animateWithDuration:0.2 animations:^{
//        [tempTextField resignFirstResponder];
//    }completion:^(BOOL finished) {
//        FrankSelectTime *selectTime = [[FrankSelectTime alloc] initWithFrame:self.bounds];
//        selectTime.delegate = self;
//        [self addSubview:selectTime];
//    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101) {
        nameTextField = textField;
    }
    if (textField.tag == 102) {
        phoneTextField = textField;
    }
    tempTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([@"" isEqualToString:string]){
        return YES;
    }
    if (textField == carTextField) {
        if (carTextField.text.length >=5) {
            return NO;
        }
    }
    if (textField == phoneTextField) {
        if (phoneTextField.text.length >= 11) {
            return NO;
        }
    }
    return YES;
}

-(void)textFieldChange
{
    if (carTextField.text.length == 5) {
        [self initOrderData];
    }else{
        [self clearOrderData];
    }
}

-(void)clickSelectCarType
{
//    FrankCarNumberView *carNumber = [[FrankCarNumberView alloc] initWithFrame:self.bounds];
//    carNumber.delegate = self;
//    [self addSubview:carNumber];
}

-(void)clickCloseEvent:(UIButton *)button_
{
    __block UIView * popView = button_.superview.superview;
    __block UIScrollView * bgView = (UIScrollView *)popView.superview;
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = popView.frame;
        rect.origin.y = DeviceMaxHeight;
        rect.size.height = 0;
        popView.frame = rect;
    }completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [popView removeFromSuperview];
        [ws removeFromSuperview];
    }];
}

-(void)initOrderData
{
    NSString *userId = [lhUserModel shareUserModel].userId;
    NSDictionary *dic = @{@"plate":[NSString stringWithFormat:@"%@%@",_carType.text,carTextField.text],
                          @"userId":userId
                          };
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_findMotorcadeByPlate") parameters:dic method:@"POST" success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        NSString *myPhone = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"phone"]];
        if (myPhone.length == 11) {
            jzTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"idCard"]];
            nameTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"driver"]];
            phoneTextField.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"phone"]];
        }
    } fail:^(id error){
    
    }];
}

-(void)clearOrderData
{
    jzTextField.text = @"";
    nameTextField.text = @"";
    phoneTextField.text = @"";
}

-(void)clickConfirmEvent:(UIButton *)button_
{
    __block UIView * popView = button_.superview;
    __block UIScrollView * bgView = (UIScrollView *)popView.superview;
    
    __weak typeof(self) ws = self;
    if ([carTextField.text isEqualToString:@""]) {
        [lhUtilObject showAlertWithMessage:@"请输入车牌号~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if (carTextField.text.length !=5) {
        [lhUtilObject showAlertWithMessage:@"车牌号有误~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([jzTextField.text isEqualToString:@""] || jzTextField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入驾照编号~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([_dataField.text isEqualToString:@""] || _dataField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请选择提油时间~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([nameTextField.text isEqualToString:@""] || nameTextField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入司机的姓名~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if ([phoneTextField.text isEqualToString:@""] || phoneTextField.text == nil) {
        [lhUtilObject showAlertWithMessage:@"请输入提油人的手机号~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    if (![FrankTools isValidateMobile:phoneTextField.text]) {
        [lhUtilObject showAlertWithMessage:@"手机号码有误~" withSuperView:self withHeih:DeviceMaxHeight/2];
        return;
    }
    NSDictionary *dic = @{@"userId":[lhUserModel shareUserModel].userId,
                          @"orderId":_orderId,
                          @"type":[NSString stringWithFormat:@"%ld",(long)_type],
                          @"driver":nameTextField.text,
                          @"phone":phoneTextField.text,
                          @"plate":[NSString stringWithFormat:@"%@%@",_carType.text,carTextField.text],
                          @"idCard":jzTextField.text,
                          @"deliverTimeStr":_dataField.text
                          };
    FLLog(@"dic = %@",dic);
    [lhMainRequest HTTPPOSTNormalRequestForURL:PATH(@"client_transportOil") parameters:dic method:@"POST" success:^(id responseObject) {
        if (_type == 1) {
            [_directDelegate reloadPage];
        }else{
            [_groupDelegate reloadPage];
        }
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect = popView.frame;
            rect.origin.y = DeviceMaxHeight;
            rect.size.height = 0;
            popView.frame = rect;
        }completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            [popView removeFromSuperview];
            [ws removeFromSuperview];
        }];
    
    } fail:nil];
}

@end
