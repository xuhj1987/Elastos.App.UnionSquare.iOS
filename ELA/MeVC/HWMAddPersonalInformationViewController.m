//
//  HWMAddPersonalInformationViewController.m
//  elastos wallet
//
//  Created by 韩铭文 on 2019/10/25.
//

#import "HWMAddPersonalInformationViewController.h"
#import "HWMCreateDIDListTableViewCell.h"
#import "HWMTheAreaCodeAndPhonenumberTableViewCell.h"


static NSString *cellString=@"HWMCreateDIDListTableViewCell";
static NSString *cellCodeAndPhonenumberString=@"HWMTheAreaCodeAndPhonenumberTableViewCell";

@interface HWMAddPersonalInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
/*
 *<# #>
 */
@property(strong,nonatomic)UIButton *skipButton;
/*
 *<# #>
 */
@property(strong,nonatomic)NSArray *dataSorse;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation HWMAddPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self defultWhite];
     [self setBackgroundImg:@""];
     
     self.title=NSLocalizedString(@"添加个人信息", nil);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.skipButton];
     [self makeUI];
}
-(void)makeUI{

    self.dataSorse =@[NSLocalizedString(@"请输入姓名", nil),NSLocalizedString(@"请输入昵称", nil),NSLocalizedString(@"请选择性别", nil),NSLocalizedString(@"请选择出生日期",nil),
           NSLocalizedString(@"请输入头像url", nil),NSLocalizedString(@"请输入邮箱",nil),@[NSLocalizedString(@"请输入区号（如 86）",nil),NSLocalizedString(@"请输入手机号码",nil)],
           NSLocalizedString(@"请选择国家/地区", nil)];
    [self.nextButton setTitle:NSLocalizedString(@"下一步", nil) forState: UIControlStateNormal];
    [[HMWCommView share]makeBordersWithView:self.nextButton];
    [self.table registerNib:[UINib nibWithNibName:cellString bundle:nil] forCellReuseIdentifier:cellString];
     [self.table registerNib:[UINib nibWithNibName:cellCodeAndPhonenumberString bundle:nil] forCellReuseIdentifier:cellCodeAndPhonenumberString];
       self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.table.rowHeight = 55;
       self.table.delegate =self;
       self.table.dataSource =self;
    self.table.backgroundColor=[UIColor clearColor];
//       UIImageView *bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//      [self CAGradientColorFrome:RGB(83, 136, 136) withToColor:RGB(16, 47, 58) withView:bgview];
//       self.table.backgroundView = bgview;
      
    
}
-(UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_skipButton setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_skipButton addTarget:self action:@selector(skipVCEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
-(void)skipVCEvent{
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6) {
        HWMTheAreaCodeAndPhonenumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellCodeAndPhonenumberString];
        NSArray *arrCN=self.dataSorse[indexPath.row];
        cell.MobilePhoneTextField.placeholder=arrCN.lastObject;
                  [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:cell.MobilePhoneTextField withTxt:arrCN.lastObject];
        cell.theArNumberTextField.placeholder=arrCN.firstObject;
        
         [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField: cell.theArNumberTextField withTxt:arrCN.firstObject];
        
        
        return cell;
    }
    HWMCreateDIDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *textString=self.dataSorse[indexPath.row];
    switch (indexPath.row) {
           
            case 2:
           
            cell.arrowImageView.alpha=1.f;
            cell.intPutTextField.text=textString;
            cell.intPutTextField.enabled=NO;
            
            break;
        
            case 3:
          cell.arrowImageView.alpha=1.f;
          cell.intPutTextField.text=textString;
          cell.intPutTextField.enabled=NO;
            break;
            case 7:
            cell.arrowImageView.alpha=1.f;
            cell.intPutTextField.text=textString;
            cell.intPutTextField.enabled=NO;
            break;
            
        default:
            cell.arrowImageView.alpha=0.f;
            cell.intPutTextField.placeholder=textString;
            [[HMWCommView share]makeTextFieldPlaceHoTextColorWithTextField:cell.intPutTextField withTxt:textString];
            break;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSorse.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.row==1) {
//        UIView *mainView =[self mainWindow];
//        [mainView addSubview:self.walletListView];
//        [self.walletListView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(mainView);
//        }];
//        self.walletListView.dataSourceArray=self.walletListArray;
//
//    }else if (indexPath.row==4){
//        UIView *mainView =[self mainWindow];
//               [mainView addSubview:self.dataListView];
//        [self.dataListView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(mainView);
//        }];
//    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, AppWidth, 50)];
    headView.backgroundColor=[UIColor clearColor];
    UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, AppWidth-30, 50)];
    headLabel.text=NSLocalizedString(@"DID信息", nil);
    headLabel.font=[UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headLabel.textColor=[UIColor whiteColor];
    [headView addSubview:headLabel];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

@end
