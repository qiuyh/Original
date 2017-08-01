//
//  AddressViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "AddressViewController.h"
#import "NewAddressViewController.h"
#import "NSString+Validate.h"
#import "CustomAddressCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_addArray;
    NSInteger _row;
    NSIndexPath *_indexPath;
    
    NSInteger _index;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *tipNoAddress;


@end

@implementation AddressViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _addArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//     self.myTableView.hidden=YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    //设tableview的cell的高度
    _myTableView.rowHeight=130;
    _tipNoAddress.hidden  = NO;
   self.myTableView.hidden= YES;
    
    NSString *fileName = @"address.json";
    
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
    
    [[QYHQiNiuRequestManarger shareInstance]getFile:fileName withphotoNumber:customId Success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"查询地址==%@",responseObject);
        
     
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
//            for (NSDictionary *dic in [responseObject objectForKey:@"address"])
//            {
//                BOOL      checked  = [[dic objectForKey:@"checked"] boolValue];
//                NSString *biaozhi  = [dic objectForKey:@"biaozhi"];
//                NSString *showArea = [dic objectForKey:@"showArea"];
//                NSString *address  = [dic objectForKey:@"address"];
//                NSString *name     = [dic objectForKey:@"name"];
//                NSString *phone    = [dic objectForKey:@"phone"];
//                
                
            _addArray = [responseObject objectForKey:@"address"];
            
            _index    = [[responseObject objectForKey:@"checked"] integerValue];
            
//            NSLog(@"_index==%d",_index);
       
//        }
            _tipNoAddress.hidden   = YES;
            self.myTableView.hidden= NO;
            [self.myTableView reloadData];

         
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"查询地址失败");
    }];
    
}


//删除
- (IBAction)dele:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"是否删除此收货地址?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    aler.delegate=self;
    //让提示框显示
    [aler show];
    //取到相应的行数cell
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    
    _indexPath = [self.myTableView indexPathForCell:cell];
    _row=[_indexPath row];//取到对应button里的第几个cell
        //延时,看到有高亮的效果
    [self performSelector:@selector(but:) withObject:button afterDelay:0.3];

}
//延时0.3秒后恢复不选中状态
- (void)but:(UIButton *)button
{
    button.selected=NO;
}
//编辑(对现有的地址进行编辑)
- (IBAction)change:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
    //取到相应的行数cell
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.myTableView indexPathForCell:cell];
    _row=[path row];//取到对应button里的第几个cell
    //延时,看到有高亮的效果
    [self performSelector:@selector(but:) withObject:button afterDelay:0.3];
    
    
     NewAddressViewController *couponVC= [self.storyboard instantiateViewControllerWithIdentifier:@"NewAddressViewController"];
    //编辑时进行正向传值,把原来的数据传过去进行修改
    couponVC.editDic  = _addArray[_row];
    couponVC.allArray = _addArray;
    couponVC.index    = _row;
    
    if (_row == _index)
    {
        couponVC.isSelected  = YES;
    }
    
    //通过block反向传值获取到修改后的数据(和新增新地址一样)
//    [couponVC setBlock:^(NSArray *array) {
//        
//        if ([array[0] integerValue]==1)
//        {
//            for (NSMutableArray *defArray in _addArray)
//            {
//                [defArray replaceObjectAtIndex:0 withObject:@(0)];
//            }
//        }
//        
//        [_addArray replaceObjectAtIndex:_row withObject:array];
//        self.myTableView.hidden=NO;
//        [self.myTableView reloadData];
//    }];
//    
    [self.navigationController pushViewController:couponVC animated:YES];
}

//返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//添加新地址
- (IBAction)addNewAddress:(id)sender {
    
    NewAddressViewController *couponVC= [self.storyboard instantiateViewControllerWithIdentifier:@"NewAddressViewController"];
//    //通过block进行反向传值,取到添加新地址页面的数据
//    [couponVC setBlock:^(NSArray *array) {
//        
//        if ([array[0] integerValue]==1)
//        {//如果该地址设为默认的地址,就遍历存储地址的数组把之前有设为默认地址的设为不默认地址(只能有一个是默认地址)
//            for (NSMutableArray *defArray in _addArray)
//            {
//                [defArray replaceObjectAtIndex:0 withObject:@(0)];
//            }
//        }
//        //添加返回来信息的数组
//        [_addArray addObject:array];
//        //有数据了就显示tableView进行刷新数据
//        self.myTableView.hidden=NO;
//        [self.myTableView reloadData];
//    }];
    
    couponVC.allArray = _addArray;
    
    [self.navigationController pushViewController:couponVC animated:YES];
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
    
    //返回小数组个数
    return _addArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CustomAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomAddressCell"];
//    NSArray *array=_addArray[indexPath.row];
    
    NSDictionary *dic = _addArray[indexPath.row];
  
    BOOL      checked = NO;
    
    if (_index == indexPath.row)
    {
        checked = [[dic objectForKey:@"checked"] boolValue];
        
    }else
    {
        checked = NO;
    }
    
    NSString *biaozhi  = [dic objectForKey:@"biaozhi"];
    NSString *showArea = [dic objectForKey:@"showArea"];
    NSString *address  = [dic objectForKey:@"address"];
    NSString *name     = [dic objectForKey:@"name"];
    NSString *phone    = [dic objectForKey:@"phone"];
    
    
    if (checked)
    {
        cell.defeaultAddress.text=[biaozhi stringByAppendingString:@"-默认收货地址"];
        
    }else
    {
        cell.defeaultAddress.text=biaozhi;
    }
    
    
    cell.address.text=[showArea stringByAppendingFormat:@" %@",address];
    cell.name.text     = name;
    cell.phoneNum.text = phone;
    
    

//
//    if ([array[0]integerValue]==1)
//    {//如果设为默认地址,就提示该地址是默认的地址
//        cell.defeaultAddress.text=[array[1] stringByAppendingString:@"-默认收货地址"];
//    }else
//    {//如果没设为默认地址,就不提示
//        cell.defeaultAddress.text=@"";
//    }
//    cell.address.text=[array[2] stringByAppendingFormat:@" %@",array[3]];//详细地址
//    cell.name.text=array[4];//收货人姓名
//    cell.phoneNum.text=array[5];//联系电话
    
    return cell;
}

#pragma mark-UIAlertViewDelegate
//选中对应行的cell就删除对应的数据
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果确认了删除就把数据删了,重新刷新数据
    if (buttonIndex==1)
    {
        
        
        [_addArray removeObjectAtIndex:_row];
        
        
        NSString *fileName = @"address.json";
        
        
        _index = _index > _row ? _index-1:_index;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_addArray];
        
        NSDictionary *dic1  = @{ @"address": array,@"checked":@(_index)};
        
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
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
//            [_myTableView reloadData];
            
            //2.界面删除
            [_myTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            
        } failure:^(NSError *error) {
            
            NSDictionary *err = error.userInfo;
            
            [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            if ([err[@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."])
            {
                [QYHProgressHUD showErrorHUD:nil message:@"网络连接失败"];
                
            }else
            {
                
                [QYHProgressHUD showErrorHUD:nil message:@"删除地址失败"];
            }
            
            NSLog(@"删除地址失败error==%@",error);
            
        }];
        
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
