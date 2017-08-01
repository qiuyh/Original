//
//  DetailViewController.m
//  Original
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "DetailViewController.h"
#import "HttpreQuestManager.h"
#import "UIImageView+AFNetworking.h"
#import "ProductDetail.h"
#import "Associate.h"
#import "AssociateContent.h"
#import "ImageDetailViewController.h"
#import "MJRefresh.h"
#import "FMDBmanager.h"
#import "CartViewController.h"
#import "LocationViewController.h"

#import "UserStorage.h"
#import "MBProgressHUD.h"
#import "QYHProgressHUD.h"

#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"



@interface DetailViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *_countArray;//存放广告图片
    NSMutableArray *_dataArray;//数据源
    
    NSTimer *_timer;//定时器
    int _count;//计算滑动第几张广告图片
    
    NSString *_hasOrigPrice;//判断是否有原价
    NSString *_productSysNO;//对应的编号
    NSMutableArray *_associateDataArray;//存放Associate数据
    UIButton *_seletButton;//记录前一个按钮(分类按钮)
    BOOL _isClick;//按钮是否被选中判断,用于移除后再重新加载
    NSMutableArray *_productSys;
    int _numCount;

//    MJRefreshFooterView *_footView;//
    BOOL _isSel;
    UILabel *label1;
    
    NSString *_price;
    UILabel *_label;
    BOOL _isCole;

    
    NSString *_cityName;
    
    NSInteger btnTag;
    UIView *grayView;
    
    YiRefreshHeader *refreshHeader;
    YiRefreshFooter *refreshFooter;
    
    ImageDetailViewController *imgVC;

}
@property (nonatomic,copy) NSString *present;
@property (nonatomic,assign) BOOL isOne;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageContr;

@property (weak, nonatomic) IBOutlet UILabel *productName;//商品名
@property (weak, nonatomic) IBOutlet UILabel *promotionWord;//描述语

@property (weak, nonatomic) IBOutlet UILabel *priceName;//


@property (weak, nonatomic) IBOutlet UILabel *origPriceName;


@property (weak, nonatomic) IBOutlet UIButton *tipContents;//提示内容
@property (weak, nonatomic) IBOutlet UIButton *tipArrow;//提示内容右边的箭头
//@property (weak, nonatomic) IBOutlet UIButton *detailButton;//详情页按钮

@property (weak, nonatomic) IBOutlet UIView *associateView;//装种类规格得View
@property (weak, nonatomic) IBOutlet UILabel *attr2Name;
@property (weak, nonatomic) IBOutlet UILabel *attr2Value;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *oldImgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipArrowHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipArrowWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attr2ValueHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attr2NameHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *coleBtn;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIButton *tipBnt;

@end

@implementation DetailViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _countArray=[[NSMutableArray alloc]init];
        _dataArray=[[NSMutableArray alloc]init];
        _associateDataArray=[[NSMutableArray alloc]init];
        _productSys=[[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"city" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    
    NSLog(@"self.productSysNo==%@",self.productSysNo);
    
    [self getPageFromNet];
    //    NSLog(@"%@",self.productSysNo);
    //    初始化头尾View
    
    
     _cityName=[UserStorage shareInstance].cityName;
    
    [self.locationBtn setTitle:_cityName forState:UIControlStateNormal];
   
    
//    _footView=[[MJRefreshFooterView alloc]init];
//    _footView.scrollView=_myScrollView;
//    _footView.delegate=self;
    
    
    _myScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-49);
 
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=_myScrollView;

    typeof(refreshFooter) __weak weakRefreshFooter = refreshFooter;
    typeof(self) __weak weakSelf = self;
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            sleep(0.2);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                typeof(weakRefreshFooter) __strong strongRefreshFooter = weakRefreshFooter;
                // 主线程刷新视图
                typeof(weakSelf) __strong strongSelf = weakSelf;
                
                if (strongSelf.isOne)
                {
                    [strongSelf nextdetail:nil];
                    
                    strongSelf.isOne = NO;
                }
                
                [strongRefreshFooter endRefreshing];
            });
        });
    };


}




