//
//  MyoderViewController1.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "MyoderViewController1.h"
#import "MBProgressHUD.h"
#import "FMDBmanager.h"
#import "CartViewController.h"

@interface MyoderViewController1 ()
{
    UIImageView *_imgView;//没有订单显示图片的imageView
    UIButton *_selButton;//记录上一次的button
    UILabel *label;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@end

@implementation MyoderViewController1
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    _myScrollView.hidden=YES;
    
    [super viewDidLoad];
    
    [self addImage];
    
    [self addObse];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
         _myScrollView.hidden=NO;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

    // Do any additional setup after loading the view.
    
}


- (void)addObse
{
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    int count = 0;
    
    while ([rs next])
    {
        count+=[[rs stringForColumn:@"num"] intValue];
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:[NSString stringWithFormat:@"%d",count]];
    
}

//添加图片
- (void)addImage
{
    //一进来就默认选中的按钮
    _selectButton.selected=YES;
    _selButton=_selectButton;
    //设置内容大小
    _myScrollView.contentSize=CGSizeMake(self.view.frame.size.width*4, self.myScrollView.frame.size.height);
    
    for (int i=0; i<4; i++)
    {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 70, self.view.frame.size.width, 170)];
        _imgView.image=[UIImage imageNamed:@"comment_empty.png"];
        
        [_myScrollView addSubview:_imgView];
    }
    
}
//四个按钮的事件
- (IBAction)click:(id)sender {
    UIButton *button=(UIButton *)sender;
//    记录上次的button,把它不选中,选中现在按得按钮
    _selButton.selected=NO;
    button.selected=YES;
    _selButton=button;
    
}
//返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//待付款
- (IBAction)waitting:(id)sender {
    _myScrollView.hidden=YES;
    
    //转圈效果开始
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //设置对应的偏移量
        _myScrollView.contentOffset=CGPointMake(_myScrollView.frame.size.width, 0);
            //转圈效果隐藏
        _myScrollView.hidden=NO;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}
//配送中
- (IBAction)send:(id)sender {
    _myScrollView.hidden=YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       _myScrollView.contentOffset=CGPointMake(0*_myScrollView.frame.size.width, 0);
        _myScrollView.hidden=NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
 }
//已完成
- (IBAction)success:(id)sender {
    _myScrollView.hidden=YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _myScrollView.contentOffset=CGPointMake(2*_myScrollView.frame.size.width, 0);
        _myScrollView.hidden=NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}
//已取消
- (IBAction)cancel:(id)sender {
    _myScrollView.hidden=YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _myScrollView.contentOffset=CGPointMake(3*_myScrollView.frame.size.width, 0);
        
        _myScrollView.hidden=NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}



- (void)labelText:(NSNotification *)noti
{
    
    if ([noti.object isEqualToString:@"0"])
    {
        label.hidden=YES;
    }else
    {
        label=[[UILabel alloc]initWithFrame:CGRectMake(42, 0, 13, 13)];
        label.font=[UIFont systemFontOfSize:10];
        label.textAlignment=NSTextAlignmentCenter;
        
        label.textColor=[UIColor whiteColor];
        label.layer.borderWidth  = 1.0f;
        label.layer.borderColor  = [UIColor orangeColor].CGColor;
        label.layer.backgroundColor =[UIColor orangeColor].CGColor;
        label.layer.cornerRadius = 6.0f;
        
        [self.cartBtn addSubview:label];
        
        label.hidden=NO;
        label.text=noti.object;
        label.adjustsFontSizeToFitWidth=YES;
    }
}

- (IBAction)pushToCart:(id)sender {
    
    CartViewController *cartVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
//    cartVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:cartVC animated:YES completion:nil];
    cartVC.second=@"1";
    [self.navigationController pushViewController:cartVC animated:NO];
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
