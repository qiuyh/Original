//
//  MainViewController.m
//  Original
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "MainViewController.h"
#import "HttpreQuestManager.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "CustomCell1.h"
#import "CustomCell2.h"
#import "CustomCell3.h"
#import "CustomCell4.h"
#import "MainHome.h"
#import "LotType.h"
#import "DetailViewController.h"
#import "SubjectViewController.h"
#import "HotViewController.h"
#import "PhoneViewController.h"
#import "GiftViewController.h"
#import "MyoderViewController1.h"
#import "TabBarController.h"
#import "LocationViewController.h"
#import "SearchViewController.h"
#import "ProductListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UserStorage.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "QYHProgressHUD.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface MainViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,Delege,CLLocationManagerDelegate>

{
    NSMutableArray *_countArray;//存放广告图片
    NSMutableArray *_valueArray;//存放广告图片对应的网址
    NSMutableArray *_typeArray;
    UIScrollView *_scrollView;//
    UIPageControl *_pageContr;//
    
    __block NSTimer *_timer;//定时器
    int _count;//计算滑动第几张广告图片
    
    NSMutableArray *_mainArray;//数据源,存储主页的数据
   
    UIButton *cityButton;
      UILabel *_label;
    UITextField *_search;
    
    CLLocationManager* _locationManager;
    NSString *_locationCityName;
    
//    MJRefreshHeaderView *_headView;//
    
    UIView *grayView;
    
    BOOL isOne;
    
    BOOL isBig;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation MainViewController
//初始化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _countArray=[[NSMutableArray alloc]init];
        _valueArray=[[NSMutableArray alloc]init];
        _mainArray=[[NSMutableArray alloc]init];
        _typeArray=[[NSMutableArray alloc]init];
        
        isBig = NO;
        
//         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(city:) name:@"city" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加导航栏的控件
    [self addNAVView];
    //获取广告图片并实现滑动
    [self getPageFromNet];
    //ScrollView和PageControl的初始化
    [self initScrollAndPageControl];
    //从网络获取主页的信息图片
    [self getMainImage];
    
    [self startLocation];
    
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [weakSelf getPageFromNet];
        
        //从网络获取主页的信息图片
        [weakSelf getMainImage];
        
        if (_locationCityName == nil)
        {
            [weakSelf startLocation];
        }

        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myTableView.mj_header endRefreshing];
        
    }];
    
    // 马上进入刷新状态
//    [self.myTableView.mj_header beginRefreshing];

//    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    
    grayView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:grayView atIndex:100];
    

    [[GetStatusStorage shareInstance]getSatueSSEBaseUser];
    
    
    NSUserDefaults *accountPassword     = [NSUserDefaults standardUserDefaults];
    [UserStorage shareInstance].account = [accountPassword objectForKey:@"account"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (!isBig)
    {
         NSLog(@"1113333");
        
        UIImageView *bigImgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        
        bigImgView.image = [UIImage imageNamed:@"big.jpg"];
        
        [[UIApplication sharedApplication].keyWindow addSubview:bigImgView];
        
        [UIView animateWithDuration:5.0 animations:^{
            
            isBig = YES;
            bigImgView.frame = CGRectMake(-150, -self.view.frame.size.height*1.0/self.view.frame.size.width*150, self.view.frame.size.width+150*2, self.view.frame.size.width+(self.view.frame.size.height*1.0/self.view.frame.size.width*150)*2);
            
            bigImgView.alpha = 0.8;
            
        } completion:^(BOOL finished) {
            
            
            [bigImgView removeFromSuperview];
        }];
        
    }
    
    NSLog(@"3333");
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=NO;
    
    
    [cityButton setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];

    
    if (!_timer)
    {
        _timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollViewTo) userInfo:nil repeats:YES];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:YES];
    
    //销毁定时器
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer=nil;
    }

}


//开始定位
-(void)startLocation
{
    _locationManager=[[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=10;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        //支持永久定位
        [_locationManager requestAlwaysAuthorization];
        
    }
    
    [_locationManager startUpdatingLocation];//开启定位
    
    
    
}

//定位代理经纬度回调
// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             //             cityName = city;
//                          NSLog(@"定位完成:%@",city);
             city=[city substringToIndex:2 ];
             _locationCityName=city;
             
             
             
             UserStorage *userManager  = [UserStorage shareInstance];
             
             userManager.cityName        = city;
             userManager.suggestCityName = city;
             
             if (!isOne)
             {
//                 [QYHProgressHUD showHUDInView:nil onlyMessage:city];
                 
                 isOne  = YES;
             }
             
             
             NSLog(@"city==%@",city);

             [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:city];

             [cityButton setTitle:city forState:UIControlStateNormal];
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code ==kCLErrorDenied)
    {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"%ld",(long)error.code);
    }
}