- (void)cityName:(NSNotification *)info
{
    [_locationBtn setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];
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
//    self.tipContents.titleLabel.lineBreakMode=
    
    self.tipArrow.selected=NO;
    self.tipContentHeight.constant=30;
    self.tipContents.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    self.tipArrowWidth.constant=46;
    self.tipArrowHeight.constant=30;
    
    //    _myScrollView.contentOffset=CGPointMake(0, 0);
    
    [_locationBtn setTitle:[UserStorage shareInstance].cityName forState:UIControlStateNormal];

      [self addObse];
    
    _isOne  = YES;
   
}


//刷新完要释放
- (void)dealloc
{
    //使用完毕,需要释放.要不然会导致崩溃
//    [_footView free];
    

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"city" object:nil];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"label" object:nil];

//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



//获取广告图片
- (void)getPageFromNet
{
    if (!_isClick)
    {
         self.ButtonViewHeight.constant=0;
    }
   
    self.tipContentHeight.constant=30;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HttpreQuestManager *manager=[HttpreQuestManager shareInstance];
    [manager getProductDetailWithproductSysNo:[self.productSysNo intValue] success:^(id responseObject) {
        
        NSLog(@"responseObject==%@",responseObject);
        
        self.myScrollView.hidden = NO;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        _count=50;
        
        if (_isClick)
        {
            [_timer invalidate];
            _timer=nil;
            
            [_countArray  removeAllObjects];
            for (UIView *v in _buttonView.subviews)
            {
                [v removeFromSuperview];
            }
        }
        
        [_countArray addObject:@""];
        
        for (NSString *str in responseObject[@"imageUrls"])
        {
            [_countArray addObject:str];
        }
        
        [_countArray addObject:@""];
        
        _numCount=0;
        
        if (![responseObject[@"associate"]isKindOfClass:[NSNull class]])
        {
            for (NSDictionary *associateDic in responseObject[@"associate"])
            {
                Associate *model1=[[Associate alloc]init];
                model1.associateName=associateDic[@"associateName"];
                
                NSArray *contentArray=associateDic[@"associateContent"];
                
                [self createButton:contentArray withTitle:model1.associateName];
                
                for (NSDictionary *contentDic in contentArray)
                {
                    AssociateContent *model2=[[AssociateContent alloc]init];
                    model2.isSelect=contentDic[@"isSelect"];
                    model2.optionName=contentDic[@"optionName"];
                    model2.productSysNo=contentDic[@"productSysNo"];
                    
                    [model1.associateArray addObject:model2];
                }
                
                [_associateDataArray addObject:model1];
            }
            
            self.attr2Name.text=@"";
            self.attr2Value.text=@"";
            self.attr2NameHeight.constant=0;
            self.attr2ValueHeight.constant=0;
            
        }else
        {
            NSDictionary *attributesDic=[responseObject[@"attributes"] firstObject];
            NSDictionary *attr1ValueDic=[attributesDic[@"attr1Value"] firstObject];
            
            if (![responseObject[@"attributes"] count]&&([attr1ValueDic[@"attr2Name"] length]!=0&&[attr1ValueDic[@"attr2Value"] length]!=0))
            {
                
                self.attr2Name.text=attr1ValueDic[@"attr2Name"];
                self.attr2Value.text=attr1ValueDic[@"attr2Value"];
                
            }else
            {
                self.attr2Name.text=@"";
                self.attr2Value.text=@"";
                
                self.attr2NameHeight.constant=0;
                self.attr2ValueHeight.constant=0;
            }
           
        }
        
        self.productName.text=responseObject[@"productName"];
        if (self.productName.text.length*20/self.view.frame.size.width)
        {
            self.nameHeight.constant=45;
        }
        if ([responseObject[@"promotionWord"]isKindOfClass:[NSNull class]])
        {
            self.promotionWord.text=@"";
            self.promotionHeight.constant=0;
        }else
        {
        
            self.promotionWord.text=responseObject[@"promotionWord"];
            self.promotionHeight.constant=self.promotionWord.text.length*17/self.view.frame.size.width*21;
        }
        
        [self.tipContents setTitle:responseObject[@"tip"][@"tipContent"] forState:UIControlStateNormal];
        if (self.tipContents.currentTitle.length==0)
        {
            self.tipArrow.hidden=YES;
            self.tipContents.hidden=YES;
            self.tipArrowHeight.constant=0;
            self.tipContentHeight.constant=0;
        }
        
        NSDictionary *priceDic=responseObject[@"price"];
        _hasOrigPrice=priceDic[@"hasOrigPrice"];
        if ([_hasOrigPrice isEqualToString:@"1"])
        {
            self.origPriceName.text=[priceDic[@"origPriceName"] stringByAppendingFormat:@": ¥%@",priceDic[@"origPrice"]];

        }else
        {
            self.origPriceName.text=@"";
            self.oldImgView.hidden=YES;

        }
        self.priceName.text=[priceDic[@"priceName"]stringByAppendingFormat:@": ¥%@",priceDic[@"price"]];
        _price=priceDic[@"price"];

        
        [self adverScroll];
        
        
        imgVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
        imgVC.productSysNo=self.productSysNo;
        imgVC.productName=self.productName.text;
        imgVC.price=_price;
        imgVC.imageUrl=_countArray[1];
        
        imgVC.isReviewsSelected=_isSel;
        [imgVC setBlock:^(BOOL isSel) {
            
            _isSel=isSel;
        }];

        
        
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

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"获取商品详情失败,error==%@",error);
        
    }];
    
}

