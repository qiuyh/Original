//
//  MyColectionViewController.m
//  Original
//
//  Created by qianfeng on 15/9/20.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "MyColectionViewController.h"
#import "FMDBmanager.h"
#import "CartViewController.h"
#import "CollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "CollectionModel.h"
#import "DetailViewController.h"
#import "QYHProgressHUD.h"


@interface MyColectionViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UILabel *label;
    NSMutableArray *_dataArray;
    UIImageView *_imgaView;
    UILabel *_label;
    BOOL _isBuy;
    BOOL _isType;
    BOOL _isSel1;
    BOOL _isSel2;
    BOOL _isShow;
    int _row;
  
    UITextField *_textField;
    UIButton *_endBtn;
    CollectionCell *_cell2;
    
    BOOL _isSel11;
    BOOL _isSel22;
    UITextField *_textField2;
    UIButton *_endBtn2;

}
@property (weak, nonatomic) IBOutlet UIButton *subscriptionBuuton;

@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIImageView *noColleImage;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIView *tipSmallView;


@end

@implementation MyColectionViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(labelText:) name:@"label" object:nil];
        
        _dataArray=[NSMutableArray array];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObse];
}


-(void)viewWillAppear:(BOOL)animated
{
    [_dataArray removeAllObjects];
    [self addObse];
}

- (void)addObse
{
    self.bigView.hidden=YES;
    self.tipSmallView.hidden=YES;
    
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
        CollectionModel *model=[[CollectionModel alloc]init];
        model.imageUrl=[rs2 stringForColumn:@"imageUrl"];
        model.productName=[rs2 stringForColumn:@"productName"];
        model.productSysNo=[rs2 stringForColumn:@"productSysNo"];
        model.price=[rs2 stringForColumn:@"price"];
        [_dataArray addObject:model];
    }
    [self.myTableView reloadData];
    [self showAndHide];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"label" object:[NSString stringWithFormat:@"%d",count]];
    
    self.myTableView.rowHeight=100;//

}

- (void)showAndHide
{
    if (_dataArray.count==0)
    {
        self.noColleImage.hidden=NO;
        _subscriptionBuuton.hidden=YES;
        self.myTableView.hidden=YES;
    }else
    {
        self.noColleImage.hidden=YES;
        _subscriptionBuuton.hidden=NO;
        self.myTableView.hidden=NO;
    }

}

//返回
- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

//一键订阅
- (IBAction)subScription:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    _endBtn2=button;
    if (button.selected)
    {
        self.bigView.hidden=NO;
        self.tipSmallView.hidden=NO;
    }else
    {
        self.bigView.hidden=YES;
        self.tipSmallView.hidden=YES;
    }
    
}


- (IBAction)dec:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        _isSel11=YES;
    }else
    {
        _isSel11=NO;
    }
}

- (IBAction)asc:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        _isSel22=YES;
    }else
    {
        _isSel22=NO;
    }
}

- (IBAction)okdone:(id)sender {
    
    if (!_isSel11&&!_isSel22)
    {
//        [self createLabel:@"选择您要订阅的信息"];
        [QYHProgressHUD showErrorHUD:nil message:@"选择您要订阅的信息"];
    }else if (_textField2.text.length==0)
    {
//        [self createLabel:@"请输入邮箱地址!"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入邮箱地址!"];
        
    }else if (![self validateEmail:_textField2.text])
    {
//        [self createLabel:@"请输入合法的邮箱"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的邮箱"];
    }else
    {
//        [self createLabel:@"恭喜您! 更新成功"];
        [QYHProgressHUD showSuccessHUD:nil message:@"恭喜您! 更新成功"];
        [self performSelector:@selector(tipDelay2:) withObject:_endBtn2 afterDelay:0.3];
    }

}

- (void)tipDelay2:(UIButton *)button
{
    [self subScription:button];
}


