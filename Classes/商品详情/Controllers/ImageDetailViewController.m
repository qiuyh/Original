//
//  ImageDetailViewController.m
//  Original
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "NetInterface.h"
#import "GroupCell.h"
#import "ReviewsCell.h"
#import "ReviewsModel.h"
#import "HttpreQuestManager.h"
#import "MJRefresh.h"
#import "FMDBmanager.h"
#import "CartViewController.h"
#import "MBProgressHUD.h"
#import "QYHProgressHUD.h"
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"

#import "DetailViewController.h"

@interface ImageDetailViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;//可以加载网页数据的View
    
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dataDic;
    int _page;
    int _type;
//    MJRefreshHeaderView *_headView;//
//    MJRefreshFooterView *_footView;//
    CGRect _rect;
    
    BOOL _isRefresh;
    UILabel *label1;
    UILabel *_label;
    BOOL _isCole;
    
    UIView *grayView;
    
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
}

@property (weak, nonatomic) IBOutlet UIView *bigScrollView;


//@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewsBtn;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *coleBtn;



@end

@implementation ImageDetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];
        _dataDic=[[NSMutableDictionary alloc]init];
        _page=0;
        _type=0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    //调用加载web
    [self loadWeb];
    
    [self getDataFromNet];
    
    [self addObse];
    
//    _headView=[[MJRefreshHeaderView alloc]init];
//    _headView.scrollView=_webView.scrollView;
//    _headView.delegate=self;
    
    _myTableView.frame =  CGRectMake(0, _webView.frame.origin.y, self.view.frame.size.width, _webView.frame.size.height);
    
     __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page+=20;
        _isRefresh=YES;
        [weakSelf getDataFromNet];
        
        [weakSelf.myTableView.mj_footer resetNoMoreData];

        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.myTableView.mj_header endRefreshing];
    }];
    

    
    
    // YiRefreshHeader  头部刷新按钮的使用
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=_webView.scrollView;
  
    typeof(refreshHeader) __weak weakRefreshHeader = refreshHeader;

    refreshHeader.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            sleep(0.2);
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(weakRefreshHeader) __strong strongRefreshHeader = weakRefreshHeader;
                // 主线程刷新视图
                typeof(weakSelf) __strong strongSelf = weakSelf;
                [strongSelf backTo];
                
                [strongRefreshHeader endRefreshing];
            });
        });
    };
    
    
    // 是否在进入该界面的时候就开始进入刷新状态
//    [refreshHeader beginRefreshing];
    
//    // YiRefreshFooter  底部刷新按钮的使用
//    refreshFooter=[[YiRefreshFooter alloc] init];
//    refreshFooter.scrollView=_myTableView;
//    [refreshFooter footer];
//    typeof(refreshFooter) __weak weakRefreshFooter = refreshFooter;
//    
//    refreshFooter.beginRefreshingBlock=^(){
//        // 后台执行：
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            sleep(2);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                typeof(weakRefreshFooter) __strong strongRefreshFooter = weakRefreshFooter;
//                // 主线程刷新视图
//        
//                [strongRefreshFooter endRefreshing];
//            });
//        });
//    };

    

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
    
    FMResultSet *rs2 =  [manager.basae executeQuery:@"select * from Colection"];
    
    
    while ([rs2 next])
    {
        if ([[rs2 stringForColumn:@"productSysNo"] isEqualToString:self.productSysNo])
        {
            self.coleBtn.selected=YES;
        }
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:[NSString stringWithFormat:@"%d",count]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.bigScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.bigScrollView.frame.size.height);
//    self.myTableView.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.bigScrollView.frame.size.height);
    
    
    if (_isReviewsSelected)
    {
        [self reviewsButton:nil];
    }else
    {
        [self detailBuuton:nil];
    }
    self.detailBtn.selected=!_isReviewsSelected;
    self.reviewsBtn.selected=_isReviewsSelected;
    
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}



- (IBAction)back:(id)sender {
    
   [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
//    [self dismissViewControllerAnimated:NO completion:^{
//        
//         DetailViewController *detailVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//        [detailVC.navigationController popViewControllerAnimated:NO];
//        
//    }];
    
//    if ([self.present isEqualToString:@"1"])
//    {
//        [self dismissViewControllerAnimated:NO completion:nil];
//        
//    }else
//    {
//        
//        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:NO];
//    }

//    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)detailBuuton:(id)sender {
    
    _isReviewsSelected=NO;
    self.reviewsBtn.selected=NO;
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
//    self.bigScrollView.contentOffset=CGPointMake(0, 0);
    self.myTableView.hidden=YES;
    self.bigScrollView.hidden=NO;
    
    refreshHeader.scrollView=_webView.scrollView;

    self.myTableView.contentOffset = CGPointMake(0, 0);
    _webView.scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)reviewsButton:(id)sender {
    
    _isReviewsSelected=YES;
    self.detailBtn.selected=NO;
    UIButton *button=(UIButton *)sender;
    button.selected=YES;
    
//    self.bigScrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
    self.myTableView.hidden=NO;
    self.bigScrollView.hidden=YES;
    [self.myTableView reloadData];
    refreshHeader.scrollView=_myTableView;
   
    self.myTableView.contentOffset = CGPointMake(0, 0);
    _webView.scrollView.contentOffset = CGPointMake(0, 0);
}

//加载web
- (void)loadWeb
{
    self.myTableView.hidden=YES;
    self.bigScrollView.hidden=NO;
    
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.bigScrollView.frame.size.height)];
//    [self.bigScrollView addSubview:view];
    
    //初始化_webView
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-134)];
     _webView.backgroundColor=[UIColor whiteColor];
    [self.bigScrollView addSubview:_webView];
    
    self.bigScrollView.backgroundColor = [UIColor redColor];
    _webView.backgroundColor = [UIColor grayColor];
