//
//  CartViewController.m
//  Original
//
//  Created by qianfeng on 15/9/19.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "FMDBmanager.h"
#import "CartModel.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "TabBarController.h"

@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    BOOL _isType;
    NSString *_isChoose;
    BOOL _isAll;
    NSIndexPath *_index;
    UIImageView *imgView3;
    UILabel *label3;
    UIButton *button3;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *postage;
@property (weak, nonatomic) IBOutlet UIView *allChooseView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *allChooseBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIImageView *navBar;

@property (weak, nonatomic) IBOutlet UILabel *tilte;

@property (weak, nonatomic) IBOutlet UIButton *back;


@end

@implementation CartViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray=[[NSMutableArray alloc]init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgView3=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-40, self.view.frame.size.height/2.8, 80, 80)];
    imgView3.image=[UIImage imageNamed:@"cartempty"];
    
    label3=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.5,  self.view.frame.size.height/2.8+90, 150, 21)];
    label3.text=@"这里还没有好吃的哦~";
    label3.font=[UIFont systemFontOfSize:14];
    label3.textAlignment=NSTextAlignmentCenter;
    
    
    button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(self.view.frame.size.width/2.0-100,  CGRectGetMaxY(label3.frame) + 20, 200, 35);
    button3.backgroundColor=[UIColor colorWithRed:157/255.0 green:202/255.0 blue:49/255.0 alpha:1.0];
    [button3 setTitle:@"随便逛" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font=[UIFont systemFontOfSize:20];
    
    [button3 addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imgView3];
    [self.view addSubview:label3];
    [self.view addSubview:button3];
 
  }


-(void)dealloc
{
    
}


- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    _isType=YES;
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    _isType=NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.editBtn.selected=YES;
    [self editting:self.editBtn];
//    [self noCart];
    
    [_dataArray removeAllObjects];
    [self getDataFromBaese];
    
    [self allCountPrice];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)getDataFromBaese
{
    _myTableView.rowHeight=70;
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    while ([rs next])
    {
        CartModel *model=[[CartModel alloc]init];
        model.imageUrl=[rs stringForColumn:@"imageUrl"];
        model.price=[rs stringForColumn:@"price"];
        model.productName=[rs stringForColumn:@"productName"];
        model.productSysNo=[rs stringForColumn:@"productSysNo"];
        model.num=[rs stringForColumn:@"num"];

        if ([[rs stringForColumn:@"choose"] isEqualToString:@"0"])
        {
            if (![manager.basae executeUpdate:@"update Cart set choose=? where productSysNo=?",@"0",[rs stringForColumn:@"productSysNo"]])
            {
                NSLog(@"修改失败");
            }
            
            model.choose=@"0";
            
        }else
        {
            if (![manager.basae executeUpdate:@"update Cart set choose=? where productSysNo=?",@"1",[rs stringForColumn:@"productSysNo"]])
            {
                NSLog(@"修改失败");
            }
            
            model.choose=@"1";
        }
        
        [_dataArray addObject:model];
    }
    
    [self noCart];

}
//没有加入购物车时的提示
- (void)noCart
{
    //    NSLog(@"%d",_dataArray.count);
    if (_dataArray.count==0)
    {
        for (UIView *v in self.view.subviews)
        {
            if (v==self.navBar||v==self.tilte||v==self.back)
            {
                //                  NSLog(@"%d",_dataArray.count);
                
            }else
            {
                //                NSLog(@"%d",_dataArray.count);
                v.hidden=YES;
            }
            
        }
        
        imgView3.hidden = NO;
        label3.hidden   = NO;
        button3.hidden  = NO;
        
    }else
    {
        for (UIView *v in self.view.subviews)
        {
            if (v==self.navBar||v==self.tilte||v==self.back)
            {
                //                  NSLog(@"%d",_dataArray.count);
                
            }else
            {
                //                NSLog(@"%d",_dataArray.count);
                v.hidden=NO;
            }
        }
        
        self.allChooseView.hidden=YES;
        self.deleteBtn.hidden=YES;
        
        imgView3.hidden = YES;
        label3.hidden   = YES;
        button3.hidden  = YES;
        
        [self.myTableView reloadData];
    }
    
}

