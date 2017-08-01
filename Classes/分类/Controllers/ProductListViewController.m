//
//  ProductListViewController.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "ProductListViewController.h"
#import "HttpreQuestManager.h"
#import "UIImageView+AFNetworking.h"
#import "NewCustomCell.h"
#import "NewProduct.h"
#import "MJRefresh.h"
#import "UIView+MJExtension.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "FMDBmanager.h"
#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "QYHProgressHUD.h"

@interface ProductListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

{
    UIButton *_selButton;//记录前一个按钮(销售,价格,时间,评价)
    
    BOOL _isSaleAscend;//销售上升判断
    BOOL _isPriceAscend;//价格上升判断
    BOOL _isTimeAscend;//时间上升判断
    BOOL _isCommentAscend;//评价上升判断
    
    BOOL _flag;//排列方式判断
    
    NSMutableArray *_dataArray;//存储数据
    int _page;//第几页,刷新需要
    
    BOOL _isDrown;//是否下拉
    
    UIButton *_button;//返回顶部按钮
    
    BOOL _isfirst;//底部返回顶部按钮创建的判断
    
    BOOL _isClick;//按钮是否被选中判断,用于移除后再重新加载
    
    NSMutableArray *_c2SysNoArray;//装c2SysNo的数据源
    
    int _count;//用于计算总长度(分类按钮)
    UIButton *_seletButton;//记录前一个按钮(分类按钮)
    int _num;//用于判断是否创建分类按钮
    
    CGPoint _offset;//记录上一次结束时的偏移量
    CGFloat _height;//记录listView的高度
    
    UILabel *_label;
    
    UILabel *label;
    
    UIImageView *_imgaView;
    BOOL _isBuy;
    BOOL _isRefresh;
    
    UIView *grayView;
}

@property (weak, nonatomic) IBOutlet UIButton *selectButton;//用于一进来就选中的按钮
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;//搜索栏ann
@property (weak, nonatomic) IBOutlet UIView *listView;//装分类的View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listViewHeight;//装分类的View的高度约束
@property (weak, nonatomic) IBOutlet UIView *barView;//装Bar的View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewheight;//装Bar的View得高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *co;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;


@end

@implementation ProductListViewController
//初始化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _page=0;
        
        _c2SysNoArray=[[NSMutableArray alloc]init];
        _count=0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    grayView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:grayView atIndex:100];
    
    
    //获取数据
//    [self getProductListFromNet];
    //刷新
    [self refresh];
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    _selectButton.selected=YES;//一进来就把销售按钮选中
    _selButton=_selectButton;//把选中的按钮赋给记录上一次选中的按钮
    
    self.sort=8;//销售排列的序号
    
    [_searchButton setTitle:self.name forState:UIControlStateNormal];//设置搜索的文字
    
    _num=self.number+1;//置1,第一次就创建按钮
    
    //更改约束
    [_listView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _listViewHeight.constant=self.originalHeight;
   
}

//返回
- (IBAction)back:(id)sender {
    
    if (self.isSearch)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)pushToSea:(id)sender {
    
    SearchViewController *searchVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchVC animated:YES];
}


//改变排列
- (IBAction)change:(id)sender {
    
    _flag=!_flag;
    [_myCollectionView reloadData];
    _myCollectionView.contentOffset=CGPointMake(0, 0);
    //改变按钮的图片
    UIButton *button=(UIButton *)sender;
    if (_flag)
    {
        [button setImage:[UIImage imageNamed:@"switchgrid"] forState:UIControlStateNormal];
    }else
    {
        [button setImage:[UIImage imageNamed:@"switchlist"] forState:UIControlStateNormal];
    }
    

}

