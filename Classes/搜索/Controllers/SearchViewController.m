//
//  SearchViewController.m
//  Original
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "SearchViewController.h"
#import "HttpreQuestManager.h"
#import "ProductListViewController.h"
#import "LocationViewController.h"
#import "FMDBmanager.h"


@interface SearchViewController ()<UITextFieldDelegate>

{
    NSMutableArray *_dataArray;
    int _count;
    int _count2;
    
    NSMutableArray *_SearchHistoryArray;
    
    UIView *grayView;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIView *remenSearchView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHeight;

@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (weak, nonatomic) IBOutlet UILabel *searchHistory;

@end

@implementation SearchViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _SearchHistoryArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getDataNet];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromBaese];
}


- (void)getDataFromBaese
{
    _SearchHistoryArray=[[NSMutableArray alloc]init];

    //从数据库读取数据
    FMDBmanager *manager = [FMDBmanager shareInstance];
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from SearchHistory"];
    while ([rs next])
    {
        [_SearchHistoryArray addObject:[rs stringForColumn:@"name"]];
    }
    
    if (_SearchHistoryArray.count==0)
    {
        self.searchHeight.constant=0;
        self.searchView.hidden=YES;
        
    }else
    {
    
        [self createBtn:_SearchHistoryArray];
    }
}

- (void)getDataNet
{
    self.textField.text=self.searchText;
    
    if (_SearchHistoryArray.count!=0)
    {
        self.cancelBtn.hidden=YES;
        self.searchHeight.constant=self.view.frame.size.height-64;
    }
    
    [[HttpreQuestManager shareInstance]getRecommendSearchKeySuccess:^(id responseObject) {
        
        [self createButton:responseObject];
     
    } failure:^(NSError *error) {
        
        
        grayView = [[UIView alloc]initWithFrame:self.view.bounds];
        grayView.backgroundColor = [UIColor grayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-110);
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"加载失败,点击屏幕重新加载" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [grayView addSubview:button];
        
        [self.view insertSubview:grayView atIndex:100];

        
        NSLog(@"获取热门搜索失败,error==%@",error);
    }];
}

- (void)click
{

    [grayView removeFromSuperview];
    [self getDataNet];
}


- (IBAction)city:(id)sender {
    UIButton *button=(UIButton *)sender;
    
    LocationViewController *locationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationVC.buttonName=button.currentTitle;
    [self.navigationController pushViewController:locationVC animated:YES];

}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)arrow:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        self.arrowWith.constant=15;
        self.arrowHeight.constant=17;
        self.arrowTrail.constant=21;
        self.arrowTop.constant=15;
        
        self.searchHeight.constant=self.view.frame.size.height-64;
        
    }else
    {
        self.arrowWith.constant=45;
        self.arrowHeight.constant=30;
        self.arrowTrail.constant=8;
        self.arrowTop.constant=8;
        
        self.searchHeight.constant=self.view.frame.size.height/2.5;
    }
}

- (IBAction)cancel:(id)sender {
    
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    if (![manager.basae executeUpdate:@"delete from SearchHistory "])
    {
        NSLog(@"删除失败");
    }
    
    self.searchHeight.constant=0;
    self.searchView.hidden=YES;
    
    [_SearchHistoryArray removeAllObjects];
}