//创建label(提示作用)
- (void)createLabel:(NSString *)title
{
    [_label removeFromSuperview];//先把原来的删除
    _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.5, self.view.frame.size.height-130, 70, 35)];
    _label.backgroundColor=[UIColor blackColor];
    _label.textAlignment=NSTextAlignmentCenter;
    //设置圆角度和边框
    _label.layer.borderWidth = 0.5f;
    _label.layer.masksToBounds = YES;
    
    _label.textColor=[UIColor whiteColor];
    _label.shadowColor=[UIColor whiteColor];
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



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

//从网络获取主页的信息图片
- (void)getMainImage
{
    if (isBig)
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    HttpreQuestManager *manager=[HttpreQuestManager shareInstance];
    [manager GetAPPHomePage:2 success:^(id responseObject) {
        
        grayView.hidden = YES;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
        [_mainArray removeAllObjects];
        
//        NSLog(@"responseObject==%@",responseObject);
        //先添加一个空的对象,因为第一个cell是不用动态修改的,是静态的
        [_mainArray addObject:@""];
        
        for (NSDictionary *dic in responseObject)
        {
            LotType *typeModel=[[LotType alloc]init];
            typeModel.lotType=[dic[@"lotType"] stringValue];
            
            for (NSDictionary *dic1 in dic[@"list"])
            {
//               取到模型
                MainHome *model=[[MainHome alloc]init];
                model.img=dic1[@"img"];
                model.value=dic1[@"value"];
                model.type=[dic1[@"type"] stringValue];
                
                //存储模型
                [typeModel.typeArray addObject:model];
            }
            
            [_mainArray addObject:typeModel];
            
            //刷新表
            [_myTableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
        grayView.hidden = NO;

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
       
//        grayView.backgroundColor = [UIColor grayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-110);
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"加载失败,点击屏幕重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [grayView addSubview:button];
     

        
        NSLog(@"获取首页图片失败,error==%@",error);
        
    }];
    
}

- (void)click
{
    grayView.hidden = YES;

    [grayView removeFromSuperview];
    
    [self getMainImage];
    [self getPageFromNet];
}


//获取广告图片
- (void)getPageFromNet
{
    
    HttpreQuestManager *manager=[HttpreQuestManager shareInstance];
    [manager GetAPPHomePage:1 success:^(id responseObject) {
        
        grayView.hidden = YES;

        
        [_countArray removeAllObjects];
        [_valueArray removeAllObjects];
        [_typeArray removeAllObjects];
        
        NSArray *listArray=[responseObject firstObject][@"list"];
        
        [_countArray addObject:@""];
        for (NSDictionary *dic in listArray)
        {
            NSString *img=dic[@"img"];
            NSString *urlValue=dic[@"value"];
          
//            NSLog(@"%@",img);
            [_countArray addObject:img];
            [_valueArray addObject:urlValue];
            [_typeArray addObject:[dic[@"type"] stringValue]];
        }
        [_countArray addObject:@""];
        
        //滑动广告图片
        [self adverScroll];
        
    } failure:^(NSError *error) {
        
        grayView.hidden = NO;

        NSLog(@"获取广告图片失败,error==%@",error);
        
    }];
    
    
    [manager getSearchKeySuccess:^(id responseObject) {
        
        _search.placeholder=responseObject;
        
    } failure:^(NSError *error) {
        
        grayView.hidden = NO;
        
      
         NSLog(@"获取搜索关键词失败,error==%@",error);
    }];
    
 
}
//ScrollAndPageControl的初始化
- (void)initScrollAndPageControl
{
    //新建一个View,放scrollView和pageContr
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2.0)];
    
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2.0)];
    _scrollView.showsHorizontalScrollIndicator=NO;
   //设置代理
    _scrollView.delegate=self;
    //打开页
    _scrollView.pagingEnabled=YES;

    
    //
    _pageContr=[[UIPageControl alloc]initWithFrame:CGRectMake(0.0, view.frame.size.height-10,self.view.frame.size.width, 0.0)];
    _pageContr.currentPage=0;
    _pageContr.pageIndicatorTintColor=[UIColor darkGrayColor];
    _pageContr.currentPageIndicatorTintColor=[UIColor purpleColor];
    
    [view addSubview:_scrollView];
    [view addSubview:_pageContr];
    [view sendSubviewToBack:_scrollView];
    //把View设给tableHeaderView
    _myTableView.tableHeaderView=view;
    
}