//    [view sendSubviewToBack:_webView];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRODUCTS_DETAIL_ID,[self.productSysNo intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView.delegate=self;
    
    [_webView setScalesPageToFit:YES];
    
    //加载一个网页地址
    [_webView loadRequest:request];
}

#pragma webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//加载完成后设置偏移量
- (void)webViewDidStartLoad:(UIWebView *)webView
{

//    _webView.scrollView.bounces=NO;
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    _webView.scrollView.showsHorizontalScrollIndicator=NO;
}

- (void)getDataFromNet
{
//    self.myTableView.frame=CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.bigScrollView.frame.size.height);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HttpreQuestManager *manager=[HttpreQuestManager shareInstance];
    [manager getProductReviewsNewproductSysNo:[self.productSysNo intValue] withPage:_page withType:_type success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        if (!_isRefresh)
        {
            [_dataArray removeAllObjects];
            [_dataArray addObject:@""];
        }
        [_dataDic removeAllObjects];
        
        _isRefresh=NO;
        
        [_dataDic setObject:responseObject[@"GoodP"] forKey:@"GoodP"];
        [_dataDic setObject:responseObject[@"veryGood"] forKey:@"veryGood"];
        [_dataDic setObject:responseObject[@"good"] forKey:@"good"];
        [_dataDic setObject:responseObject[@"noGood"] forKey:@"noGood"];
        [_dataDic setObject:responseObject[@"scoreCount"] forKey:@"scoreCount"];
        
        
        for (NSDictionary *dic in responseObject[@"reviews"])
        {
            ReviewsModel *model=[[ReviewsModel alloc]init];
            model.content=dic[@"Content"];
            model.createTime=dic[@"CreateTime"];
            model.userName=dic[@"CustomerName"];
            model.starsCount=dic[@"Score"];
            
            [_dataArray addObject:model];
        }
        
        [self.myTableView reloadData];
        
       
        
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
        

        
        NSLog(@"获取评价数据失败,error==%@",error);
    }];
}

- (void)click
{
    [grayView removeFromSuperview];
    [self getDataFromNet];
}



- (IBAction)allReviews:(id)sender {
    _type=0;
    [self getDataFromNet];
}


- (IBAction)veryGood:(id)sender {
    _type=3;
    [self getDataFromNet];

}

- (IBAction)good:(id)sender {
    _type=2;
    [self getDataFromNet];

}

- (IBAction)noGood:(id)sender {
    _type=1;
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
    return _dataArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.GoodP.text=_dataDic[@"GoodP"];
        cell.veryGoodCount.text=[_dataDic[@"veryGood"] stringValue];
        cell.goodCount.text=[_dataDic[@"good"] stringValue];
        cell.noGoodCount.text=[_dataDic[@"noGood"] stringValue];
        
        [cell.reviewsCount setTitle:[NSString stringWithFormat: @"(%@)",[_dataDic[@"scoreCount"] stringValue]] forState:UIControlStateNormal];
        
        int count=[cell.veryGoodCount.text intValue]+[cell.goodCount.text intValue]+[cell.noGoodCount.text intValue];
        
        if ([cell.veryGoodCount.text intValue] == 0)
        {
            cell.veryGoodHeight.constant= 0.5;
        }else
        {
            cell.veryGoodHeight.constant=30.0/count*[cell.veryGoodCount.text intValue]+0.5;
        }
        
        if ([cell.goodCount.text intValue] == 0)
        {
            cell.goodHeight.constant= 0.5;
        }else
        {
            cell.goodHeight.constant=30.0/count*[cell.goodCount.text intValue]+0.5;
        }
        
        if ([cell.noGoodCount.text intValue] == 0)
        {
            cell.noGoodHeight.constant= 0.5;
        }else
        {
            cell.noGoodHeight.constant=30.0/count*[cell.noGoodCount.text intValue]+0.5;
        }
        
        return cell;
        
    }else
    {
        ReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        ReviewsModel *model=_dataArray[indexPath.row];
        cell.content.text=model.content;
        
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createTime integerValue]];
        //时间格式类
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //时间格式
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        //将NSDate转成NSString
        NSString *dateString = [dateFormatter stringFromDate:date];
        cell.createTime.text=dateString;
        
        cell.userName.text=model.userName;
        cell.starsWith.constant=[model.starsCount intValue]*20;
        
        
        CGSize maxSize = CGSizeMake(self.view.frame.size.width - 10, CGFLOAT_MAX);
        _rect= [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_dataArray.count < 20+_page)
    {
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
        
        
    }

    
    if (indexPath.row==0)
    {
        return 125;
    }else
    {
    return 72+_rect.size.height;
    }
}



