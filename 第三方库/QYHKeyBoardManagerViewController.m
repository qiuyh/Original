//
//  ViewController.m
//  QYHKeyBoardManager
//
//  Created by 邱永槐 on 16/4/3.
//  Copyright © 2016年 YongHuaiQIu. All rights reserved.
//

#import "QYHKeyBoardManagerViewController.h"

@interface QYHKeyBoardManagerViewController ()

@property (nonatomic,assign) CGFloat    textFieldY;
@property (nonatomic,assign) CGRect     oldFrame;


@end

@implementation QYHKeyBoardManagerViewController

+(instancetype)shareInstance
{
    static QYHKeyBoardManagerViewController *manager=nil;

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager=[[QYHKeyBoardManagerViewController alloc]init];

    });

    
    return manager;

}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //监听键盘抬起
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        //键盘键盘掉下
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

#pragma mark 监听键盘事件
- (void)KeyboardWillShow:(NSNotification *)noti
{
    
    //获取键盘的frame
    CGRect keboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘动画时间
    CGFloat timeLength  = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //如果键盘没遮盖就不上移
    if (_textFieldY < keboardFrame.origin.y)
    {
        return;
    }
    
    NSLog(@"_textFieldY==%f",_textFieldY);
    
    CGRect rect   = self.selfView.frame;
    //偏移值+50
    rect.origin.y = - ( _textFieldY - keboardFrame.origin.y + 50);
    
    //如果偏移值大于键盘的高度就只偏于键盘的高度
    if (-rect.origin.y > keboardFrame.size.height)
    {
        rect.origin.y = -keboardFrame.size.height;
    }
    
    self.selfView.frame = rect;
    
    //设置Text的动画
    [UIView animateWithDuration:timeLength animations:^{
        
        //注意这里不是改变值，之前已经改变值了，
        //在这里需要做的事强制布局
        [self.selfView layoutIfNeeded];
        
    }];
    
}

- (void)KeyboardWillHide:(NSNotification *)noti
{
    //获取键盘动画时间
    CGFloat timeLength = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //还原原来的frame
    self.selfView.frame = _oldFrame;
    
    //设置Text的动画
    [UIView animateWithDuration:timeLength animations:^{
        
        //注意这里不是改变值，之前已经改变值了，
        //在这里需要做的事强制布局
        [self.selfView layoutIfNeeded];
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


//实现通知方法
- (void) textChange:(NSNotification *)notification{
    
    
//    NSLog(@"notification==%@",notification.object);
    
    
    if ([[notification object] isKindOfClass:[UITextField class]])
    {
        UITextField *textField = [notification object];
        
        [self convertRectFromView:textField oldFrame:textField.frame];
        
    }else
    {
        UITextView *textView = [notification object];
        
        [self convertRectFromView:textView oldFrame:textView.frame];
    }
    
    
}


#pragma mark 重写set方法
-(void)setSelfView:(UIView *)selfView
{
    _selfView = selfView;
    
    _oldFrame = self.selfView.frame;
    
//    [self findSubView:selfView];
    
    //添加键盘掉落事件(针对UIScrollView或者继承UIScrollView的界面)
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_selfView addGestureRecognizer:tapGestureRecognizer];
   
    //设置通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (textChange:)name:UITextFieldTextDidBeginEditingNotification object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (textChange:)name:UITextViewTextDidBeginEditingNotification object:nil];
}


#pragma mark 递归方法--
//把textFiled和textView的delegate设为当前的控制器
//-(void)findSubView:(UIView*)view
//{
//    for (UIView *subView in view.subviews)
//    {
//        
//        if ([subView isKindOfClass:[UITextField class]])
//        {
//            UITextField *textFiled = (UITextField *)subView;
//            textFiled.delegate =(id) self;
//            
//        }else if ([subView isKindOfClass:[UITextView class]])
//        {
//            UITextView *textView = (UITextView *)subView;
//            textView.delegate =(id) self;
//        }
//        
//        [self findSubView:subView];
//    }
//    
//}

//取得textFiled和textView在_selfView的位置frame
- (void)convertRectFromView:(UIView *)view oldFrame:(CGRect)oldFrame
{
    
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:oldFrame fromView:[view superview]];
    
    _textFieldY = CGRectGetMaxY(rect);
    
}


#pragma mark 触摸其他地方掉下键盘

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.selfView endEditing:YES];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.selfView endEditing:YES];
}


//#pragma mark textFieldDelage
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    [self convertRectFromView:textField oldFrame:textField.frame];
//    
//    return YES;
//}
//
//#pragma mark textViewDelage
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//
////    [self convertRectFromView:textView oldFrame:textView.frame];
//    
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