//创建分类按钮
- (void)createButton:(NSArray *)listArray
{
    if (1)//判断是否是进来的第一次
    {
        int hang=0;//按钮创建在第几行
        
        for (int i=0; i<listArray.count; i++)
        {
            NSDictionary *dic=listArray[i];
            
            [_dataArray addObject:dic[@"param"][@"url"]];
            
            int j=[dic[@"query"] length];//取文字内容的长度
            
            _count+=10+j*20;//记录总长度,每个按钮隔10像素,每个文字是20像素
            
            hang=_count/self.view.frame.size.width;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            
            int x;//创建按钮的位置x
            
            //如果x位置小于摆设的长度,就把x=10,
            if ((int)_count%(int)(self.view.frame.size.width)<j*20+10)
            {
                x=10;
                if ((int)_count/(int)(self.view.frame.size.width)>0)
                {
                    _count=10+j*20+(int)_count/(int)(self.view.frame.size.width)*self.view.frame.size.width;
                    //如果是换行了就改变位置,并改变_count,
                }
                
            }else
            {
                //按钮位置要减去计算好的文字长度
                x=(int)_count%(int)(self.view.frame.size.width)-j*20;
            }
            //设置按钮的属性
            button.frame=CGRectMake(x,30*hang+55,20*j, 25);
            
            [button setTitle:dic[@"query"] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [button setTitleColor:[UIColor colorWithRed:157/255.0 green:202/255.0 blue:49/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall2.9.png"] forState:UIControlStateNormal];
           
            //打上tag
            button.tag=100+i;
          
            //添加事件
            [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_remenSearchView addSubview:button];
            
        }
       
//        //把_listViewHeight的约束更改
//        _listViewHeight.constant=30*(hang+1)+5;
//        //获取_listView的高度
//        _height=_listViewHeight.constant;
    }
    
    if (_SearchHistoryArray.count!=0)
    {
        [UIView transitionWithView:self.remenSearchView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            self.cancelBtn.hidden=NO;
            self.searchHeight.constant=self.view.frame.size.height/2.5;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

//创建分类按钮
- (void)createBtn:(NSArray *)listArray
{
    if (1)//判断是否是进来的第一次
    {
        self.searchHeight.constant=self.view.frame.size.height/2.5;
        self.searchView.hidden=NO;
        
        for (UIView *btn in _searchView.subviews)
        {
            if (btn!=self.cancelBtn&&btn!=self.arrow&&btn!=self.searchHistory)
            {
                [btn removeFromSuperview];
            }
        }
        
        _count2=0;
        
        int hang=0;//按钮创建在第几行
        
        for (int i=0; i<listArray.count; i++)
        {
            int j=[listArray[i] length];//取文字内容的长度
            
            _count2+=10+j*20;//记录总长度,每个按钮隔10像素,每个文字是20像素
            
            hang=_count2/self.view.frame.size.width;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            
            int x;//创建按钮的位置x
            
            //如果x位置小于摆设的长度,就把x=10,
            if ((int)_count2%(int)(self.view.frame.size.width)<j*20+10)
            {
                x=10;
                if ((int)_count2/(int)(self.view.frame.size.width)>0)
                {
                    _count2=10+j*20+(int)_count2/(int)(self.view.frame.size.width)*self.view.frame.size.width;
                    //如果是换行了就改变位置,并改变_count,
                }
                
            }else
            {
                //按钮位置要减去计算好的文字长度
                x=(int)_count2%(int)(self.view.frame.size.width)-j*20;
            }
            //设置按钮的属性
            button.frame=CGRectMake(x,30*hang+55,20*j, 25);
            
            [button setTitle:listArray[i] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [button setTitleColor:[UIColor colorWithRed:157/255.0 green:202/255.0 blue:49/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall2.9.png"] forState:UIControlStateNormal];
            
            //打上tag
            button.tag=100+i;
            
            //添加事件
            [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_searchView addSubview:button];
            
        }
        
        //        //把_listViewHeight的约束更改
        //        _listViewHeight.constant=30*(hang+1)+5;
        //        //获取_listView的高度
        //        _height=_listViewHeight.constant;
    }
    
}


//分类按钮事件
- (void)selectClick:(UIButton *)button
{

        FMDBmanager *manager=[FMDBmanager shareInstance];
        if (![manager.basae executeUpdate:@"delete from SearchHistory "])
        {
            NSLog(@"删除失败");
        }
        
        for (int i=0; i<_SearchHistoryArray.count; i++)
        {
            if ([_SearchHistoryArray[i] isEqualToString:button.currentTitle])
            {
                
                [_SearchHistoryArray removeObject:_SearchHistoryArray[i]];
                i-=1;
            }
            
        }
        
        
        
        [_SearchHistoryArray insertObject:button.currentTitle atIndex:0];
        //
        for (NSString *str in _SearchHistoryArray)
        {
            //插入数据
            
            if (![manager.basae executeUpdate:@"insert into SearchHistory(name) values (?)",str])
            {
                NSLog(@"插入失败");
            }
            
            
        }
    
    
    ProductListViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    
    if (button.superview==_searchView)
    {
        NSString *url=[[NSString stringWithFormat:@"http://www.benlai.com/IProductList/List?query=%@%%20",button.currentTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        listVC.c1SysNoUrl=url;

//        http://www.benlai.com/IProductList/List?query=%@
    }else
    {
        //如果是其他的就进入对应编号的刷新数据
        listVC.c1SysNoUrl=_dataArray[button.tag-100];
      
    }
    listVC.name=button.currentTitle;
    listVC.type=@"2";
    listVC.isSearch = YES;
    [self.navigationController pushViewController:listVC animated:YES];


}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)searchBtn:(id)sender {
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    if (![manager.basae executeUpdate:@"delete from SearchHistory "])
    {
        NSLog(@"删除失败");
    }
    
    for (int i=0; i<_SearchHistoryArray.count; i++)
    {
        if ([_SearchHistoryArray[i] isEqualToString:_textField.text])
        {
            
            [_SearchHistoryArray removeObject:_SearchHistoryArray[i]];
            i-=1;
        }
        
    }
    
    
    
    [_SearchHistoryArray insertObject:_textField.text atIndex:0];
    //
    for (NSString *str in _SearchHistoryArray)
    {
        //插入数据
        
        if (![manager.basae executeUpdate:@"insert into SearchHistory(name) values (?)",str])
        {
            NSLog(@"插入失败");
        }
        
        
    }
    
    ProductListViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    NSString *url=[[NSString stringWithFormat:@"http://www.benlai.com/IProductList/List?query=%@%%20",_textField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    listVC.c1SysNoUrl=url;
    listVC.type=@"2";
    listVC.isSearch = YES;
    listVC.name=_textField.text;
    [self.navigationController pushViewController:listVC animated:YES];

}

#pragma mark-UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        
        [self searchBtn:nil];
        
    }else
    {
        [textField resignFirstResponder];
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