//全部按钮(销售,价格,时间,评价),改变图片和刷新数据
- (IBAction)allButton:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    _selButton.selected=NO;//把上次的按钮不选中
    button.selected=YES;//选中现在按的按钮
    _selButton=button;//
    _isClick=YES;//用于删除原来的数据
 
    //刷新数据
    if ([self.type isEqualToString:@"3"])
    {
        //如果type=3,就执行
        [self type3];
    }
    if ([self.type isEqualToString:@"2"])
    {
        //如果type=2,就执行
        [self type2];
    }

    
}
//销售按钮
- (IBAction)sale:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    _isSaleAscend=!_isSaleAscend;//取反
    //改变对应的图片和排列序号
    if (_isSaleAscend)
    {
        self.sort=7;
        [button setImage:[UIImage imageNamed:@"ascend"] forState:UIControlStateNormal];
    }else
    {
        self.sort=8;
        [button setImage:[UIImage imageNamed:@"discend"] forState:UIControlStateNormal];
    }
    
}
//价格按钮
- (IBAction)price:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_isPriceAscend)
    {
        self.sort=4;
        [button setImage:[UIImage imageNamed:@"ascend"] forState:UIControlStateNormal];
    }else
    {
        self.sort=3;
        [button setImage:[UIImage imageNamed:@"discend"] forState:UIControlStateNormal];
    }
    _isPriceAscend=!_isPriceAscend;
}
//时间按钮
- (IBAction)time:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_isTimeAscend)
    {
        self.sort=1;
        [button setImage:[UIImage imageNamed:@"ascend"] forState:UIControlStateNormal];
    }else
    {
        self.sort=2;
        [button setImage:[UIImage imageNamed:@"discend"] forState:UIControlStateNormal];
    }
    _isTimeAscend=!_isTimeAscend;
}
//评价按钮
- (IBAction)comment:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    
    if (_isCommentAscend)
    {
        self.sort=5;
        [button setImage:[UIImage imageNamed:@"ascend"] forState:UIControlStateNormal];
    }else
    {
        self.sort=6;
        [button setImage:[UIImage imageNamed:@"discend"] forState:UIControlStateNormal];
    }
    _isCommentAscend=!_isCommentAscend;
}


//初始化刷新
- (void)refresh
{
   
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _isDrown=YES;
        _page=0;
        
        _isRefresh = YES;
        //刷新结束后调用刷新数据
        [weakSelf getProductListFromNet];
        
        [weakSelf.myCollectionView.mj_footer resetNoMoreData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myCollectionView.mj_header endRefreshing];

    }];
    
    // 马上进入刷新状态
    [self.myCollectionView.mj_header beginRefreshing];
    
    
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _isDrown=NO;
        _page+=20;
        
        _isRefresh = YES;
        //刷新结束后调用刷新数据
        [weakSelf getProductListFromNet];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myCollectionView.mj_footer endRefreshing];


    }];
    
    
    
}


