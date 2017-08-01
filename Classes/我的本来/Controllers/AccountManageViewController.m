//
//  AccountManageViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "AccountManageViewController.h"
#import "CustomManagerCell.h"
#import "AddressViewController.h"
#import "CouponViewController.h"
#import "GiftCardViewController.h"
#import "PersonNationnalViewController.h"

@interface AccountManageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_imgArray;//储存头像
    NSArray *_titleArray;//储存标题
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation AccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取数据
    [self getData];
}
//获取数据
- (void)getData
{
//    默认设置cell的高度
    _myTableView.rowHeight=50;
    _imgArray=@[@"prdreviews_img",@"message_other",@"message_account",@"home_menu_person_on",];
    
    _titleArray=@[@"地址管理",@"优惠劵",@"礼金卡",@"个人信息",];
}

//返回
- (IBAction)back:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
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
    return _titleArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomManagerCell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.imgView.image=[UIImage imageNamed:_imgArray[indexPath.row]];
    //箭头图片
    cell.arrowImgView.image=[UIImage imageNamed:@"arrow"];
    
    cell.titleLabel.text=_titleArray[indexPath.row];
    
    return cell;
}
//选中哪行,进入对应的页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        switch (indexPath.row)
    {
        case 0:
        {//进入地址管理
            AddressViewController *addressVC= [self.storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
            [self.navigationController pushViewController:addressVC animated:YES];
            break;
        }
        case 1:
        {//优惠劵
            CouponViewController *couponVC= [self.storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
            [self.navigationController pushViewController:couponVC animated:YES];
            break;
        }
        case 2:
        {//进入礼金卡
            GiftCardViewController *giftCardVC= [self.storyboard instantiateViewControllerWithIdentifier:@"GiftCardViewController"];
            [self.navigationController pushViewController:giftCardVC animated:YES];
            break;
        }
        case 3:
        {//进入个人信息
            
#warning 未完成
            if ( [UserStorage shareInstance].uid)
            {
                [QYHProgressHUD showErrorHUD:nil message:@"第三方登录不能更改个人信息"];
                
                return;

            }
            
            PersonNationnalViewController *personVC= [self.storyboard instantiateViewControllerWithIdentifier:@"PersonNationnalViewController"];
            [self.navigationController pushViewController:personVC animated:YES];
            break;
        }

        default:
            break;
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