//广告滑动
- (void)adverScroll
{
    //设置scrollView的包含的内容大小
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*_countArray.count, 0);
    
    _pageContr.numberOfPages = _countArray.count-2;
    _pageContr.currentPage   = 0;
    //通过前后各加多一张来,解决晃一下的问题
    for (int i=0; i<_countArray.count; i++)
    {
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        //如果是第一显示第6张的图片
        if (i ==0)
        {
            [imgView setImageWithURL:[NSURL URLWithString:_countArray[_countArray.count-2]]placeholderImage:[UIImage imageNamed:@"place_holder_50.png"]];
            //添加tag
            imgView.tag=100+_countArray.count-3;
        }else if(i==_countArray.count-1)//如果是第八就显示第一张图片
        {
            [imgView setImageWithURL:[NSURL URLWithString:_countArray[1]]placeholderImage:[UIImage imageNamed:@"place_holder_50.png"]];
            //添加tag
            imgView.tag=100+0;
        }else
        {
            [imgView setImageWithURL:[NSURL URLWithString:_countArray[i]]placeholderImage:[UIImage imageNamed:@"place_holder_50.png"]];
            //添加tag
            imgView.tag=100+i-1;
        }
        
       
        //打开手势
//        _scrollView.userInteractionEnabled=YES;
        imgView.userInteractionEnabled=YES;
        //点击事件
        
        [_scrollView addSubview:imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imgView addGestureRecognizer:tap];


        //
        _count=1;
        [_scrollView setContentOffset:CGPointMake(_count*_scrollView.frame.size.width, 0) animated:YES];
        
    }
    
    if (!_timer)
    {
         _timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollViewTo) userInfo:nil repeats:YES];
    }

}

