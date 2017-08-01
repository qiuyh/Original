//
//  NewAddressViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "NewAddressViewController.h"
#import "City.h"
#import "Province.h"
#import "QYHProgressHUD.h"
#import "NSString+Validate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface NewAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _checked;//判断是否设为默认地址
    
    NSMutableArray *_provinceArray;//存省的数组
   
    BOOL _isProvince;//判断是否选中省
    BOOL _isCity;//判断是否选中市
    BOOL _isSector;//判断是否选中区
    
    int _province;//判断选中省的的第几行
    int _city;//判断选中市的的第几行
    int _sector;//判断选中区的的第几行
    
    UILabel *_label;//弹出提示作用
    NSMutableArray *_blockArray;//存储数据进行传值
}

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;//设为默认地址的按钮

@property (weak, nonatomic) IBOutlet UITableView *myTableView;//

@property (weak, nonatomic) IBOutlet UIView *areaView;//显示地区的View
@property (weak, nonatomic) IBOutlet UIButton *provinceBT;//选择省的按钮
@property (weak, nonatomic) IBOutlet UIButton *cityBT;//选择市的按钮
@property (weak, nonatomic) IBOutlet UIButton *sectorBT;//选择区的按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;//弹出显示省市区的tableview的高度

@property (weak, nonatomic) IBOutlet UIView *tbView;//遮盖用的View
@property (weak, nonatomic) IBOutlet UIButton *showArea;//确认后显示选中的区域
@property (weak, nonatomic) IBOutlet UITextField *address;//详情地址
@property (weak, nonatomic) IBOutlet UITextField *name;//收货人

@property (weak, nonatomic) IBOutlet UITextField *phone;//联系电话

@property (weak, nonatomic) IBOutlet UITextField *biaozhi;//地址标志



@end

@implementation NewAddressViewController
//初始化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _provinceArray=[[NSMutableArray alloc]init];
        _province=0;
        _city=0;
        _sector=0;
        
        _blockArray=[[NSMutableArray alloc]init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取省市区
    [self getData];
}
//视图即将出现
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏
    _myTableView.hidden=YES;
    _tbView.hidden=YES;
    self.areaView.hidden=YES;
    
    //把反向传过来的值进行赋值
    
    if (_editDic)
    {
        NSDictionary *dic = _editDic;
        
//        BOOL      checked  = [[dic objectForKey:@"checked"] boolValue];
        NSString *biaozhi  = [dic objectForKey:@"biaozhi"];
        NSString *showArea = [dic objectForKey:@"showArea"];
        NSString *address  = [dic objectForKey:@"address"];
        NSString *name     = [dic objectForKey:@"name"];
        NSString *phone    = [dic objectForKey:@"phone"];
        
        
        _checked=_isSelected;
        self.biaozhi.text=biaozhi;
        [self.showArea setTitle:showArea forState:UIControlStateNormal];
        self.address.text=address;
        self.name.text=name;
        self.phone.text=phone;
        //是否是默认地址
        if (_checked)
        {
            _defaultButton.selected=YES;
        }

    }
    
}

//获取省市区
- (void)getData
{
    //获取json的路径
    NSString *path=[[NSBundle mainBundle]pathForResource:@"省市区.json" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    //获取json的数据
    NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dic in array)
    {//json解析后储存数据
        Province *provinceModel=[[Province alloc]init];
        provinceModel.provinceName=dic[@"name"];
        
        for (NSDictionary *dic1 in dic[@"city"])
        {
            City *cityModel=[[City alloc]init];
            cityModel.cityName=dic1[@"name"];
            
            for (NSString *str in dic1[@"area"])
            {
                [cityModel.areaArray addObject:str];
            }
            
            [provinceModel.cityArray addObject:cityModel];
        }
        
        [_provinceArray addObject:provinceModel];
    }
}

