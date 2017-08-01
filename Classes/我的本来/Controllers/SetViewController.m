//
//  SetViewController.m
//  Original
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 qiuyognhuai. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "HelpViewController.h"
#import "TabBarController.h"
#import "QYHProgressHUD.h"
#import "HttpreQuestManager.h"
#import "QYHProgressHUD.h"
#import "UserStorage.h"
#import "NSString+Validate.h"
#import "AFHTTPSessionManager.h"


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    NSMutableArray *_imgArray;
    NSMutableArray *_titleArray;
    UILabel *_label;
    
    NSURL *updateUrl;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBttom;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@end

@implementation SetViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _imgArray=[NSMutableArray array];
        _titleArray=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated
{
    TabBarController *tab =(TabBarController *) self.tabBarController;
    tab.myTabBar.hidden=NO;
    
    if ([UserStorage shareInstance].isLogined)
    {
        self.exitBtn.hidden = NO;
        
    }else
    {
        self.exitBtn.hidden = YES;
    }
}



- (void)getData
{
    _imgArray=[NSMutableArray arrayWithObjects:@"user_clear_catch",@"user_give_mark",@"user_help",@"user_check_version", nil];
    _titleArray=[NSMutableArray arrayWithObjects:@"清除缓存",@"给我评分",@"使用帮助",@"检测版本更新", nil];
    
    self.myTableView.rowHeight=60;
    self.tableBttom.constant=self.myTableView.rowHeight*4+5;
    [self.myTableView reloadData];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)lonout1:(SSEBaseUser *)user

{
    
    BOOL success = [SSEThirdPartyLoginHelper logout:user];
    
    if (success)
    {
        [UserStorage shareInstance].isPopRoot = YES;
        [QYHProgressHUD showSuccessHUD:nil message:@"退出账号成功"];
        
        [UserStorage shareInstance].isLogined = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        [QYHProgressHUD showErrorHUD:nil message:@"退出账号失败"];
    }
    


}


