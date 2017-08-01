//
//  HotViewController.m
//  Original
//
//  Created by qianfeng on 15/9/17.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "HotViewController.h"
#import "HttpreQuestManager.h"
#import "UIImageView+AFNetworking.h"
#import "NewCustomCell.h"
#import "NewProduct.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "FMDBmanager.h"
#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "QYHProgressHUD.h"


@interface HotViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

{
    NSMutableArray *_dataArray;//存储数据
    int _page;//第几页,刷新需要
    
//    MJRefreshFooterView *_footView;//
//    MJRefreshHeaderView *_headView;//
    BOOL _isDrown;//是否下拉
    
    UIButton *_button;
    
    BOOL _isfirst;
    UILabel *label;
    UIImageView *_imgaView;
    UILabel *_label;
    UIView *grayView;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@end

@implementation HotViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _page=0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取数据
//    [self getNewProductFromNet];
    
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

- (void)viewWillAppear:(BOOL)animated
{
     self.item.text=self.itemText;//赋值
    
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
}


//初始化刷新
- (void)refresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _isDrown=YES;
        _page=0;
        
        [_dataArray removeAllObjects];
        
        [weakSelf getNewProductFromNet];
        
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
        
        [weakSelf getNewProductFromNet];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myCollectionView.mj_footer endRefreshing];
        
    }];
    
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//从网络获取数据
- (void)getNewProductFromNet
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpreQuestManager shareInstance]getHotProductsPage:_page success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (_isDrown==YES)
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

        
        NSLog(@"获取新品数据失败,error==%@",error);
    }];
}

- (void)click
{
    [grayView removeFromSuperview];
    [self getNewProductFromNet];
}


- (IBAction)addBuy:(id)sender {
    
    NewCustomCell * cell = (NewCustomCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];

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



//创建label(提示作用)
- (void)createLabel:(NSString *)title
{
    [_label removeFromSuperview];//先把原来的删除
    _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.9, self.view.frame.size.height-100, 100, 35)];
    
    _label.backgroundColor=[UIColor blackColor];
    _label.textAlignment=NSTextAlignmentCenter;
    //设置圆角度和边框
    _label.layer.borderWidth = 0.5f;
    _label.layer.masksToBounds = YES;
    
    _label.textColor=[UIColor whiteColor];
    
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



#pragma mark-UIScrollViewDelegate
//正在滚到
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y>95)
    {
        if (!_isfirst)
        {
            _button=[UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame=CGRectMake(self.view.frame.size.width/2-45, self.view.frame.size.height-32, 65, 40);
            [_button setImage:[UIImage imageNamed:@"backtop"] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_button];
            
            _isfirst=YES;
            
        }
        
    }else
    {
        if (_isfirst)
        {
            [_button removeFromSuperview];
            _isfirst=NO;
        }
    }
}
//滚到顶部
- (void)scrollToTop:(UIScrollView *)scrollView
{
    
    [_myCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}


#pragma mark-UICollectionViewDataSource
//每组返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"NewCustomCell" forIndexPath:indexPath];
    
    NewProduct *model=_dataArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    cell.nameLabel.text=model.productName;
    cell.currenPrice.text=[@"¥ " stringByAppendingString:model.price];
    cell.originalPrice.text=[@"¥ " stringByAppendingString:model.origPrice];
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width/2.5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    if (_dataArray.count < 20+_page)
    {
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
    
    
    return CGSizeMake(0,0);
}


//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

    NewProduct *model=_dataArray[indexPath.row];
    detailVC.productSysNo=model.productSysNo;

    [self presentViewController:detailVC animated:NO completion:nil];
//    [self.navigationController pushViewController:detailVC animated:NO];
    
    
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


//返回
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushToCart:(id)sender {
    
    CartViewController *cartVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
//    cartVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:cartVC animated:YES completion:nil];
    cartVC.second=@"1";
    [self.navigationController pushViewController:cartVC animated:NO];
}




//分享
- (IBAction)share:(id)sender {
    
    ShareCustomView *shareView = [[ShareCustomView alloc]init];
    
    [shareView show];

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