//从网络获取数据
- (void)getProductListFromNet
{
    
    if ([self.type isEqualToString:@"3"])
    {
        //如果type=3,就执行
        [self type3];
        
        [self getlist];
    }
    if ([self.type isEqualToString:@"2"])
    {
        //如果type=2,就执行
        [self type2];
    }
    
}
//获取分类的信息并创建分类按钮
- (void)getlist
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpreQuestManager shareInstance]getProductWithUrl:self.url success:^(id responseObject) {
        grayView.hidden = YES;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSArray *listArray=responseObject[@"list"];
        for (NSDictionary *dic in listArray)
        {
            [_c2SysNoArray addObject:dic[@"c2SysNo"]];//获取编号
            
        }
        [self createButton:listArray];//调用创建按钮
       
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
        
        
        NSLog(@"获取c2SysNo数据失败,error==%@",error);
        
    }];
}
//创建分类按钮
- (void)createButton:(NSArray *)listArray
{
    if (_num==1)//判断是否是进来的第一次
    {
        int hang=0;//按钮创建在第几行
        
        for (int i=0; i<listArray.count; i++)
        {
            NSDictionary *dic=listArray[i];
            
            [_c2SysNoArray addObject:dic[@"c2SysNo"]];
            
            int j=[dic[@"c2Name"] length];//取文字内容的长度
            
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
            button.frame=CGRectMake(x,30*hang+5,20*j, 25);
            
            [button setTitle:dic[@"c2Name"] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [button setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall2.9.png"] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor colorWithRed:157/255.0 green:202/255.0 blue:49/255.0 alpha:1.0] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall2.9.png"] forState:UIControlStateSelected];
            //打上tag
            button.tag=100+i;
            //如果是第一次就把第一个按钮("全部按钮")选中
            if (i==0)
            {
                button.selected=YES;
                _seletButton=button;
            }
            //添加时间
            [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_listView addSubview:button];
            
        }
        _num=0;//创建完按钮置0,刷新时就不用创建了
        //把_listViewHeight的约束更改
        _listViewHeight.constant=30*(hang+1)+5;
        //获取_listView的高度
        _height=_listViewHeight.constant;
        
        
        [UIView animateWithDuration:0.7 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
}
//分类按钮事件
- (void)selectClick:(UIButton *)button
{
    
    _seletButton.selected=NO;
    button.selected=YES;
    _seletButton=button;
    
    _isClick=YES;//记录要删除原来的数据
    
    if (button.tag==100)
    {
        [self type3];//如果是第一个就进入全部的刷新数据
    }else
    {
        //如果是其他的就进入对应编号的刷新数据
        [self type4WithC2SysNo:_c2SysNoArray[button.tag-100]];
    }
    
}
//type2=2的获取数据的方式
- (void)type2
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"self.c1SysNoUrl==%@",self.c1SysNoUrl);
//    &limit=20&localcity=246&sort=2&source=3&systemVersion=4.4.2&offset=0
    NSString *url=[self.c1SysNoUrl stringByAppendingFormat:@"&limit=20&localcity=246&sort=%d&source=3&offset=%d",self.sort,_page];
    
    [[HttpreQuestManager shareInstance]getProductWithUrl:url success:^(id responseObject) {
        
        [_dataArray removeAllObjects];
        
        grayView.hidden = YES;

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [UIView animateWithDuration:0.6 animations:^{
            
            //更改约束
            [_listView setTranslatesAutoresizingMaskIntoConstraints:NO];
            _listViewHeight.constant=0;
            
            
        } completion:^(BOOL finished) {
            
            //把偏移量置0
            if (_isRefresh)
            {
                _isRefresh = NO;
            }else
            {
                _myCollectionView.contentOffset=CGPointMake(0, 0);
            }

            
        }];
      
        
        if (_isDrown||_isClick)//刷新删除数据
        {
            [_dataArray removeAllObjects];
        }
        
        if ([responseObject[@"productList"] count]==0)
        {
//            [self createLabel:@"抱歉,暂无此商品信息!"];
            [QYHProgressHUD showErrorHUD:nil message:@"抱歉,暂无此商品信息!"];
            
        }else
        {
        
            for (NSDictionary *dic in responseObject[@"productList"])
            {
                NewProduct *model=[[NewProduct alloc]init];
                model.imageUrl=dic[@"imageUrl"];
                model.origPrice=dic[@"origPrice"];
                model.price=dic[@"price"];
                model.productName=dic[@"productName"];
                model.productSysNo=dic[@"productSysNo"];
                
                [_dataArray addObject:model];
            }
            
            
            [_myCollectionView reloadData];
            
            _isClick=NO;
        }
        
    } failure:^(NSError *error) {
        grayView.hidden = NO;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-110);
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"加载失败,点击屏幕重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [grayView addSubview:button];


        
        NSLog(@"获取数据失败,error==%@",error);
        
    }];
    
}


//创建label(提示作用)
- (void)createLabel:(NSString *)title
{
    [_label removeFromSuperview];//先把原来的删除
    if (_isBuy)
    {
         _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.9, self.view.frame.size.height-100, 100, 35)];
        _isBuy=NO;
        
    }else
    {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4.5, self.view.frame.size.height-120, 200, 35)];
    }
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
    [UIView animateWithDuration:1.0 animations:^{
        
        _label.alpha=0.6;
        
    } completion:^(BOOL finished) {
        
        [_label removeFromSuperview];
    }];
    
}



//type3=3的获取数据的方式
- (void)type3
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpreQuestManager shareInstance]getProductAllListSort:self.sort c1SysNo:self.c1SysNo withPage:_page success:^(id responseObject) {
        
        grayView.hidden = YES;

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //没偏移量
        
        if (_isRefresh)
        {
            _isRefresh = NO;
        }else
        {
            _myCollectionView.contentOffset=CGPointMake(0, 0);
        }
        //是否点击或者刷新,
        if (_isDrown||_isClick)
        {
            [_dataArray removeAllObjects];
        }
        
        
        for (NSDictionary *dic in responseObject[@"productList"])
        {
            NewProduct *model=[[NewProduct alloc]init];
            model.imageUrl=dic[@"imageUrl"];
            model.origPrice=dic[@"origPrice"];
            model.price=dic[@"price"];
            model.productName=dic[@"productName"];
            model.productSysNo=dic[@"productSysNo"];
            
            [_dataArray addObject:model];
        }
        
        
        [_myCollectionView reloadData];
        
        _isClick=NO;
        
    } failure:^(NSError *error) {
        
        grayView.hidden = NO;

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
      
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-110);
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"加载失败,点击屏幕重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [grayView addSubview:button];
        


        
        NSLog(@"获取新品数据失败,error==%@",error);
    }];
    
}
//获取c2SysNo数据的方式
- (void)type4WithC2SysNo:(NSString *)c2SysNo
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpreQuestManager shareInstance]getProductListSort:self.sort c1SysNo:self.c1SysNo c2SysNo:[c2SysNo intValue]withPage:_page success:^(id responseObject) {
        
        grayView.hidden = YES;

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        _myCollectionView.contentOffset=CGPointMake(0, 0);
        
        if (_isDrown||_isClick)
        {
            [_dataArray removeAllObjects];
        }
        
        
        for (NSDictionary *dic in responseObject[@"productList"])
        {
            NewProduct *model=[[NewProduct alloc]init];
            model.imageUrl=dic[@"imageUrl"];
            model.origPrice=dic[@"origPrice"];
            model.price=dic[@"price"];
            model.productName=dic[@"productName"];
            model.productSysNo=dic[@"productSysNo"];
            
            [_dataArray addObject:model];
        }
        
        
        [_myCollectionView reloadData];
        
        _isClick=NO;
        
    } failure:^(NSError *error) {
        
        grayView.hidden = NO;

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"获取新品数据失败,error==%@",error);
    }];
    
}