- (IBAction)add:(id)sender {
    
    self.textField.text=[NSString stringWithFormat:@"%d",([self.textField.text intValue]+1)];

}


- (IBAction)decrease:(id)sender {
    
    if ([self.textField.text isEqualToString:@"1"])
    {
        return;
    }
    self.textField.text=[NSString stringWithFormat:@"%d",([self.textField.text intValue]-1)];
}



- (IBAction)addBuy:(id)sender {
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    int num=1;
    
    while ([rs next])
    {
        if ([[rs stringForColumn:@"productSysNo"] isEqualToString:self.productSysNo])
        {
            num=[[rs stringForColumn:@"num"] intValue]+[self.textField.text intValue];
            
            if (![manager.basae executeUpdate:@"update Cart set num=? where productSysNo=?",[NSString stringWithFormat:@"%d",num],self.productSysNo])
            {
                NSLog(@"修改失败");
            }
        }
    }
    if (num==1)
    {
        if (![manager.basae executeUpdate:@"insert into Cart(imageUrl,price,productName,productSysNo,num) values (?,?,?,?,?)",self.imageUrl,self.price,self.productName,self.productSysNo,[NSString stringWithFormat:@"%d",[self.textField.text intValue]]])
        {
            NSLog(@"插入失败");
        }
        
    }
    
    if (![manager.basae executeUpdate:@"update Cart set choose=? where productSysNo=?",@"1",self.productSysNo])
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
    


    self.cartBtn.selected=YES;
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.4];
    
//    [self createLabel:@"加入成功!"];
//    [QYHProgressHUD showHUDInView:self.view onlyMessage:@"加入成功！"];
    
    self.view.userInteractionEnabled=NO;
    [self performSelector:@selector(btnDelay:) withObject:[NSString stringWithFormat:@"%d",count] afterDelay:2.0];
}

- (IBAction)share:(id)sender {
    
    ShareCustomView *shareView = [[ShareCustomView alloc]init];
    
    [shareView show];

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
    if (_isCole)
    {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.3, self.view.frame.size.height/1.5, 130, 35)];
        _label.font=[UIFont systemFontOfSize:14];
        _isCole=NO;
    }else
    {
        
        _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.9, self.view.frame.size.height-100, 100, 35)];
    }
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
    [UIView animateWithDuration:2.0 animations:^{
        
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
        label1.hidden=YES;
    }else
    {
        label1=[[UILabel alloc]initWithFrame:CGRectMake(42, 0, 13, 13)];
        label1.font=[UIFont systemFontOfSize:10];
        label1.textAlignment=NSTextAlignmentCenter;
        
        label1.textColor=[UIColor whiteColor];
        label1.layer.borderWidth  = 1.0f;
        label1.layer.borderColor  = [UIColor orangeColor].CGColor;
        label1.layer.backgroundColor =[UIColor orangeColor].CGColor;
        label1.layer.cornerRadius = 6.0f;
        
        [self.cartBtn addSubview:label1];
        
        label1.hidden=NO;
        label1.text=noti.object;
        label1.adjustsFontSizeToFitWidth=YES;
   
    }
}


- (IBAction)pushToCart:(id)sender {
    
    CartViewController *cartVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
//    cartVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:cartVC animated:YES completion:nil];
    cartVC.second=@"1";
    [self.navigationController pushViewController:cartVC animated:NO];
    [self presentViewController:cartVC animated:YES completion:nil];
}




- (void)backTo
{
//    [_headView endRefreshing];
    
    
    if (_block)
    {
        _block(_isReviewsSelected);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-2] animated:NO];


}



- (IBAction)colectionBtn:(id)sender {
    
    _isCole=YES;
    
    if (self.coleBtn.selected)
    {
//        [self createLabel:@"您已收藏过该商品!"];
        [QYHProgressHUD showSuccessHUD:nil message:@"取消商品收藏成功"];
        
        FMDBmanager *manager=[FMDBmanager shareInstance];
        
        if (![manager.basae executeUpdate:@"delete from Colection where productSysNo=?",self.productSysNo])
        {
            NSLog(@"删除失败");
        }

    }else
    {
        
//        [self createLabel:@"商品收藏成功"];
        [QYHProgressHUD showSuccessHUD:nil message:@"商品收藏成功"];
        
        FMDBmanager *manager=[FMDBmanager shareInstance];
        
        if (![manager.basae executeUpdate:@"insert into Colection(imageUrl,productName,productSysNo,price) values (?,?,?,?)",self.imageUrl,self.productName,self.productSysNo,self.price])
        {
            NSLog(@"插入失败");
        }
        
        
    }
    
     self.coleBtn.selected = !self.coleBtn.selected;

}

//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [_webView loadRequest:nil];
//    [_webView removeFromSuperview];
//    _webView = nil;
//    _webView.delegate = nil;
//    [_webView stopLoading];
//}
//
//
//-(void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