- (void)lonout2
{

    
    [QYHProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *fileName = @"info.json";
    
    NSString *imageUrl  = [UserStorage shareInstance].imageUrl;
    NSString *passWord  = [UserStorage shareInstance].passWord;
    NSString *nickName  = [UserStorage shareInstance].nickname;
    BOOL      isRegist  = YES;
    BOOL   loginStatus  = NO;
    
    NSDictionary *dic   = @{@"imageUrl"   : imageUrl,
                            @"passWord"   : passWord,
                            @"nickName"   : nickName,
                            @"isRegist"   : @(isRegist),
                            @"loginStatus": @(loginStatus)};
    
    NSString *str = [NSString dictionaryToJson:dic];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    
    [[QYHQiNiuRequestManarger shareInstance]updateFile:fileName withphotoNumber:nil data:data Success:^(id responseObject) {

        [UserStorage shareInstance].isPopRoot = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [QYHProgressHUD showSuccessHUD:nil message:@"退出账号成功"];
        
        [UserStorage shareInstance].isLogined = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(NSError *error) {
        
        
        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
        [QYHProgressHUD showErrorHUD:nil message:@"退出账号失败"];
        
        
        NSLog(@"退出账号失败==%@",error);
    }];
    
    //
    //    [QYHProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [[HttpreQuestManager shareInstance]logoutSuccess:^(id responseObject) {
    //
//        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
//        
//        NSLog(@"responseObject==%@",responseObject);
//        
//        if ([responseObject[@"status"] integerValue] == 1)
//        {
//            [UserStorage shareInstance].token     = @"";
//            [UserStorage shareInstance].isLogined = NO;
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else{
//            
//            [QYHProgressHUD showErrorHUD:self.view message:@"退出账号失败"];
//            
//        }
//        
//        
//        
//    } failure:^(NSError *error) {
//        
//        [QYHProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [QYHProgressHUD showErrorHUD:self.view message:@"退出账号失败"];
//        NSLog(@"退出账号失败！");
//        
//    }];

}

- (IBAction)exit:(id)sender {
    
    SSEBaseUser *user = [UserStorage shareInstance].user;
    
    if (user)
    {
        [self lonout1:user];
        
    }else
    {
        [self lonout2];
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
    return _imgArray.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"5555555555");
    
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.imgView.image=[UIImage imageNamed:_imgArray[indexPath.row]];
    cell.titleLabel.text=_titleArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        
        
        
        // 一段清理缓存的代码如下：
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//            
//            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//            
////            NSLog(@"files :%d",[files count]);
//            
//            for (NSString *p in files)
//            {
//                NSError *error;
//                NSString *path = [cachPath stringByAppendingPathComponent:p];
//                if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//                {
//                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                }
//            }
//            
//            [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
//            
        
            //缓存大小
            NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [cache objectAtIndex:0] ;
            float fileSize = [self folderSizeAtPath:cachePath];
            
            NSString *cacheSize = [NSString stringWithFormat:@"%.2fM",fileSize];
            
            [self clearCacheMemory:cacheSize];
            
            
//        });
    }else if (indexPath.row==1)
    {
        
//        NSString *str = [NSString stringWithFormat:
//                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
//                         1108296415];
        
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1108296415&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
        
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        http://pingma.qq.com/mstat/report
        
    }else if (indexPath.row==2)
    {
        HelpViewController *helpVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        
        [self.navigationController pushViewController:helpVC animated:YES];
        
        TabBarController *tab =(TabBarController *) self.tabBarController;
        tab.myTabBar.hidden=YES;
        
    }else if (indexPath.row==3)
    {
        [self checkNewVersion];
    }

}

-(void)clearCacheSuccess
{
//    [self createLabel:@"清理成功"];
    [QYHProgressHUD showSuccessHUD:nil message:@"清除成功！"];
}


#pragma mark - 检查版本更新
- (void)checkNewVersion {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://itunes.apple.com/lookup?id=1108296415" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"检查版本更新,responseObject===%@",responseObject);
        // 请求成功
        // 字典接收请求到的JSon
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        // 解析请求到的JSon
        NSArray *results = [responseDict objectForKey:@"results"];
        NSDictionary *finalDict = [results firstObject];
        // 获取APP下载地址
        NSString *trackViewUrl = [finalDict objectForKey:@"trackViewUrl"];
        updateUrl = [NSURL URLWithString:trackViewUrl];
        // 获取官网APP的版本号
        NSString *newVersion = [finalDict objectForKey:@"version"];
       
        // 获取本地项目版本号
        // 拿到项目的infoPlist文件中所有内容
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        // 获取到当前工程版本号
        NSString *localVersion = [infoDict objectForKey:@"CFBundleVersion"];
        
        NSLog(@"newVersion==%@",newVersion);
        
        // 对比两处版本号
        if (![newVersion isEqualToString: localVersion]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本可用,请安装更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该版本已是最新版本,无需更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 请求失败
        // 返回请求失败的原因
        NSLog(@"NSError:%@", error);
    }];
    
}

//创建label(提示作用)
- (void)createLabel:(NSString *)title
{
    [_label removeFromSuperview];//先把原来的删除
    _label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3.0, self.view.frame.size.height-120, 100, 35)];
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


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        // 跳转到下载页面
        [[UIApplication sharedApplication] openURL:updateUrl];
        
    }else if (alertView.tag == 2) {
        
        
    }
}


#pragma mark - 计算缓存大小
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark - 清除缓存
//清理缓存
- (void)clearCacheMemory:(NSString *)cacheSize
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSLog(@"files :%lu",(unsigned long)[files count]);
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    
    [QYHProgressHUD showSuccessHUD:nil message:[NSString stringWithFormat:@"已清除%@",cacheSize]];

//    [qyh showError:@"清除成功"];
//    [self.webView stringByEvaluatingJavaScriptFromString:self.cleanCacheCallBack];
}


////计算单个文件大小
//+(float)fileSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:path]){
//        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
//        return size/1024.0/1024.0;
//    }
//    return 0;
//}
//
////计算目录大小
//+(float)folderSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    float folderSize;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            folderSize +=[FileService fileSizeAtPath:absolutePath];
//        }
//        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        return folderSize;
//    }
//    return 0;
//}
//
////清理缓存文件
//+(void)clearCache:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
//    [[SDImageCache sharedImageCache] cleanDisk];
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