- (void)click
{
   
    [grayView removeFromSuperview];
    [self getProductListFromNet];
    
}



- (IBAction)addBuy:(id)sender {
    
    NewCustomCell * cell = (NewCustomCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    //取得imgview在self.view的位置
    CGRect rect = [cell convertRect:cell.imgView.frame toView:[_myCollectionView superview]];
    
    _imgaView=[[UIImageView alloc]initWithFrame:CGRectMake((rect.origin.x+5), (rect.origin.y+5), cell.imgView.frame.size.width, cell.imgView.frame.size.height)];
    
    _imgaView.image=cell.imgView.image;
    
    
    [self.view addSubview:_imgaView];
    [self.view bringSubviewToFront:_imgaView];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        
        _imgaView.frame=CGRectMake(self.view.frame.size.width-40, self.view.frame.size.height-40, 10, 10);
        
    } completion:^(BOOL finished) {
        
        _imgaView.hidden=YES;
        self.cartBtn.selected=YES;
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.2];
        
    }];
    

    
    NewProduct *model=_dataArray[indexPath.row];
    //    imageUrl text,price text,productName text,productSysNo text,num text
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    int num=1;
    
    while ([rs next])
    {
        if ([[rs stringForColumn:@"productSysNo"] isEqualToString:model.productSysNo])
        {
            num=[[rs stringForColumn:@"num"] intValue]+1;
            
            if (![manager.basae executeUpdate:@"update Cart set num=? where productSysNo=?",[NSString stringWithFormat:@"%d",num],model.productSysNo])
            {
                NSLog(@"修改失败");
            }
        }
    }
    if (num==1)
    {
        if (![manager.basae executeUpdate:@"insert into Cart(imageUrl,price,productName,productSysNo,num) values (?,?,?,?,?)",model.imageUrl,model.price,model.productName,model.productSysNo,[NSString stringWithFormat:@"%d",num]])
        {
            NSLog(@"插入失败");
        }
        
    }
    
    if (![manager.basae executeUpdate:@"update Cart set choose=? where productSysNo=?",@"1",model.productSysNo])
    {
        NSLog(@"修改失败");
    }

    rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    //    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    int count = 0;
    
    while ([rs next])
    {
        count+=[[rs stringForColumn:@"num"] intValue];
    }
    
    
   
    
    _isBuy=YES;
//    [self createLabel:@"加入成功!"];
//    [QYHProgressHUD showHUDInView:self.view onlyMessage:@"加入成功！"];
    
    self.view.userInteractionEnabled=NO;
    
    [self performSelector:@selector(btnDelay:) withObject:[NSString stringWithFormat:@"%d",count] afterDelay:2.0];
}

- (void)btnDelay:(NSString *)count
{
     self.view.userInteractionEnabled=YES;
     [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:count];
}


