//
//  GiftCardViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "GiftCardViewController.h"
#import "QYHProgressHUD.h"

@interface GiftCardViewController ()

{
    
    UILabel *_label;//弹出提示作用
}

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UITextField *field;//账号

@property (weak, nonatomic) IBOutlet UITextField *field1;//密码


@end

@implementation GiftCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

//确认输入的卡号和密码是否正确
- (IBAction)check:(id)sender {
    
    if (_field.text.length==0)
    {//提示请输入礼金卡账号
//        [self createLabel:@"请输入礼金卡账号"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入礼金卡账号"];
        
    }else if (_field1.text.length==0)
    {//提示请输入密码
//        [self createLabel:@"请输入密码"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入密码"];
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

//结束键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//返回(礼金卡)
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
