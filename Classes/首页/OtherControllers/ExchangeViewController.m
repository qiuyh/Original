//
//  ExchangeViewController.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "ExchangeViewController.h"
#import "QuartzCore/QuartzCore.h"


@interface ExchangeViewController ()<UITextFieldDelegate>

{
    NSArray *_identifyArray;//存储验证码
    
    CGFloat _rectHegiht;
}

@property (weak, nonatomic) IBOutlet UILabel *identifyinglabel;//验证码显示的label

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//卡号
@property (weak, nonatomic) IBOutlet UITextField *passewordTextField;//密码

@property (weak, nonatomic) IBOutlet UITextField *identifingTextField;//验证码

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _identifyArray=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                     @"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",
                     @"l",@"k",@"j",@"h",@"g",@"f",@"M",@"d",@"s",@"Q",
                     @"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"L",
                     @"K",@"J",@"H",@"G",@"F",@"D",@"S",@"A",@"Z",@"a",
                     @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"X",@"C",@"V",
                     @"B",@"N"];
    
    [self change];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{

    NSLog(@"userInfo==%@",noti.userInfo);
    
    //获取键盘的frame
    CGRect keboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    获取键盘动画时间
    CGFloat timeLength = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    if (_rectHegiht+keboardFrame.size.height>self.view.frame.size.height)
    {
        CGFloat height  = _rectHegiht+keboardFrame.size.height-self.view.frame.size.height;
        
        [UIView animateWithDuration:timeLength animations:^{
            
            self.bottomConstraint.constant = 100 + height;
            [self.view layoutIfNeeded];
        }];

    }
    
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSLog(@"userInfo==%@",noti.userInfo);
    
      //    获取键盘动画时间
    CGFloat timeLength = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    

    [UIView animateWithDuration:timeLength animations:^{
        
        self.bottomConstraint.constant = 100 ;
        [self.view layoutIfNeeded];
    }];
    

    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    _codeTextField.layer.cornerRadius=16;  // set color as you want.
    _codeTextField.layer.borderWidth = 0.1;
    
    
    _passewordTextField.layer.cornerRadius=16; // set color as you want.
    _passewordTextField.layer.borderWidth = 0.1;
    
    _identifingTextField.layer.cornerRadius=16; // set color as you want.
    _identifingTextField.layer.borderWidth = 0.1;
    

    self.tipLabel.hidden = YES;
    
    _rectHegiht  = 0.0;
    
}



//返回
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//刷新验证码按钮
- (IBAction)refresh:(id)sender {
    
    [self change];
}

//刷新验证码
- (void)change
{
    NSMutableString *str=[[NSMutableString alloc]init];
    for (int i=0;i<4; i++)
    {
        [str appendString:_identifyArray[arc4random()%62]];
    }
    self.identifyinglabel.text=str;//赋值
}
//触摸开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)sureBtn:(id)sender
{
    
    self.tipLabel.hidden = NO;
    
    if (_codeTextField.text.length==0)
    {
        self.tipLabel.text =  @"请输入礼品卡卡号!";
        
    }else if (_passewordTextField.text.length==0)
    {
        self.tipLabel.text =  @"请输入礼品卡密码!";
        
    }else if (_identifingTextField.text.length==0)
    {
        self.tipLabel.text =  @"请输入验证码!";
        
    }else if (![_identifingTextField.text isEqualToString:self.identifyinglabel.text])
    {
        self.tipLabel.text =  @"输入验证码不正确!";
    }else
    {
        self.tipLabel.text =  @"卡号不存在或者密码不正确!";
    }
    
    
}

#pragma mark-UITextFieldDelegate
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _codeTextField)
    {
        _rectHegiht = CGRectGetMaxY(_codeTextField.frame);
        
    }else if (textField == _passewordTextField)
    {
        _rectHegiht = CGRectGetMaxY(_passewordTextField.frame);
    
    }else if (textField == _identifingTextField)
    {
        _rectHegiht = CGRectGetMaxY(_identifingTextField.frame);
        
    }
    return YES;
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