- (void)click
{
    [grayView removeFromSuperview];
    [self getPageFromNet];
}

- (void)createButton:(NSArray *)listArray withTitle:(NSString *)name
{
    
    if (1)//判断是否是进来的第一次
    {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5+_numCount*30, 60, 25)];
        
        label.text=[name stringByAppendingString:@" :"];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:13];
        [_buttonView addSubview:label];
        
        int hang=1;//按钮创建在第几行
        
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];

        
        for (int i=0; i<listArray.count; i++)
        {
            NSDictionary *dic=listArray[i];
            
            [_productSys addObject:dic[@"productSysNo"]];
            
            NSString *titleName = dic[@"optionName"];
            
            CGFloat ButtonWith = 1.2*[titleName boundingRectWithSize:
                                    CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size.width;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            
            int x;//创建按钮的位置x
            
             x=10+CGRectGetMaxX(button1.frame);
        
        
            if ((x+ButtonWith+10)*1.0/self.view.frame.size.width >=1 )
            {
                
                hang++;
                x=40;
                
            }
            
            if (x<40)
            {
                x = 40;
            }
            
            //设置按钮的属性
            button.frame=CGRectMake(x,30*(hang+_numCount),ButtonWith, 25);
            
            button1 = button;
            
            [button setTitle:dic[@"optionName"] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [button setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall2.9.png"] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"catsmall_green.9.png"] forState:UIControlStateSelected];
            //打上tag
            button.tag=100+btnTag;
            btnTag++;
            //如果是第一次就把第一个按钮("全部按钮")选中
            if ([dic[@"isSelect"] isEqualToString:@"1"])
            {
               
                button.selected=YES;
                _seletButton=button;
            }
            //添加事件
            [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonView addSubview:button];
            
        }
       
        _numCount+=hang+1;
//        把_listViewHeight的约束更改
        self.ButtonViewHeight.constant=30*(_numCount)+5;
        //获取_listView的高度
    }
}

//分类按钮事件
- (void)selectClick:(UIButton *)button
{
    
    _seletButton.selected=NO;
    button.selected=YES;
    _seletButton=button;
    
    _isClick=YES;//记录要删除原来的数据
    self.productSysNo=_productSys[button.tag-100];
    //进入对应编号的刷新数据
    [self getPageFromNet];
    
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






- (IBAction)showTipContent:(id)sender {
    
    self.tipArrow.selected=! self.tipArrow.selected;
    if ( self.tipArrow.selected)
    {
        self.tipContents.titleLabel.lineBreakMode=0;
        self.tipContentHeight.constant=self.tipContents.currentTitle.length*10/self.view.frame.size.width*21;
        self.tipArrowWidth.constant=20;
        self.tipArrowHeight.constant=15;
    }else
    {
        self.tipContentHeight.constant=30;
        self.tipContents.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.tipArrowWidth.constant=46;
        self.tipArrowHeight.constant=30;
    }
}


- (IBAction)nextdetail:(id)sender {
    
//    [self.navigationController pushViewController:imgVC animated:NO];
    
//    imgVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imgVC animated:YES completion:nil];
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
        if (![manager.basae executeUpdate:@"insert into Cart(imageUrl,price,productName,productSysNo,num) values (?,?,?,?,?)",_countArray[1],_price,self.productName.text,self.productSysNo,[NSString stringWithFormat:@"%d",[self.textField.text intValue]]])
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
//     [self createLabel:@"加入成功!"];
//    [QYHProgressHUD showHUDInView:self.view onlyMessage:@"加入成功！"];
    
    self.view.userInteractionEnabled=NO;
    [self performSelector:@selector(btnDelay:) withObject:[NSString stringWithFormat:@"%d",count] afterDelay:2.0];
}

- (void)btnDelay:(NSString *)count
{
    self.view.userInteractionEnabled=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:count];
}
- (IBAction)sahre:(id)sender {
    
    ShareCustomView *shareView = [[ShareCustomView alloc]init];
    
    [shareView show];

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
    [QYHProgressHUD showSuccessHUD:self.view message:@"加入成功！"];
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

- (IBAction)location:(id)sender {
    
    
    LocationViewController *locationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationVC.buttonName=[UserStorage shareInstance].cityName;
    locationVC.suggestCityName=[UserStorage shareInstance].suggestCityName;
    [self.navigationController pushViewController:locationVC animated:YES];
    
    [self presentViewController:locationVC animated:YES completion:nil];
    
}




//广告滑动
- (void)adverScroll
{
    if (_countArray.count==3)
    {
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [imgView setImageWithURL:[NSURL URLWithString:_countArray[_countArray.count-2]]];
         [_scrollView addSubview:imgView];
        
        NSLog(@"111111111");
    }else
    {
        //设置scrollView的包含的内容大小
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*_countArray.count, _scrollView.frame.size.height);
        
        
        _pageContr.numberOfPages=_countArray.count-2;
        _pageContr.hidesForSinglePage=YES;
        //通过前后各加多一张来,解决晃一下的问题
        for (int i=0; i<_countArray.count; i++)
        {
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            //如果是第一显示第6张的图片
            if (i ==0)
            {
                [imgView setImageWithURL:[NSURL URLWithString:_countArray[_countArray.count-2]]];
            }else if(i==_countArray.count-1)//如果是第八就显示第一张图片
            {
                [imgView setImageWithURL:[NSURL URLWithString:_countArray[1]]];
            }else
            {
                [imgView setImageWithURL:[NSURL URLWithString:_countArray[i]]];
            }
           
            [_scrollView addSubview:imgView];
            
            if (_countArray.count>3)
            {
                _count=1;
                [_scrollView setContentOffset:CGPointMake(_count*_scrollView.frame.size.width, 0) animated:YES];
            }
            
        }
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollViewTo) userInfo:nil repeats:YES];
    }
}

//定时器事件滑动
- (void)scrollViewTo
{
    if (_countArray.count==3)
    {
        //销毁定时器
        [_timer invalidate];
        _timer=nil;

    }else
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
}
//返回
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
//    
//    if ([self.present isEqualToString:@"1"])
//    {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }else
//    {
//
//    [self.navigationController popViewControllerAnimated:NO];
//    }
}


#pragma mark-UIScrollViewDelegate
//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_countArray.count == 3)
    {
        return;
    }
    //销毁定时器
    [_timer invalidate];
    _timer=nil;
}
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (_countArray.count == 3)
    {
        return;
    }
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
    
    //重新开始定时器
    _timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollViewTo) userInfo:nil repeats:YES];
    
}


- (IBAction)colectionBtn:(id)sender {
    
    _isCole=YES;
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
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
        
        if (![manager.basae executeUpdate:@"insert into Colection(imageUrl,productName,productSysNo,price) values (?,?,?,?)",_countArray[1],self.productName.text,self.productSysNo,_price])
        {
            NSLog(@"插入失败");
        }
    }
    
       self.coleBtn.selected =!self.coleBtn.selected;

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
