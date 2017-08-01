//
//  LocationViewController.m
//  Original
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "LocationViewController.h"
#import "HttpreQuestManager.h"
#import "GroupAreaModel.h"
#import "CityModel.h"


@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    NSMutableArray *_dataArray;
    NSMutableArray *_hotListArray;
    
    CGPoint _beginPoint;
    CGPoint _endPoint;
    
    BOOL _isTop;
    
  
    
    BOOL _isSearch;
    NSMutableArray *_searchArray;
    NSString *_searchTitle;
  
}

@property (weak, nonatomic) IBOutlet UIView *hotCityView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UIView *viewTable;
@property (weak, nonatomic) IBOutlet UIButton *suggestCity;

@property (weak, nonatomic) IBOutlet UITextField *search;

@end

@implementation LocationViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _hotListArray=[[NSMutableArray alloc]init];
        _searchArray=[[NSMutableArray alloc]init];
        
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"city" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取定位信息
    [self getSityData];
    
//    _myTableView.canCancelContentTouches = NO;//是否可以中断touches
//    
//    
//    _myTableView.delaysContentTouches = NO;//是否延迟touches事件
    
    
}


- (void)cityName:(NSNotification *)info
{
    [_suggestCity setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
    [_cityName setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
}


-(void)viewWillAppear:(BOOL)animated
{
    _myTableView.scrollEnabled=NO;
    _myTableView.bounces  = YES;
//    _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.cityName setTitle:self.buttonName forState:UIControlStateNormal];
  
}


- (void)getSityData
{
    [self.suggestCity setTitle:self.suggestCityName forState:UIControlStateNormal];
    
    [[HttpreQuestManager shareInstance]getSiteListSuccess:^(id responseObject) {
        
        for (NSDictionary *dic in responseObject[@"hotlist"])
        {
            CityModel *model=[[CityModel alloc]init];
            model.cityName=dic[@"cityName"];
            model.cityNo=dic[@"cityNo"];
            [_hotListArray addObject:model];
        }
        
        [self createHotCityButton];
        
        for (NSDictionary *dic1 in responseObject[@"list"])
        {
            GroupAreaModel *group=[[GroupAreaModel alloc]init];
            group.areaName=dic1[@"areaName"];
            for (NSDictionary *dic2 in dic1[@"city"])
            {
                CityModel *model=[[CityModel alloc]init];
                model.cityName=dic2[@"cityName"];
                model.cityNo=[dic2[@"cityNo"] stringValue];
                [group.cityArray addObject:model];
            }
            
            [_dataArray addObject:group];
        }
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"获取定位信息失败,error==%@",error);
    }];
}


- (void)createHotCityButton
{
    for (int i=0; i<_hotListArray.count; i++)
    {
        CityModel *model=_hotListArray[i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+i%6*45, 70+30*(i/6), 30, 30);
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithRed:157/255.0 green:202/255.0 blue:50/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithRed:157/255.0 green:202/255.0 blue:50/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitle:model.cityName forState:UIControlStateNormal];
        button.tag=100+i;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotCityView addSubview:button];
    }
    
    [self.hotCityView bringSubviewToFront:_myTableView];
    [self.hotCityView bringSubviewToFront:self.viewTable];
}

- (IBAction)clickBtn:(id)sender {
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:@{@"cityName":self.suggestCity.currentTitle}];
    
    [UserStorage shareInstance].cityName  = self.suggestCity.currentTitle;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)click:(UIButton *)button
{
    CityModel *model=_hotListArray[button.tag-100];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:@{@"cityName":model.cityName,@"cityNo":model.cityNo}];
//    
    [UserStorage shareInstance].cityName  = model.cityName;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchBtn:(id)sender {
    
    
    if ([_search.text isEqualToString:@""])
    {
        _isSearch=NO;
        
        [_myTableView reloadData];
        
        return;

    }

    
    for (GroupAreaModel *group in _dataArray)
    {
        for (CityModel *model in group.cityArray)
        {
            if ([group.areaName.lowercaseString rangeOfString:[_search.text substringToIndex:1]].location != NSNotFound||[group.areaName rangeOfString:[_search.text substringToIndex:1]].location != NSNotFound)
            {
                _isSearch=YES;
                _searchTitle=group.areaName;
                [_searchArray addObject:model.cityName];
            }
            
            if ([model.cityName rangeOfString:_search.text].location != NSNotFound)
            {
                _isSearch=YES;
                _searchTitle=group.areaName;
                [_searchArray addObject:model.cityName];
            }
        }
    }
    
    
    if (_isSearch)
    {
        _isTop=YES;
        self.viewTable.hidden=YES;
        _myTableView.scrollEnabled=YES;
        [UIView animateWithDuration:0.5 animations:^{
            _myTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.hotCityView.frame.size.height);
        }];
        
        [_myTableView reloadData];
        
    }else
    {
        [QYHProgressHUD showErrorHUD:nil message:@"该城市尚未开通！"];
    }

}