//定时器事件滑动
- (void)scrollViewTo
{
    _count++;
    if (_count==_countArray.count-1)
    {
        _count = 1;
        //瞬间回到起点,解决晃一下的问题
        _scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //pageContr的当前页等于count-1
    _pageContr.currentPage=_count-1;
    
    [_scrollView setContentOffset:CGPointMake(_count*_scrollView.frame.size.width, 0) animated:YES];
    
    
}

//手势点击事件
- (void)tap:(UIGestureRecognizer *)tap
{
    //销毁定时器
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer=nil;
    }
   

    if ([_typeArray[tap.view.tag-100] isEqualToString:@"6"])
    {
        WebViewController *webVC=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        NSLog(@"url == %@",_valueArray[tap.view.tag-100]);
        webVC.url=_valueArray[tap.view.tag-100];
  
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([_typeArray[tap.view.tag-100] isEqualToString:@"3"])
    {
        SubjectViewController *subject=[self.storyboard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
        subject.sysNo=_valueArray[tap.view.tag-100];
        [self.navigationController pushViewController:subject animated:YES];
    }else
    {
        DetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detail.productSysNo=_valueArray[tap.view.tag-100];
        [self presentViewController:detail animated:NO completion:nil];
//        [self.navigationController pushViewController:detail animated:YES];
    }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}


//在导航栏上添加一个View
- (void)addNAVView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
//    titleView.alpha=6.0;
//    titleView.backgroundColor=[UIColor colorWithRed:221/255.0 green:202/255.0 blue:214/255.0 alpha:1.0];
    //添加输入框作为所搜框
    _search=[[UITextField alloc]initWithFrame:CGRectMake(70, 0, titleView.frame.size.width-110, 35)];
//    _search.placeholder=@"中秋月饼";
    _search.textAlignment=NSTextAlignmentCenter;
    _search.font=[UIFont systemFontOfSize:15];
    _search.delegate=self;
    
    [titleView addSubview:_search];

    [self addBackgroudSearch:titleView search:_search];
    [self addSearchButton:titleView search:_search];
    [self addCityButton:titleView search:_search];
    [self addBen:titleView];
    
    [self.view addSubview:titleView];
//    [self.navigationItem.titleView sizeToFit];
////
//    self.navigationItem.titleView = titleView;
    
}

//添加背景,线框
- (void)addBackgroudSearch:(UIView *)titleView search:(UITextField *)search
{
    UIImageView *imageSearchbar=[[UIImageView alloc]initWithFrame:CGRectMake(67, 17, search.frame.size.width+6, 18)];
    imageSearchbar.image=[UIImage imageNamed:@"home_searchbar.9.png"];
    
    [titleView addSubview:imageSearchbar];

}
//添加搜索按钮
- (void)addSearchButton:(UIView *)titleView search:(UITextField *)search
{
    UIButton *searchButton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame=CGRectMake(search.frame.size.width+70-18, 8, 18,18);
    [searchButton setImage:[UIImage imageNamed:@"home_search_icon.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"home_search_icon.png"] forState:UIControlStateHighlighted];

    
    UIButton *searchButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton1.frame=CGRectMake(search.frame.size.width+70-30, 8, 30,30);
    searchButton1.backgroundColor = [UIColor clearColor];
    
    [searchButton1 addTarget:self action:@selector(pushToSearch) forControlEvents:UIControlEventTouchUpInside];

    
    [titleView addSubview:searchButton];
    [titleView addSubview:searchButton1];

}

- (void)pushToSearch
{
    ProductListViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    NSString *url=[[NSString stringWithFormat:@"http://www.benlai.com/IProductList/List?query=%@%%20",_search.placeholder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    listVC.c1SysNoUrl=url;
    listVC.type=@"2";
    listVC.name=_search.placeholder;
    [self.navigationController pushViewController:listVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    

}

//添加定位按钮
- (void)addCityButton:(UIView *)titleView search:(UITextField *)search
{
    cityButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame=CGRectMake(5, 8,60,21);
    //设置正常状态
    [cityButton setImage:[UIImage imageNamed:@"city1.png"] forState:UIControlStateNormal];
    //设置高亮状态
    [cityButton setImage:[UIImage imageNamed:@"city1.png"] forState:UIControlStateHighlighted];
    
//    [cityButton setTitle:@"深圳" forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cityButton.titleLabel.font=[UIFont systemFontOfSize:15];
    //设置内偏移量
    cityButton.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
    cityButton.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    cityButton.imageEdgeInsets=UIEdgeInsetsMake(-20,5,-15, 5);
    
    [cityButton addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:cityButton];
}

- (void)location:(UIButton *)button
{
    LocationViewController *locationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationVC.buttonName=button.currentTitle;
    locationVC.suggestCityName=[UserStorage shareInstance].suggestCityName;
    [self.navigationController pushViewController:locationVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;

}

//添加图标本
- (void)addBen:(UIView *)titleView
{
    UIImageView *ben=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, 8, 25, 25)];
    ben.image=[UIImage imageNamed:@"help_answer_.png"];
    
    [titleView addSubview:ben];
}


#pragma mark-UITextFieldDelegate
//不允许编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     NSLog(@"11111111111");
    SearchViewController *searchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchVC.searchText=textField.placeholder;

    [self.navigationController pushViewController:searchVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
    return NO;
}

#pragma mark-UIScrollViewDelegate
//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_timer isValid])
    {
        //销毁定时器
        [_timer invalidate];
        _timer=nil;
    }
    
}
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != _myTableView)
    {
        //通过偏移量来定当前的页数
        _count=scrollView.contentOffset.x/scrollView.frame.size.width;
        //如果是第8张图片,跳转到第2张
        if (_count==_countArray.count-1)
        {
            _count=1;
            
        }
        //如果是第1张图片,就跳转到7张
        if (_count==0)
        {
            _count=_countArray.count-2;
            
        }
        
        _scrollView.contentOffset=CGPointMake(scrollView.frame.size.width*_count, 0);
        //设置pageContr的当前页数
        _pageContr.currentPage=_count-1;

    }
    
    
    if (!_timer)
    {
        //重新开始定时器
        _timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollViewTo) userInfo:nil repeats:YES];
    }
    
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
    return _mainArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是第一个cell就不改变
    if (indexPath.row==0)
    {
        CustomCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell1"];
        
//        _myTableView.rowHeight=90;
        
        cell.myDelege=self;
        
        return cell;
    }else//如果是其他就判断
    {
        LotType *model=_mainArray[indexPath.row];
        //如果类型属于2的返回对应的cell,并改变数据,刷新UI
        if ([model.lotType isEqualToString:@"2"])
        {
            CustomCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell3"];
            
//            _myTableView.rowHeight=160;
            
            MainHome *imgModel=model.typeArray[0];
            [cell.imgView1 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_2.png"]];
            
            cell.imgView1.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView1.tag=100+indexPath.row;
            UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView1 addGestureRecognizer:tap1];
            
            imgModel=model.typeArray[1];
            [cell.imgView2 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_2.png"]];
            
            cell.imgView2.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView2.tag=1000+indexPath.row;
            UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView2 addGestureRecognizer:tap2];
            
            imgModel=model.typeArray[2];
            [cell.imgView3 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_2.png"]];
            
            cell.imgView3.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView3.tag=10000+indexPath.row;
            UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView3 addGestureRecognizer:tap3];
            

            
            return cell;
        }
        else if ([model.lotType isEqualToString:@"3"])
        { //如果类型属于3的返回对应的cell,并改变数据,刷新UI
            CustomCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell2"];
            
//            _myTableView.rowHeight=160;
            
            MainHome *imgModel=model.typeArray[0];
            [cell.imgView setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_50.png"]];
            
            cell.imgView.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView.tag=100+indexPath.row;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView addGestureRecognizer:tap];

            
            return cell;

        }
        else
        {
             //如果类型属于4的返回对应的cell,并改变数据,刷新UI
            CustomCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell4"];
            
//            _myTableView.rowHeight=160;
            
            MainHome *imgModel=model.typeArray[0];
            [cell.imgView1 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_4l.png"]];
            
            cell.imgView1.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView1.tag=100+indexPath.row;
            UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView1 addGestureRecognizer:tap1];
            
            imgModel=model.typeArray[1];
            [cell.imgView2 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_4l.png"]];
            
            cell.imgView2.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView2.tag=1000+indexPath.row;
            UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView2 addGestureRecognizer:tap2];
            
            imgModel=model.typeArray[2];
            [cell.imgView3 setImageWithURL:[NSURL URLWithString:imgModel.img]placeholderImage:[UIImage imageNamed:@"place_holder_4r.png"]];
            
            cell.imgView3.userInteractionEnabled=YES;
            cell.contentView.userInteractionEnabled=YES;
            cell.imgView3.tag=10000+indexPath.row;
            UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push:)];
            
            [cell.imgView3 addGestureRecognizer:tap3];

            
            return cell;

        }
        
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 90;
    }else
    {
        return self.view.frame.size.width/2.0;
    }
}


