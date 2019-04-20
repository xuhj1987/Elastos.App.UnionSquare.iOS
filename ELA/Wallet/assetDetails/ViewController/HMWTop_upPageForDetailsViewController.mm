//
//  HMWTop_upPageForDetailsViewController.m
//  ELA
//
//  Created by 韩铭文 on 2018/12/27.
//  Copyright © 2018 HMW. All rights reserved.
//

#import "HMWTop_upPageForDetailsViewController.h"
#import "HMWChooseSideChainViewController.h"
#import "ELWalletManager.h"
#import <Cordova/CDV.h>
#import "HMWtransferDetailsPopupView.h"
#import "HMWSendSuccessPopuView.h"
#import "ScanQRCodeViewController.h"



@interface HMWTop_upPageForDetailsViewController ()< HMWChooseSideChainViewControllerDelegate,HMWtransferDetailsPopupViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBGViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *toUpNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseSideChainButton;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UITextField *enterTheAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *maxButton;
@property (weak, nonatomic) IBOutlet UILabel *theExchangeRateLabel;

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *theNextStepButton;
/*
 *<# #>
 */
@property(strong,nonatomic)HMWtransferDetailsPopupView *transferDetailsPopupV;
/*
 *<# #>
 */
@property(strong,nonatomic)HMWSendSuccessPopuView *sendSuccessPopuV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BGViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *assetIconImageView;
@end

@implementation HMWTop_upPageForDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defultWhite];
    [self setBackgroundImg:@"asset_bg"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"setting_adding_scan"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(scanView)];
    self.toUpNameLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"充值到", nil),self.selectmModel.iconName];
//     self.toUpNameLabel.text=[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"充值到", nil),@"ELA"];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.addressTextField];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.enterTheAmountTextField];
    [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:self.noteTextField];
    [[HMWCommView share] makeBordersWithView:self.theNextStepButton];
    [self.theNextStepButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
     self.noteTextField.placeholder=NSLocalizedString(@"请输入备注", nil);
//    self.enterTheAmountTextField.placeholder=[NSString stringWithFormat:@"%@：%@ %@）",NSLocalizedString(@"请输入金额（可用", nil),[[FLTools share] elaScaleConversionWith:self.fromModel.iconBlance],self.fromModel.iconName];
       self.enterTheAmountTextField.placeholder=[NSString stringWithFormat:@"%@：%@ %@）",NSLocalizedString(@"请输入金额（可用", nil),[[FLTools share] elaScaleConversionWith:self.fromModel.iconBlance],@"ELA"];
    
    if (self.type==mainChainWithdrawalType) {
       self.addressTextField.placeholder=NSLocalizedString(@"请输入主链提现地址", nil);
        self.BGViewHeight.constant=0.f;
        self.assetIconImageView.alpha=0.f;
    }else{
        
        self.addressTextField.placeholder=NSLocalizedString(@"请输入侧链充值地址", nil);
        
    }
    self.enterTheAmountTextField.delegate=self;
    self.theExchangeRateLabel.text=[NSString stringWithFormat:@"%@ 1:1",NSLocalizedString(@"汇率", nil)];
    
}
-(void)scanView{
    __weak __typeof__(self) weakSelf = self;
    ScanQRCodeViewController *scanQRCodeVC = [[ScanQRCodeViewController alloc]init];
    scanQRCodeVC.scanBack = ^(NSString *addr) {
        
        weakSelf.addressTextField.text=addr;
        
    };
    [self QRCodeScanVC:scanQRCodeVC];
}