//返回(新地址)
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//填完后的确认
- (IBAction)check:(id)sender {
    //检查是否填写的内容正确,如果不正确做出相应的提示;如果正确就把值传回去
    if (self.showArea.currentTitle==NULL)
    {
//        [self createLabel:@"所在区域不能为空"];
        [QYHProgressHUD showErrorHUD:nil message:@"所在区域不能为空"];
    }else if ([self.address.text isEqualToString:@""])
    {
//        [self createLabel:@"详细地址不能为空"];
        [QYHProgressHUD showErrorHUD:nil message:@"详细地址不能为空"];
    }else if ([self.name.text isEqualToString:@""])
    {
//        [self createLabel:@"收货人不能为空"];
        [QYHProgressHUD showErrorHUD:nil message:@"收货人不能为空"];
    }else if ([self.phone.text isEqualToString:@""])
    {
//        [self createLabel:@"联系电话不能为空"];
        [QYHProgressHUD showErrorHUD:nil message:@"联系电话不能为空"];
    }else if (![self isMobileNumber:self.phone.text])
    {
//        [self createLabel:@"请输入正确的手机号"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入正确的手机号"];
    }else
    {
//        [_blockArray addObject:@(_checked)];
//        [_blockArray addObject:self.biaozhi.text];
//        [_blockArray addObject:self.showArea.currentTitle];
//        [_blockArray addObject:self.address.text];
//        [_blockArray addObject:self.name.text];
//        [_blockArray addObject:self.phone.text];
//        
//        if (self.block)
//        {
//           self.block(_blockArray);
//        }
        
        
        NSString *fileName = @"address.json";
        
        NSDictionary *dic  = @{ @"checked"   : @(_checked),
                                @"biaozhi"   : _biaozhi.text,
                                @"showArea"  : _showArea.currentTitle,
                                @"address"   : _address.text,
                                @"name"      : _name.text,
                                @"phone"     : _phone.text};
        
       
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_allArray];
        
        if (_editDic)
        {
//            NSLog(@"_index==%d,array==%@",_index,array);
            
            [array replaceObjectAtIndex:_index withObject:dic];
            
            
        }else
        {
            
            [array addObject:dic];
            
        }
        
        NSDictionary *dic1  = @{ @"address": array,@"checked": _editDic ? @(_index) : @(array.count-1)};
        
        NSString *str = [NSString dictionaryToJson:dic1];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        SSEBaseUser *user = [SSEThirdPartyLoginHelper currentUser];
        
        NSString *customId = nil;
        
        if (user)
        {
            customId = [UserStorage shareInstance].uid;
            
        }else
        {
            customId = [UserStorage shareInstance].account;
        }

        
        
        [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:customId data:data Success:^(id responseObject) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
           
            
        } failure:^(NSError *error) {
            
            NSDictionary *err = error.userInfo;
            
            [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
            {
                [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                
            }else
            {
                
                [QYHProgressHUD showErrorHUD:nil message:@"添加地址失败"];
            }
            
            NSLog(@"添加地址失败error==%@",error);
            
        }];

    }
}

//创建label(提示作用)
- (void)createLabel:(NSString *)title
{
    [_label removeFromSuperview];//先把原来的删除
    _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.5, self.view.frame.size.height-120, 150, 35)];
    _label.backgroundColor=[UIColor darkTextColor];
    _label.textAlignment=NSTextAlignmentCenter;
    //设置圆角度和边框
    _label.layer.borderWidth = 0.5f;
    _label.layer.masksToBounds = YES;
    
    _label.textColor=[UIColor whiteColor];
    _label.text=title;
    
    _label.layer.cornerRadius=15;
    
    [self.view addSubview:_label];
    //动画进行透明度加大,动画完后移除label
    [UIView animateWithDuration:2.0 animations:^{
        
        _label.alpha=0.6;
        
    } completion:^(BOOL finished) {
        
        [_label removeFromSuperview];
    }];
    
}

//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//设为默认地址
- (IBAction)defaultArea:(id)sender {
    
    _checked=!_checked;
    if (_checked)
    {
        _defaultButton.selected=YES;
    }else
    {
        _defaultButton.selected=NO;
    }
}
//结束键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//弹出或者隐藏选择的地址
- (IBAction)areaButton:(id)sender {
    
    self.areaView.hidden=!self.areaView.hidden;
}
//区域选择确认
- (IBAction)choose:(id)sender {
    
    self.areaView.hidden=YES;
    //确认好赋值
    NSString *str=[_provinceBT.currentTitle stringByAppendingFormat:@" %@ %@",_cityBT.currentTitle,_sectorBT.currentTitle];
    
    [self.showArea setTitle:str forState:UIControlStateNormal];
    
}
//省
- (IBAction)province:(id)sender {
    //如果选中了省得按钮就把判断是否选中省置YES,其他置NO,显示区域的View和tableview,刷新数据
    _isProvince=YES;
    _isCity=NO;
    _isSector=NO;
    
    _tbView.hidden=NO;
    _myTableView.hidden=NO;
    [_myTableView reloadData];
}
//市
- (IBAction)city:(id)sender {
     //如果选中了市得按钮就把判断是否选中市置YES,其他置NO,显示区域的View和tableview,刷新数据
    _isProvince=NO;
    _isCity=YES;
    _isSector=NO;
    
    _tbView.hidden=NO;
     _myTableView.hidden=NO;
    [_myTableView reloadData];
}
//区
- (IBAction)sector:(id)sender {
    //如果选中了区得按钮就把判断是否选中区置YES,其他置NO,显示区域的View和tableview,刷新数据
    _isProvince=NO;
    _isCity=NO;
    _isSector=YES;
    
    _tbView.hidden=NO;
     _myTableView.hidden=NO;
    [_myTableView reloadData];
}