- (void)push:(UITapGestureRecognizer *)tap
{
    int i=1110;
    
    LotType *model=nil;
    
    if (tap.view.tag-100<100)
    {
        model=_mainArray[tap.view.tag-100];
        i=0;
    }else if(tap.view.tag-100<1000&&tap.view.tag-100>100)
    {
        model=_mainArray[tap.view.tag-1000];
        i=1;
    }else
    {
        model=_mainArray[tap.view.tag-10000];
        i=2;
    }

    MainHome *imgModel=model.typeArray[i];
   
    if ([imgModel.type isEqualToString:@"1"])
        {
            DetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            detail.productSysNo=imgModel.value;
           
            [self presentViewController:detail animated:NO completion:nil];
//            [self.navigationController pushViewController:detail animated:YES];
            
        }else if ([imgModel.type isEqualToString:@"3"])
        {
            SubjectViewController *subject=[self.storyboard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
            subject.sysNo=imgModel.value;
            [self.navigationController pushViewController:subject animated:YES];
            
        }else
        {
            WebViewController *webVC=[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            webVC.url=imgModel.value;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
}


#pragma mark-Delege

-(void)pushToControllerWithPage:(int)page AndItem:(NSString *)intem
{
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
    switch (page)
    {
        case 1:
        {
            HotViewController *hotVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HotViewController"];
            hotVC.itemText=intem;
           
            [self.navigationController pushViewController:hotVC animated:YES];
        }
            break;
        case 2:
        {
            
            PhoneViewController *PhoneVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PhoneViewController"];
            PhoneVC.itemText=intem;

            [self.navigationController pushViewController:PhoneVC animated:YES];
        }
            break;
        case 3:
        {
            GiftViewController *giftVC=[self.storyboard instantiateViewControllerWithIdentifier:@"GiftViewController"];
//            hotVC.itemText=intem;
             [self.navigationController pushViewController:giftVC animated:YES];
        }
            break;
        case 4:
        {
            MyoderViewController1 *myOderVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyoderViewController1"];
            [self.navigationController pushViewController:myOderVC animated:YES];
        }
            break;
            
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