- (IBAction)ChooseSideChainEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pasteEvent:(id)sender {
    
    
    self.addressTextField.text=[[FLTools share]pastingTextFromTheClipboard];
    
}
- (IBAction)selectFriendsEvent:(id)sender {
    self.friendsButton.userInteractionEnabled=NO;
    HMWChooseSideChainViewController *chooseSideChainVC=[[HMWChooseSideChainViewController alloc]init];
    chooseSideChainVC.type=chooseFriendsType;
    chooseSideChainVC.delegate=self;
    [self.navigationController pushViewController:chooseSideChainVC animated:YES]; self.friendsButton.userInteractionEnabled=YES;
}
- (IBAction)maxEvent:(id)sender {
}
- (IBAction)theNextStepEvent:(id)sender {
    if (self.addressTextField.text.length==0) {
        return;
    }
        if ([self.enterTheAmountTextField.text doubleValue]>[[[FLTools share]elaScaleConversionWith:self.fromModel.iconBlance] doubleValue]) {

            [[FLTools share]showErrorInfo:NSLocalizedString(@"余额不足", nil)];
            return;
        }
   
    CDVPluginResult * result;
    if (self.type==sideChainTop_upType) {
            CDVInvokedUrlCommand *mommand=[[CDVInvokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.fromModel.iconName,self.selectmModel.iconName,@"",self.addressTextField.text,[[FLTools share]elsToSela:self.enterTheAmountTextField.text],self.noteTextField.text,self.noteTextField.text,@"0"] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"sideChainTop_UpFee"];
        
  result=[[ELWalletManager share]sideChainTop_UpFee:mommand];
        
      
    }
    if (self.type==mainChainWithdrawalType) {
            CDVInvokedUrlCommand *mommand=[[CDVInvokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.fromModel.iconName,self.substringAddress,self.addressTextField.text,[[FLTools share]elsToSela:self.enterTheAmountTextField.text],self.noteTextField.text,self.noteTextField.text] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"sideChainTop_UpFee"];
  result=[[ELWalletManager share]mainChainWithdrawalFee:mommand];
       
        
  
        
    }
    
    NSString *fee=[[FLTools share]elaScaleConversionWith: [NSString stringWithFormat:@"%@",result.message[@"success"]]];
    NSString *status=[NSString stringWithFormat:@"%@",result.status];
    if (![status isEqualToString:@"1"]) {
        return;
    }
    
    [self.transferDetailsPopupV transferDetailsWithToAddress:self.addressTextField.text withTheAmountOf:[NSString stringWithFormat:@"%@%@",  self.enterTheAmountTextField.text,@"ELA"] withFee:[NSString stringWithFormat:@"%@%@",fee,@"ELA"]];
    
    

    
    UIView *manView=[self mainWindow];
    
    [manView addSubview:self.transferDetailsPopupV];
    [self.transferDetailsPopupV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(manView);
    }];
  
    
    
}
-(HMWtransferDetailsPopupView *)transferDetailsPopupV{
    if (!_transferDetailsPopupV) {
        _transferDetailsPopupV =[[HMWtransferDetailsPopupView alloc]init];
        _transferDetailsPopupV.delegate=self;
        _transferDetailsPopupV.type=sideChainTop_UpType;
    }
    
    return _transferDetailsPopupV;
}
-(HMWSendSuccessPopuView *)sendSuccessPopuV{
    if (!_sendSuccessPopuV) {
        _sendSuccessPopuV =[[HMWSendSuccessPopuView alloc]init];
        
        
        
    }
    
    return _sendSuccessPopuV;
}
-(void)showSendSuccessPopuV{
    UIView *manView=[self mainWindow];
    [manView addSubview:self.sendSuccessPopuV];
    [self.sendSuccessPopuV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(manView);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sendSuccessPopuV removeFromSuperview];
        self.sendSuccessPopuV=nil;
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)hiddenSendSuccessPopuV{
    [self.sendSuccessPopuV removeFromSuperview];
    self.sendSuccessPopuV=nil;
    
    
}
#pragma mark ---------HMWtransferDetailsPopupViewDelegate----------

-(void)closeThePage{
    
    
    [self.transferDetailsPopupV removeFromSuperview];
    self.transferDetailsPopupV=nil;
}
-(void)pwdAndInfoWithPWD:(NSString *)pwd{
    
    [self.transferDetailsPopupV removeFromSuperview];
    
    self.transferDetailsPopupV=nil;
    
    if (self.type==sideChainTop_upType) {
            CDVInvokedUrlCommand *mommand=[[CDVInvokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.fromModel.iconName,self.selectmModel.iconName,self.addressArray.firstObject,self.addressTextField.text,[[FLTools share]elsToSela:self.enterTheAmountTextField.text],self.noteTextField.text,self.noteTextField.text,pwd,@"1"] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"sideChainTop_Up"];
        
            CDVPluginResult *result = [[ELWalletManager share]sideChainTop_Up:mommand];
            NSString *statue=[NSString stringWithFormat:@"%@",result.status];
        
            if (![statue isEqualToString:@"1"]) {
            return;
            }
         [self showSendSuccessPopuV];
        
    }
    if (self.type==mainChainWithdrawalType) {
        CDVInvokedUrlCommand *mommand=[[CDVInvokedUrlCommand alloc]initWithArguments:@[self.currentWallet.masterWalletID,self.fromModel.iconName,@"",self.addressTextField.text,[[FLTools share]elsToSela:self.enterTheAmountTextField.text],self.noteTextField.text,self.noteTextField.text,pwd,@"0"] callbackId:self.currentWallet.walletID className:@"Wallet" methodName:@"mainChainWithdrawal"];
        
        CDVPluginResult *result = [[ELWalletManager share]mainChainWithdrawal:mommand];
        NSString *statue=[NSString stringWithFormat:@"%@",result.status];
        if (![statue isEqualToString:@"1"]) {
            return;
        }
        [self showSendSuccessPopuV];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(void)setSelectIndex:(NSIndexPath *)selectIndex{
    
}

-(void)choosedFriedsMode:(friendsModel*)model{
    
    self.addressTextField.text=model.address;
    
}
-(void)setCurrentWallet:(FLWallet *)currentWallet{
    _currentWallet=currentWallet;
    
    
}
-(void)setAddressArray:(NSArray *)addressArray{
    _addressArray=addressArray;
    
}
-(void)setFromModel:(assetsListModel *)fromModel{
    _fromModel=fromModel;
    
}
-(void)setSelectmModel:(assetsListModel *)selectmModel{
    _selectmModel=selectmModel;
    
    
}
-(void)setType:(Top_upPageForDetailsType)type{
    _type=type;
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
 
    
    NSCharacterSet *cs;
    
    if ([textField isEqual:self.enterTheAmountTextField]) {
        
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        
        if (NSNotFound == nDotLoc && 0 != range.location) {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            
        }
        
        else {
            
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            
            
            
            //            [self showMyMessage:@"只能输入数字和小数点"];
            
            return NO;
            
        }
        
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 4) {
            
            //            [self showMyMessage:@"小数点后最多三位"];
            
            return NO;
            
        }
        
    }
    
    return YES;
}
@end
