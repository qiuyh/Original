//
//  AnswerViewController.m
//  Original
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "AnswerViewController.h"
#import "NSString+Additions.h"

@interface AnswerViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *answer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labeHeight;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text=self.questionContent;
    self.question.text=self.questionContent;
    self.answer.text=self.answerContent;
    
    CGSize rect = [NSString getContentSize:self.answerContent fontOfSize:14 maxSizeMake:CGSizeMake(self.answer.frame.size.width, 100000)];
    
    self.imgHeight.constant  = 1.4*rect.height;
    self.labeHeight.constant = 1.2*rect.height;

    
}



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
