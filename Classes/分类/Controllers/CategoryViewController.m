//
//  CategoryViewController.m
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "CategoryViewController.h"
#import "HttpreQuestManager.h"
#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
#import "CategoryModel.h"
#import "Aditems.h"
#import "ProductListViewController.h"
#import "SubjectViewController.h"
#import "TabBarController.h"
#import "LocationViewController.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface CategoryViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    NSMutableArray *_dataArray;//装上面12个标签图片
    NSMutableArray *_aditemArray;//装下面4个标签图片
    UIButton *cityButton;
    UILabel *_label;
    UITextField *_search;
    NSString *_cityName;
    
    UIView *grayView;
    
//    MJRefreshHeaderView *_headView;//
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation CategoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _aditemArray=[[NSMutableArray alloc]init];
        
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"city" object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //添加导航栏的控件
    [self addNAVView];
    //获取分类数据
//    [self getDataFromNet];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getDataFromNet];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myScrollView.mj_header endRefreshing];

        
    }];
    
    // 马上进入刷新状态
    [self.myScrollView.mj_header beginRefreshing];


    
    CGFloat ViewHeight     = self.view.frame.size.height;
    CGFloat imgViewHeight  = _imgView1.frame.size.height;
    CGFloat height         = ViewHeight > 568 ? (ViewHeight-568-imgViewHeight):(568-ViewHeight+20);
    CGFloat viewHeight     = imgViewHeight*2+(ViewHeight-100*3+height);
    
    self.viewHeightConstraint.constant  = viewHeight;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=NO;
    
    [cityButton setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
}


- (void)cityName:(NSNotification *)info
{
     [cityButton setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"city" object:nil];
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
//    _label.shadowColor=[UIColor whiteColor];
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



//从网络获取数据
-(void)getDataFromNet
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HttpreQuestManager *manager=[HttpreQuestManager shareInstance];
    
    [manager getCategorySuccess:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_aditemArray removeAllObjects];
        [_dataArray removeAllObjects];
        
        //添加aditems里面的数据,即四张图片对应的信息
        for (NSDictionary *dic in responseObject[@"aditems"][@"list"])
        {
            Aditems *model=[[Aditems alloc]init];
            model.img=dic[@"img"];
            model.value=dic[@"value"];
            
            [_aditemArray addObject:model];
        }
         //添加items里面的数据,
        for (NSDictionary *dic in responseObject[@"items"])
        {
            CategoryModel *model=[[CategoryModel alloc]init];
            model.imageUrl=dic[@"imageUrl"];
            model.type=dic[@"type"];
            //type=3的存储方式
            if ([dic[@"type"] isEqualToString:@"3"])
            {
                model.c1SysNo=dic[@"c1SysNo"];
                model.url=dic[@"param"][@"url"];
            }
            //type=2的存储方式
            if ([dic[@"type"] isEqualToString:@"2"])
            {
                model.c1SysNoUrl=dic[@"param"][@"url"];
            }
            
            model.name=dic[@"c1Name"];
            
            
            [_dataArray addObject:model];
        }
        
        [_myCollectionView reloadData];
        
        [self reloadImage];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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
        
        NSLog(@"获取分类数据失败,error==%@",error);
    }];
    
    
    [manager getSearchKeySuccess:^(id responseObject) {
        
        _search.placeholder=responseObject;
        
    } failure:^(NSError *error) {
        
        NSLog(@"获取搜索关键词失败,error==%@",error);
    }];
}

- (void)click
{
    [self getDataFromNet];
    
    [grayView removeFromSuperview];
}

//更新显示下面4张图片
- (void)reloadImage
{
    //设置内容大小
//    _myScrollView.contentSize=CGSizeMake(0, self.view.frame.size.height*1.3);
   
    //一个个添加图片
    for (int i=0; i<4; i++)
    {
        Aditems *model=_aditemArray[i];
        
        if (i==0)
        {
            [_imgView1 setImageWithURL:[NSURL URLWithString:model.img ]];
            _imgView1.userInteractionEnabled=YES;
            _imgView1.tag=i+100;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentVC:)];
            [_imgView1 addGestureRecognizer:tap];
        }
        if (i==1)
        {
            [_imgView2 setImageWithURL:[NSURL URLWithString:model.img ]];
            
            _imgView2.userInteractionEnabled=YES;
            _imgView2.tag=i+100;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentVC:)];
            [_imgView2 addGestureRecognizer:tap];
        }
        if (i==2)
        {
            [_imgView3 setImageWithURL:[NSURL URLWithString:model.img ]];
            
            _imgView3.userInteractionEnabled=YES;
            _imgView3.tag=i+100;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentVC:)];
            [_imgView3 addGestureRecognizer:tap];

        }
        if (i==3)
        {
            [_imgView4 setImageWithURL:[NSURL URLWithString:model.img ]];
            
            _imgView4.userInteractionEnabled=YES;
            _imgView4.tag=i+100;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentVC:)];
            [_imgView4 addGestureRecognizer:tap];

        }
        
        
        
    }
    
    
}
//点击四张图片进入对应的页面
- (void)presentVC:(UITapGestureRecognizer *)tap
{
    SubjectViewController *subjectVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SubjectViewController"];
    Aditems *model=_aditemArray[tap.view.tag-100];
    subjectVC.sysNo=model.value;
 
    [self.navigationController pushViewController:subjectVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
}


//在导航栏上添加一个View
- (void)addNAVView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    
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
//    //
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
    
    [cityButton setTitle:_cityName forState:UIControlStateNormal];
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
    SearchViewController *searchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchVC.searchText=textField.placeholder;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
    return NO;
}



#pragma mark-UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    CategoryModel *model=_dataArray[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    cell.nameLabel.text=model.name;
  
    
    return cell;
    
}
//选中cell执行事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    
    CategoryModel *model=_dataArray[indexPath.row];
    listVC.name=model.name;
    listVC.type=model.type;
    //传值
    if ([model.type isEqualToString:@"3"])
    {
        listVC.c1SysNo=[model.c1SysNo intValue];
        listVC.url=model.url;
    }
    if ([model.type isEqualToString:@"2"])
    {
        listVC.c1SysNoUrl=model.c1SysNoUrl;
    }

    [self.navigationController pushViewController:listVC animated:YES];
    
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=YES;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return (self.myCollectionView.frame.size.width-80*4)/3.0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
     return (self.myCollectionView.frame.size.height-90*3)/4.0*1.5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake((self.myCollectionView.frame.size.height-90*3)/4.0/2, 0, (self.myCollectionView.frame.size.height-90*3)/4.0/2, 0);
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return CGSizeMake(self.myCollectionView.frame.size.width/3.05, self.myCollectionView.frame.size.height/4.1);
//}
//
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