- (IBAction)searchBtnAction:(id)sender {
    
    ProductListViewController *listVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ProductListViewController"];
    NSString *url=[[NSString stringWithFormat:@"http://www.benlai.com/IProductList/List?query=%@%%20",_searchButton.currentTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    listVC.c1SysNoUrl=url;
    listVC.type=@"2";
    listVC.name=_searchButton.currentTitle;
  
    [self.navigationController pushViewController:listVC animated:YES];
}


- (void)delay
{
    self.cartBtn.selected=NO;
    [QYHProgressHUD showSuccessHUD:nil message:@"加入成功！"];
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




#pragma mark-UIScrollViewDelegate
//正在滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果偏移量大于95就创建返回顶部按钮
    if (scrollView.contentOffset.y>95)
    {
        if (!_isfirst)//如果_isfirst=NO,就创建按钮
        {
            _button=[UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame=CGRectMake(self.view.frame.size.width/2-45, self.view.frame.size.height-35, 65, 40);
            [_button setImage:[UIImage imageNamed:@"backtop"] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_button];
            
            _isfirst=YES;//
            
        }
        
    }else
    {
        if (_isfirst)//如果_isfirst=YES,就创建按钮

        {
            [_button removeFromSuperview];
            _isfirst=NO;//
        }
    }
    
}
//滚动即将开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
      _offset=scrollView.contentOffset;//记录上次结束的偏移量
}
//即将停止拽动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //如果偏移量大于上次的就隐藏View
    if (scrollView.contentOffset.y>_offset.y)
    {
//        [UIView transitionWithView:_listView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            _listViewHeight.constant=0.0;
//        } completion:^(BOOL finished) {
//            
//        }];
//        
        [UIView animateWithDuration:0.2 animations:^{
            
            _listViewHeight.constant=0.0;
            [_listView layoutIfNeeded];
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _barViewheight.constant=0.0;
            [_barView layoutIfNeeded];
        }];
        
//        [UIView transitionWithView:_barView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            _barViewheight.constant=0.0;
//        } completion:^(BOOL finished) {
//            
//        }];
//        
        
    }else
    {
        //如果偏移量小于上次的就显示View

//        [UIView transitionWithView:_listView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                _listViewHeight.constant=_height;
//            } completion:^(BOOL finished) {
//                
//            }];
//        [UIView transitionWithView:_barView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            _barViewheight.constant=44;
//        } completion:^(BOOL finished) {
//            
//        }];
//        
        [UIView animateWithDuration:0.2 animations:^{
            
            _listViewHeight.constant=_height;
            [_listView layoutIfNeeded];
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _barViewheight.constant=44;
            [_barView layoutIfNeeded];
        }];
        

        
    }

}

//返回顶部
- (void)scrollToTop:(UIScrollView *)scrollView
{
    
    [_myCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}


#pragma mark-UICollectionViewDataSource
//返回多少cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //不同排列返回不同的cell
    if (!_flag)
    {
        NewCustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"NewCustomCell" forIndexPath:indexPath];
        [self showData:cell cellForItemAtIndexPath:indexPath];
        
        return cell;
    }else
    {
        NewCustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"NewCustomCell1" forIndexPath:indexPath];
        
        [self showData:cell cellForItemAtIndexPath:indexPath];
        
        return cell;
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_flag)
    {
         return CGSizeMake(self.view.frame.size.width/2.05,self.view.frame.size.width/2.1*1.5);
    }else
    {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/2.5);
    }
}



//显示cell的内容
- (void)showData:(NewCustomCell *)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewProduct *model=_dataArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    cell.nameLabel.text=model.productName;
    cell.currenPrice.text=[@"¥ " stringByAppendingString:model.price];
    cell.originalPrice.text=[@"¥ " stringByAppendingString:model.origPrice];
  
}

////返回cell的高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //对应不同的排列返回不同的cell的高度
//    if (!_flag)
//    {
//        return CGSizeMake(157, 250);
//    }else
//    {
//        return CGSizeMake(320, 111);
//    }
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (_dataArray.count < 20+_page)
    {
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
    return CGSizeMake(0,0);
}
//段头段尾复用
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //通过kind字符串来区分段头段尾
    if ( [kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        return nil;
    }else
    {
        //注册段尾复用
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
        
        //段尾复用
        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, foot.frame.size.width, 30)];
        label2.text = @"没有更多了";
        label2.textColor = [UIColor grayColor];
        label2.textAlignment = NSTextAlignmentCenter;
        
        [foot addSubview:label2];
        
        return foot;
        
    }
    
}

//选中cell执行事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //
    NewProduct *model=_dataArray[indexPath.row];
    detailVC.productSysNo=model.productSysNo;
//    NSLog(@"%@",model.productSysNo);
    self.originalHeight=_listViewHeight.constant;
    self.number=-1;
    [self presentViewController:detailVC animated:NO completion:nil];
//    [self.navigationController pushViewController:detailVC animated:NO];
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