#pragma mark -UITableViewDataSource&UITableViewDelegate
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch)
    {
        return 1;
    }else
    {
    //数据源有多少个元素,就返回多少
    return _dataArray.count;
    }
}
//返回对应组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch)
    {
        return _searchArray.count;
    }else
    {
    GroupAreaModel *model=_dataArray[section];
    //返回小数组个数
    return model.cityArray.count;
    }
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_isSearch)
    {
        cell.textLabel.text=_searchArray[indexPath.row];
    }else
    {
     GroupAreaModel *model1=_dataArray[indexPath.section];
    CityModel *model2=model1.cityArray[indexPath.row];
    cell.textLabel.text=model2.cityName;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch)
    {
        return _searchTitle;
    }else
    {
    GroupAreaModel *model=_dataArray[section];
 
    return model.areaName;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:@{@"cityName":_searchArray[indexPath.row],@"cityNo":@"ve"}];
    }else
    {
    GroupAreaModel *model1=_dataArray[indexPath.section];
    CityModel *model2=model1.cityArray[indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:@{@"cityName":model2.cityName,@"cityNo":model2.cityNo}];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touc=[touches anyObject];
    _beginPoint=[touc locationInView:self.view];
//    _beginPoint=[touc locationInView:self.viewTable];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touc=[touches anyObject];
    _endPoint=[touc locationInView:self.view];
//    _endPoint=[touc locationInView:self.viewTable];
    
    
    if (!_isTop)
    {
        if (_beginPoint.y-_endPoint.y>100)
        {
            _isTop=YES;
            self.viewTable.hidden=YES;
            [UIView animateWithDuration:0.5 animations:^{
                _myTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.hotCityView.frame.size.height);
            }];
            _myTableView.scrollEnabled=YES;
        }else
        {
            [UIView animateWithDuration:0.5 animations:^{
                _myTableView.frame=CGRectMake(0, 210, self.view.frame.size.width, self.hotCityView.frame.size.height);
            }];
            _viewTable.frame=CGRectMake(0, 210, self.view.frame.size.width, self.hotCityView.frame.size.height);
            _myTableView.scrollEnabled=NO;
        }

    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touc=[touches anyObject];
    CGPoint p=[touc locationInView:self.view];
//    CGPoint p=[touc locationInView:self.viewTable];
//    NSLog(@"%f",p.y);
    if(!_isTop&&_beginPoint.y-p.y>0&&_beginPoint.y-p.y<210)
    {
   
        _myTableView.frame=CGRectMake(0,210-(_beginPoint.y-p.y), self.view.frame.size.width, self.hotCityView.frame.size.height);
        _myTableView.scrollEnabled=NO;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%F",_myTableView.contentOffset.y);
    if (_myTableView.contentOffset.y<=0)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            _myTableView.frame=CGRectMake(0, 210, self.view.frame.size.width, self.hotCityView.frame.size.height);
        }];
        _viewTable.frame=CGRectMake(0, 210, self.view.frame.size.width, self.hotCityView.frame.size.height);
        _myTableView.scrollEnabled=NO;

        
        self.viewTable.hidden=NO;
        _isTop=NO;
        
    }else
    {
        self.viewTable.hidden=YES;
        _isTop=YES;
    }

}


#pragma mark-UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtn:nil];
    
    [textField resignFirstResponder];
    
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [self searchBtn:nil];
//    
////    [textField resignFirstResponder];
//    
//    return YES;
//}


//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    _myTableView.sectionIndexColor=[UIColor darkGrayColor];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    tableView.sectionIndexColor = [UIColor blueColor];   //可以改变字体的颜色
    
//    tableView.sectionIndexBackgroundColor = [UIColor greenColor];  //可以改变索引背景色
    
    
    //返回A-Z
    for (int i = 'A'; i<='Z'; i++)
    {
        if (!(i=='I'||i=='O'||i=='U'||i=='V'))
        {
            //将ascII转字符串
            NSString *str = [NSString stringWithFormat:@"%c",i];
            [array addObject:str];
        }

    }
    
    [array addObject:@"#"];
    
    //索引是和组数对应的.
    //如果索引个数大于组的个数,那么后面的索引无效.
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //传入 section title 和index 返回其应该对应的session序号。
    //一般不需要写 默认section index 顺序与section对应。除非 你的section index数量或者序列与section不同才用修改
    return index;
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