#pragma mark -UITableViewDataSource&UITableViewDelegate
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //数据源有多少个元素,就返回多少
    return 1;
}
//返回对应组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _myTableView.rowHeight=35;//返回cell的高度
    //返回小数组个数
    
    //返回对应内容的tableview的高度和行数,根据每行的高度为35像素来进行判断需要返回多高的tableview,如果超过了限定的就返回最大的tableview高度
    if (_isProvince)
    {
        if (35*_provinceArray.count>self.view.frame.size.height-50)
        {
            _tableViewHeight.constant=self.view.frame.size.height-50;
        }else
        {
        _tableViewHeight.constant=35*_provinceArray.count;
        }
        return _provinceArray.count;
    }else if(_isCity)
    {
        Province *model=_provinceArray[_province];
        if (35*model.cityArray.count>self.view.frame.size.height-50)
        {
            _tableViewHeight.constant=self.view.frame.size.height-50;
        }else
        {
        _tableViewHeight.constant=35*model.cityArray.count;
        }
        return model.cityArray.count;
    }else if (_isSector)
    {
        Province *model1=_provinceArray[_province];
        City *model2=model1.cityArray[_city];
        if (35*model2.areaArray.count>self.view.frame.size.height-50)
        {
            _tableViewHeight.constant=self.view.frame.size.height-50;
        }else
        {
        _tableViewHeight.constant=35*model2.areaArray.count;
        }
        return model2.areaArray.count;
    }else
        return 0;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedID = @"reusedID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    //返回对应的cell的内容,如果是省就返回省的内容;如果是市就返回市的内容;如果是区就返回区的内容,
    if (_isProvince)
    {
        Province *model=_provinceArray[indexPath.row];
        cell.textLabel.text=model.provinceName;
        
    }else if(_isCity)
    {
        Province *model=_provinceArray[_province];
        City *model1=model.cityArray[indexPath.row];
        cell.textLabel.text=model1.cityName;
        
    }else if (_isSector)
    {
        Province *model=_provinceArray[_province];
        City *model1=model.cityArray[_city];
        cell.textLabel.text=model1.areaArray[indexPath.row];
        
    }else
    {
    
    }
    return cell;
}
//选中哪行数据,执行对应行的任务
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果选择了省就返回对应行的省并把市和区都默认显示第一行的数据
    if (_isProvince)
    {
        _province=indexPath.row;
        _city=0;
        _sector=0;
        
    }else if(_isCity)
    {//如果选择了市就返回对应行的市,把之前选择省的行的数据显示并把区都默认显示第一行的数据

//        _province=0;
        _city=indexPath.row;
        _sector=0;
      
    }else if (_isSector)
    {//如果选择了区就返回对应行的区,把之前选择省和市的行的数据
//        _province=0;
//        _city=0;
        _sector=indexPath.row;
        
    }else
    {//如果都没有选择就默认显示省,市和区的第一行的数据
        _province=0;
        _city=0;
        _sector=0;
    }
    //选中后重新赋值对应的地区
    Province *model=_provinceArray[_province];
    City *model1=model.cityArray[_city];
     [_provinceBT setTitle:model.provinceName forState:UIControlStateNormal];
    [_cityBT setTitle:model1.cityName forState:UIControlStateNormal];
    [_sectorBT setTitle:model1.areaArray[_sector] forState:UIControlStateNormal];

    
    //选中后隐藏tableview和背景的View
    _myTableView.hidden=YES;
    _tbView.hidden=YES;
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
