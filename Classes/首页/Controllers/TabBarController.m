//
//  TabBarController.m
//  Original
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "TabBarController.h"
#import "CartViewController.h"
#import "FMDBmanager.h"
#import "NewViewController.h"

@interface TabBarController ()<Delege>
{
    UILabel *label;
    UIButton *_btn;
}
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //调用自定义的tabBar
    [self customTabBar];
    
    [self addObse];
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

//自定义tabBar
- (void)customTabBar
{
    //移除tabbar
//    [self.tabBar removeFromSuperview];
    self.tabBar.hidden=YES;
    
//    自定义tabbar的fram根原来的一样
    
    _myTabBar=[[UIImageView alloc]initWithFrame:self.tabBar.frame];
    //设置背景图
    _myTabBar.image=[UIImage imageNamed:@"bar_bottom_bac"];
    _myTabBar.contentMode=UIViewContentModeScaleAspectFill;

    //打开手势
    _myTabBar.userInteractionEnabled=YES;
    
    [self addButton];
    
    [self.view addSubview:_myTabBar];
    
}

//添加button
- (void)addButton
{
    
    //未选中的图片
    NSArray *norArray=@[@"home_menu1",@"home_menu_search1",@"home_menu_new1",@"home_menu_person1",@"buy1"];
    //选中的图片
    NSArray *selArray=@[@"home_menu_on1",@"home_menu_search_on1",@"home_menu_new_on1",@"home_menu_person_on1",@"buy_on1"];
    //title
    NSArray *itemArray=@[@"首页",@"分类",@"新品",@"我的本来",@"",];


    //    添加5个按钮
    for (int i=0; i<norArray.count; i++)
    {
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i==0)
        {
            _button.frame=CGRectMake(_myTabBar.frame.size.width/norArray.count*i,-1, _myTabBar.frame.size.width/norArray.count,_myTabBar.frame.size.height);
            _button.titleEdgeInsets=UIEdgeInsetsMake(37.5, -47, 0, 0);
        }else
        {
            _button.frame=CGRectMake(_myTabBar.frame.size.width/norArray.count*i,0 , _myTabBar.frame.size.width/norArray.count,_myTabBar.frame.size.height);
            _button.titleEdgeInsets=UIEdgeInsetsMake(37, -47, 0, 0);
        }
        
        if (i==3)
        {
            _button.frame=CGRectMake(_myTabBar.frame.size.width/norArray.count*i+10,-0.5, _myTabBar.frame.size.width/norArray.count,_myTabBar.frame.size.height);
            _button.titleEdgeInsets=UIEdgeInsetsMake(37, -58, 0, 0);
        }
        
        if (i==4)
        {
            _button.frame=CGRectMake(_myTabBar.frame.size.width/norArray.count*i+4,0, _myTabBar.frame.size.width/norArray.count+25,_myTabBar.frame.size.height+15);
            _button.imageEdgeInsets=UIEdgeInsetsMake(-20, 0, 0,30);
            _btn=_button;
        }
        
        //设置button的title
        [_button setTitle:itemArray[i] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:12];
        
        //设置button为正常的状态图
        [_button setImage:[UIImage imageNamed:norArray[i]] forState:UIControlStateNormal];
        //设置button选中状态图
        if (i==4)
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(42, -6, 13, 13)];
            label.font=[UIFont systemFontOfSize:10];
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor whiteColor];
            label.layer.borderWidth  = 1.0f;
            label.layer.borderColor  = [UIColor orangeColor].CGColor;
            label.layer.backgroundColor =[UIColor orangeColor].CGColor;
            label.layer.cornerRadius = 6.0f;
            [_button addSubview:label];
            
            
            [_button setImage:[UIImage imageNamed:norArray[i]] forState:UIControlStateHighlighted];
            
            [_button setImage:[UIImage imageNamed:@"buy_on1"] forState:UIControlStateSelected];
        }else
        {
            [_button setImage:[UIImage imageNamed:selArray[i]] forState:UIControlStateSelected];
        }
        

        _button.tag=100+i;
        
        //默认选中第1个按钮,选中第一个的控制器
        if (i==0)
        {
            _button.selected=YES;
            self.selectedIndex=0;
            _selButton=_button;
            _butt=_button;
        }
        
        //按钮事件
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //把按钮添加到_myTabBar之上
        [_myTabBar addSubview:_button];
    }
}

- (void)labelText:(NSNotification *)noti
{
//    NSLog(@"%@",noti.object);
    if ([noti.object isEqualToString:@"0"])
    {
        label.hidden=YES;
    }else
    {
        label.hidden=NO;
        label.text=noti.object;
        label.adjustsFontSizeToFitWidth=YES;
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//事件
- (void)buttonClick:(UIButton *)button
{
//    NSLog(@"%d",button.tag-100);
    if (button.tag-100==4)
    {
//      CartViewController *cartVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
//        cartVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:cartVC animated:YES completion:nil];
//        
//        return;
        self.myTabBar.hidden=YES;
    }
    
    for (UIView *butto in self.myTabBar.subviews)
    {
        if ([butto isKindOfClass:[UIButton class]])
        {
            UIButton *bu=(UIButton *)butto;
            bu.selected=NO;
        }
    }
    
    //把前一个选中的按钮置为不选中
//    _selButton.selected=NO;
    //把当前点击的按钮置为选中状态
    button.selected=YES;
    if (button.tag-100!=4)
    {
        //每次都要把记住前一个选中按钮
        _selButton=button;
    }
    
    //选中对应的控制器
    self.selectedIndex=button.tag-100;
    
    
}

#pragma mark-Delege

-(void)buttonSelect
{
    _btn.selected=YES;
    
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.2];
}

- (void)delay
{
    _btn.selected=NO;
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