- (IBAction)myFiel:(id)sender {
    
    UITextField *fiel=(UITextField *)sender;
    _textField2=fiel;
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

- (IBAction)orderNoti:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    
    if (button!=_endBtn&&_endBtn.selected)
    {
        _endBtn.selected=NO;
        _cell2.notiView.hidden=YES;
        _cell2.notiHeightConstraint.constant=0;
    }

    CollectionCell * cell = (CollectionCell *)[[sender superview] superview];
    _cell2=cell;
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    
    
    if (button.selected)
    {
        _isShow=YES;
        cell.notiView.hidden=NO;
        _cell2.notiHeightConstraint.constant=54;
        
    }else
    {
        _isShow=NO;
        cell.notiView.hidden=YES;
        _cell2.notiHeightConstraint.constant=0;
    }
    
    _endBtn=button;
    _row=indexPath.row;
    [self.myTableView reloadData];
}

- (IBAction)cancel:(id)sender {
    
    CollectionCell * cell = (CollectionCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    CollectionModel *model=_dataArray[indexPath.row];
    
    FMDBmanager *manager=[FMDBmanager shareInstance];
    
    if (![manager.basae executeUpdate:@"delete from Colection where productSysNo=?",model.productSysNo])
    {
        NSLog(@"删除失败");
    }
    
    
    // 1.数据源删除
    [_dataArray removeObjectAtIndex:indexPath.row];
    
    //2.界面删除
    [_myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self showAndHide];
}

- (IBAction)decent:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        _isSel1=YES;
    }else
    {
        _isSel1=NO;
    }
}

- (IBAction)writo:(id)sender {
    
    UIButton *button=(UIButton *)sender;
    button.selected=!button.selected;
    if (button.selected)
    {
        _isSel2=YES;
    }else
    {
        _isSel2=NO;
    }

}
- (IBAction)done:(id)sender {
    
    if (!_isSel1&&!_isSel2)
    {
//        [self createLabel:@"选择您要订阅的信息"];
        [QYHProgressHUD showErrorHUD:nil message:@"选择您要订阅的信息"];
    }else if (_textField.text.length==0)
    {
//        [self createLabel:@"请输入邮箱地址!"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入邮箱地址!"];
        
    }else if (![self validateEmail:_textField.text])
    {
//        [self createLabel:@"请输入合法的邮箱"];
        [QYHProgressHUD showErrorHUD:nil message:@"请输入合法的邮箱"];
    }else
    {
//        [self createLabel:@"恭喜您! 更新成功"];
        [QYHProgressHUD showSuccessHUD:nil message:@"恭喜您! 更新成功"];
        [self performSelector:@selector(tipDelay) withObject:nil afterDelay:0.3];
    }
}

- (void)tipDelay
{
    [self orderNoti:_endBtn];
}

- (IBAction)beginField:(id)sender {
     _isType=YES;
}
- (IBAction)endField:(id)sender {
     _isType=NO;
}

- (IBAction)textField:(id)sender {
    
    UITextField *fiel=(UITextField *)sender;
    _textField=fiel;
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)addCart:(id)sender {
    
    CollectionCell * cell = (CollectionCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    
    //取得imgview在self.view的位置
    CGRect rect = [cell convertRect:cell.imgView.frame toView:[_myTableView superview]];

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
    
    
    
    CollectionModel *model=_dataArray[indexPath.row];
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


- (void)delay
{
    self.cartBtn.selected=NO;
    [QYHProgressHUD showSuccessHUD:nil message:@"加入成功！"];
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
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    [cell setBlock:^(int n, UIButton *button)
    {
        switch (n)
        {
            case 1:
                [self orderNoti:button];
                break;
            case 2:
                [self cancel:button];
                break;
            case 3:
                [self addCart:button];
                break;
                
            default:
                break;
        }    }];
    
    CollectionModel *model=_dataArray[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLabel.text=model.productName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isShow&&indexPath.row==_row)
    {
        return 160 + (self.view.frame.size.width-320.0)/2.5;
    }else
    {
        return 106 + (self.view.frame.size.width-320.0)/2.5;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isType)
    {
        [self.view endEditing:YES];
        _isType=NO;
    
    }else
    {
        
        DetailViewController *detailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        
        CollectionModel *model=_dataArray[indexPath.row];
        detailVC.productSysNo=model.productSysNo;
//        detailVC.present=@"1";
        [self presentViewController:detailVC animated:NO completion:nil];
//        [self.navigationController pushViewController:detailVC animated:NO];
        
    }
  
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (IBAction)pushToCart:(id)sender {
    
    CartViewController *cartVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewController"];
    cartVC.second=@"1";
    [self.navigationController pushViewController:cartVC animated:NO];
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
