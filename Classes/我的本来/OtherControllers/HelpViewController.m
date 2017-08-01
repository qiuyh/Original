//
//  HelpViewController.m
//  Original
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "HelpViewController.h"
#import "HttpreQuestManager.h"
#import "SetCell.h"
#import "AnswerViewController.h"

@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_reqArray;
    NSMutableArray *_ansArray;
    UIView *grayView;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation HelpViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _reqArray=[NSMutableArray array];
        _ansArray=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getDataFromNet];
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getDataFromNet
{
    self.myTableView.rowHeight=60;
    
    [[HttpreQuestManager shareInstance]getHelpSuccess:^(id responseObject) {
        
        NSLog(@"Help-responseObject==%@",responseObject);
        
        
        for (NSDictionary *dic in responseObject)
        {
            [_reqArray addObject:dic[@"QuestionContent"]];
            [_ansArray addObject:dic[@"AnswerContent"]];
        }
        
        [self.myTableView reloadData];
        
        
        
    } failure:^(NSError *error) {
        
        grayView = [[UIView alloc]initWithFrame:self.view.bounds];
//        grayView.backgroundColor = [UIColor grayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-110);
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"加载失败,点击屏幕重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [grayView addSubview:button];
        
        [self.view insertSubview:grayView atIndex:100];

        
        NSLog(@"获取帮助失败,errror==%@",error);
        
    }];
}

- (void)click
{
    [grayView removeFromSuperview];
    [self getDataFromNet];
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
    return _reqArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text=_reqArray[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerViewController *answerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AnswerViewController"];
    
    answerVC.questionContent=_reqArray[indexPath.row];
    answerVC.answerContent=_ansArray[indexPath.row];
//    NSLog(@"%@",answerVC.answerContent);
    [self.navigationController pushViewController:answerVC animated:YES];
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