- (void)backToRoot
{
    [self.navigationController popToRootViewControllerAnimated:NO];
//    self.tabBarController.tabBar.hidden = NO;
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=NO;
    tab.button.selected=NO;
    tab.butt.selected=YES;
    tab.selectedIndex=0;
    
    
}

//编辑
- (IBAction)editting:(id)sender {
    
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        _isAll=YES;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        
        self.label1.hidden=YES;
        self.label2.hidden=YES;
        self.price.hidden=YES;
        self.postage.hidden=YES;
        self.postBtn.hidden=YES;
        
        self.allChooseView.hidden=NO;
        self.deleteBtn.hidden=NO;
        
    }else
    {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        
        self.label1.hidden=NO;
        self.label2.hidden=NO;
        self.price.hidden=NO;
        self.postage.hidden=NO;
        self.postBtn.hidden=NO;
        
        self.allChooseView.hidden=YES;
        self.deleteBtn.hidden=YES;
        
        [self allCountPrice];
    }
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    while ([rs next])
    {
        NSString *str=nil;
        if ([[rs stringForColumn:@"choose"] isEqualToString:@"0"])
        {
            str=@"0";
            
        }else
        {
            str=@"1";
        }
        
        if ([str isEqualToString:@"0"])
        {
            _isAll=NO;

        }

    }
    
    if (_isAll)
    {
        self.allChooseBtn.selected=YES;
    }

    
}
//删除
- (IBAction)delete:(id)sender {
    
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    while ([rs next])
    {
        if ([[rs stringForColumn:@"choose"] isEqualToString:@"1"])
        {
            if (![manager.basae executeUpdate:@"delete from Cart where productSysNo=?",[rs stringForColumn:@"productSysNo"]])
            {
                NSLog(@"删除失败");
            }
            
        }
    }
    
    [_dataArray removeAllObjects];
    [self getDataFromBaese];
    
}
//全选按钮
- (IBAction)allChoose:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    if (button.selected)
    {
        
        while ([rs next])
        {
            if (![manager.basae executeUpdate:@"update Cart set choose=?",@"1"])
            {
                NSLog(@"修改失败");
            }

        }
        
    }else
    {
        while ([rs next])
        {
            if (![manager.basae executeUpdate:@"update Cart set choose=?",@"0"])
            {
                NSLog(@"修改失败");
            }
            
        }

    }
    
    [_dataArray removeAllObjects];
    [self getDataFromBaese];

}

- (IBAction)back:(id)sender {
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
     FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    int count = 0;
    
    while ([rs next])
    {
        count+=[[rs stringForColumn:@"num"] intValue];
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:[NSString stringWithFormat:@"%d",count]];
    
    if ([self.second isEqualToString:@"1"])
    {
        [self.navigationController popViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        TabBarController *tab =(TabBarController *) self.tabBarController;
        tab.myTabBar.hidden=NO;
        tab.button.selected=NO;
        tab.selButton.selected=YES;
        tab.selectedIndex=tab.selButton.tag-100;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
}

- (IBAction)choose:(id)sender {
//    alter table Cart add column choose text;
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    
    CartCell * cell = (CartCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    CartModel *model=_dataArray[indexPath.row];

    if (button.selected)
    {
        _isChoose=@"0";
        self.price.text=[NSString stringWithFormat:@"%0.2f",[self.price.text floatValue]-[model.num intValue]*[model.price floatValue]];
    }else
    {
         _isChoose=@"1";
        self.price.text=[NSString stringWithFormat:@"%0.2f",[self.price.text floatValue]+[model.num intValue]*[model.price floatValue]];
    }

    if ([self.price.text floatValue]>60)
    {
        self.postage.text=@"免";
    }else
    {
        self.postage.text=@"20";
    }
    

  
    FMDBmanager *manager=[FMDBmanager shareInstance];
    //    NSLog(@"%@",feild.text);
    if (![manager.basae executeUpdate:@"update Cart set choose=? where productSysNo=?",_isChoose,model.productSysNo])
    {
        NSLog(@"修改失败");
    }
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    _isAll=YES;
    while ([rs next])
    {
        if ([[rs stringForColumn:@"choose"] isEqualToString:@"0"])
        {
            _isAll=NO;
        }
        
    }
    self.allChooseBtn.selected=_isAll;
}


- (IBAction)postageBtn:(id)sender {
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
    
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //imageUrl text,price text,productName text,productSysNo text,num text
    CartModel *model=_dataArray[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    cell.title.text=model.productName;
    cell.price.text=[NSString stringWithFormat:@"¥ %@",model.price];
    cell.buyCount.text=model.num;
    if ([model.choose isEqualToString:@"0"])
    {
        cell.btn.selected=YES;
    }else
    {
        cell.btn.selected=NO;
    }
    
    return cell;
}


//UITableViewCell简单动画效果

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isType)
    {
        [self.view endEditing:YES];
    }else
    {
    
    DetailViewController *detailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    CartModel *model=_dataArray[indexPath.row];
    detailVC.productSysNo=model.productSysNo;
//    detailVC.present=@"1";
    [self presentViewController:detailVC animated:NO completion:nil];
//    [self.navigationController pushViewController:detailVC animated:NO];
        
    }
//    [self.navigationController pushViewController:detailVC animated:NO];
}

//删除操作,需要两个代理方法配合使用
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //indexPath 就是删除的位置,通过代理方法,给我们了
    
    _index=indexPath;
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要删除该商品吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    
    //让提示框显示
    [aler show];

//    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width/3.0;
}

//返回编辑类型.是增加还是删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//定制删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (IBAction)textField:(id)sender {
    
    UITextField *feild=(UITextField *)sender;
    CartCell * cell = (CartCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    CartModel *model=_dataArray[indexPath.row];
    FMDBmanager *manager=[FMDBmanager shareInstance];
    //    NSLog(@"%@",feild.text);
    if (![manager.basae executeUpdate:@"update Cart set num=? where productSysNo=?",feild.text,model.productSysNo])
    {
        NSLog(@"修改失败");
    }

    [self allCountPrice];
}


- (void)allCountPrice
{
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
    
    CGFloat count=0;
    
    while ([rs next])
    {
        count+=[[rs stringForColumn:@"price"] floatValue]*[[rs stringForColumn:@"num"] intValue];

        if (![[rs stringForColumn:@"choose"] isKindOfClass:[NSNull class]])
        {
            if ([[rs stringForColumn:@"choose"] isEqualToString:@"0"])
            {
                count-=[[rs stringForColumn:@"price"] floatValue]*[[rs stringForColumn:@"num"] intValue];
            }
        }
    }
    
    if (count>60)
    {
        self.postage.text=@"免";
    }else
    {
        self.postage.text=@"20";
    }
    
    
    self.price.text=[NSString stringWithFormat:@"%0.2f",count];
}

#pragma mark-UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        FMDBmanager *manager=[FMDBmanager shareInstance];
        
        CartModel *model=_dataArray[_index.row];
        
        if (![manager.basae executeUpdate:@"delete from Cart where productSysNo=?",model.productSysNo])
        {
            NSLog(@"删除失败");
        }
        

//        1.数据源删除
        [_dataArray removeObjectAtIndex:_index.row];
        
        //2.界面删除
        [_myTableView deleteRowsAtIndexPaths:@[_index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self noCart];
        
        FMResultSet *rs =  [manager.basae executeQuery:@"select * from Cart"];
        rs =  [manager.basae executeQuery:@"select * from Cart"];
        
        int count = 0;
        
        while ([rs next])
        {
            count+=[[rs stringForColumn:@"num"] intValue];
        }
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:[NSString stringWithFormat:@"%d",count]];

        [_myTableView reloadData];
        [self allCountPrice];

    }
}


//1、动画效果
//[UIView beginAnimations:@"animationID" context:nil];
//[UIView setAnimationDuration:0.5f];
//[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//[UIView setAnimationRepeatAutoreverses:NO];
//[UIView commitAnimations];
//2、点击tableviewCell翻转
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [UIView beginAnimations:@"animationID" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    switch (indexPath.row) {
//        case 0:
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 1:
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 2:
//            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 3:
//            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        default:
//            break;
//    }
//    
//    [UIView commitAnimations];
//}
////3、点击按钮 前三个Cell翻转
//
//for (int i = 0; i < 3; i ++) {
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] cache:NO];
//    [UIView commitAnimations];
//}
////4、点击按钮 全部Cell翻转
//
//int rows = [myTableView numberOfRowsInSection:0];
//for (int i = rows - 1; i > rows - 1 - 4; i--) {
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationRepeatAutoreverses:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] cache:NO];
//    [UIView commitAnimations];
//}

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
