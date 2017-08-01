//
//  NetInterface.h
//  Original
//
//

#ifndef Original_NetInterface_h
#define Original_NetInterface_h



//主页,广告
//lotType=1 广告   lotType=2 主页
#define HOME_PAGE @"http://www.benlai.com/IHome/GetAPPHomePage?localcity=%d&source=3&lotType=%d"

//运费信息
#define MESSAGE @"http://www.benlai.com/Ihome/GetAppMessage?localcity=%d&source=3"
//个人信息
#define CONFIG @"http://www.benlai.com/IHome/GetConfig?localcity=%d&source=3"

//进入定位选择的信息
#define SITE_LIST @"http://www.benlai.com/IHome/SiteList"
//定位  //localcity=246代表城市
#define GET_CITY @"http://www.benlai.com/IAccount/GetRecommendationCityInfoNew?localcity=%d&source=3"

//华南站包邮须知，点击了解详情
#define ADVERTISE @"http://www.benlai.com/IHome/APPIndexScrollingAdvertise?localcity=%d&source=3"

//谢师恩里面的信息  limit=20显示多少条信息 offset=0第几页 SysNo=4233不同类型的ID
#define SUBJECT @"http://www.benlai.com/IHome/GetAppSubject?limit=20&localcity=246&source=3&SysNo=%d&offset=%d"

//我的本来
#define USER @"http://www.benlai.com/IUserHome/index?localcity=%d&source=3"

//热门搜索
#define RECOMMEND_SEARCH_KEY @"http://www.benlai.com/IProductList/RecommendSearchKey?localcity=246&source=3"

//搜索结果 query=%E5%A4%A7%E9%97%B8%E8%9F%B9   搜索关键词  offset=0显示第几页  limit=20每页显示多少条
#define QUERY @"http://www.benlai.com/IProductList/List?limit=20&localcity=246&sort=%d&source=3&query=%@&offset=%d"

//新品
#define NEW_PRODUCTS @"http://www.benlai.com/IProductList/NewAppProducts?limit=20&localcity=246&sort=0&source=3&offset=%d"

//热销排行信息
#define HOT_PRODUCTS @"http://www.benlai.com/IProductList/HotProducts?limit=20&localcity=246&sort=0&source=3&offset=%d"
//手机专享
#define BIG_Product @"http://m.benlai.com/bigProduct/4222"

//分类
#define CATEGORY_PRODUCTS @"http://www.benlai.com/ICategory/NewC1List?localcity=246&source=3"

//分类中种类的排  sort代表四个排序,c1SysNo代表对应的品种,c2SysNo对应全部还是分类排序
#define PRODUCTS_LIST @"http://www.benlai.com/IProductList/List?limit=20&localcity=246&sort=%d&source=3&c1SysNo=%d&c2SysNo=%d&offset=%d"
//分类中种类的全部
#define PRODUCTS_ALLLIST @"http://www.benlai.com/IProductList/List?limit=20&localcity=246&sort=%d&source=3&c1SysNo=%d&offset=%d"

//新疆红提(一个商品)productSysNo=35373代表对应的商品
#define PRODUCTS_DETAIL @"http://www.benlai.com/IProduct/ProductDetail?localcity=246&source=3&IsPromotions=1&productSysNo=%d"

//商品简介 id=54836代表对应的商品
#define PRODUCTS_DETAIL_ID @"http://www.benlai.com/Product/AppProductDetails?id=%d&localcity=246&source=3"

//评价 全部type=0 差评type=1 中评type=2  好评type=3
#define PRODUCTS_REVIEW_NEW @"http://www.benlai.com/IProduct/ProductReviewsNew?limit=20&localcity=246&source=3&IsPromotions=1&productSysNo=%d&offset=%d&type=%d"

//购物车的商品信息
#define CART @"http://www.benlai.com/ICart/GetPromotionCart?&localcity=%d&source=3"

//8个佳沛奇异果
#define SHARE_TUAN @"http://m.benlai.com/activity/shareTuan?webSiteSysNo=2&deliverySysNo=246&source=3"

//登陆 Pwd密码  customerID账号
#define LOGIN  @"http://m.anong.com/login/mobile"

#define LOGIN1 @"http://www.benlai.com/IAccount/Login?customerID=13726909782&md5Pwd=21218cca77804d2ba1922c33e0151105&LoginType=2&version=2.1.8&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLLoginViewController&sign=604f42301d385d5daa939c1c21028190"
//退出
#define LOGOUT @"http://m.anong.com/logout"

#define SEARCH_KEY @"http://www.benlai.com/IProduct/GetDefaultKeyWorld?"

//使用帮助
#define HELP @"http://www.benlai.com/IUserHome/GetAppQA?version=2.1.5&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLDocumentViewController&sign=838cee7ed0c0edf9655c56a2414163d2"
//相片上传
#define UPLOADFILE @"http://www.benlai.com/IUserHome/UploadFile?version=2.1.8&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLProfileViewController&sign=6557e9e90d1b7074ae5d0becb809ff7a"

//我的本来
#define IUSERHOME @"http://www.benlai.com/IUserHome/index?version=2.1.8&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLProfileViewController&sign=6557e9e90d1b7074ae5d0becb809ff7a"
//编辑昵称
//POST http://m.anong.com/change/name
//{"name":"huai2"}
#define EDITNICKNAME @"http://m.anong.com/change/name"

//获取注册的验证码
#define GETSMSCODE @"http://www.benlai.com/IAccount/GetRegisterSMSCode?cellphone=%@&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLRegisterViewController&sign=92de628e4a766e941a6885c77bca03be"
//填验证码下一步
#define VALSMSCODE @"http://www.benlai.com/IAccount/ValidataSMSCode?cellphone=%@&code=%@&invitatorCode=&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLRegisterViewController&sign=b46a3168ab93920ae00539f310523aa6"
//注册成功
#define REGISER @"http://www.benlai.com/IAccount/RegisterForPhoneNum?customerID=%@&pwd=%@&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLRegisterPasswordViewController&sign=1a90cff2ba3bece38758cb243dbcf4fc"

#define GETSMSCODE1 @" http://www.benlai.com/ICart/GetPromotionCartCount?version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCartDataManager&sign=f3f996d5f7af9a91da3bac21627c22e8"
//我的订单（全部）
#define ALLORDERLIST @"http://www.benlai.com/IOrder/OrderList_All?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLOrderViewController&sign=588b37d1291f35ffc270da640644d77a"
//我的订单(待付款)
#define WATINGPAYORDERLIST @"http://www.benlai.com/IOrder/OrderList_WatingPay?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLOrderViewController&sign=588b37d1291f35ffc270da640644d77a"
//我的订单(配送中)
#define DISORDERLIST @"http://www.benlai.com/IOrder/OrderList_Distribution?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLOrderViewController&sign=588b37d1291f35ffc270da640644d77a"
//我的订单(待评价)
#define REVIEWORDERLIST @"http://www.benlai.com/IOrder/Waitting_Review?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLOrderViewController&sign=588b37d1291f35ffc270da640644d77a"

//商品评价
#define COMMENTPRODUCT @"http://www.benlai.com/IProductList/NoCommentProductListNew?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCommentViewController&sign=1807a594afe2299266454d33bfb9bde9"
//我的收藏
#define MYWISH @"http://www.benlai.com/IUserHome/Wish?offset=0&limit=20&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCollectionViewController&sign=c5b959ccf15666b771ce9f57598e4a60"

//地址管理
#define ADDRESSES @"http://www.benlai.com/IUserHome/Addresses?isFromShopping=0&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLAddressViewController&sign=71d37b2e228082cdf32e82013339c34f"
// 新增或者更改地址
#define UPDATEADDRESSES @"http://www.benlai.com/IUserHome/UpdateAddress?receiveContact=PK%E5%92%AF%E5%95%A6&receiveAddress=illness&receiveCellPhone=13763067912&isDefault=1&brief=%E5%93%88%E5%B7%B4&addressSysno=-1&receiveAreaSysNo=2124&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLNewAddressViewController&sign=854d165b66117fb1a7af3e4b59387501"
//删除地址
#define DELETEADDRESSES @"http://www.benlai.com/IUserHome/DeleteAddress?sysNo=3808519&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLAddressViewController&sign=afd7247278d85917cdc4e2583beeec2d"
//更改密码
#define CHANGEPASSWORD @"http://m.benlai.com/userHome/pInfoCommitModPd"
//oldPhoneNumb=7720401ABC&newPhoneNumb=888888
//更改手机号
#define CHANGEPHONE @"http://m.benlai.com/userHome/pInfoSendSafe"
//phoneNumber=137*****912
//更改手机号
#define CHANGENEWPHONE @"http://m.benlai.com/userHome/pInfoModNewPhone"
//phVerify=363781&phoneNumb=13763067912

//购物车
#define GETCAR @"http://www.benlai.com/ICart/GetPromotionCart?version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCartViewController&sign=a7f7c2903cb86898060a4ea8d45f09c1"
//添加到购物车
#define ADDCAR @"http://www.benlai.com/ICart/AddShoppingCart?productSysNo=47729,1&type=add&cartType=1&isPromotions=1&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCartDataManager&sign=fe78bb8f4eaacd0cfccac3318b5054c8"
//删除购物车
#define DELCAR @"http://www.benlai.com/ICart/DeleteAllCarts?productSysNo=47729,1_35050,1_&isPromotions=1&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLCartViewController&sign=993fbcc066350347b1e9b195dec49d63"


//添加到收藏
#define ADDWISH @"http://www.benlai.com/IUserHome/AddWish?productSysNo=48073&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLProductViewController&sign=3dc2f145cc4942cacc9e41fffbb59d8b"
//取消收藏
#define DELWISH @"http://www.benlai.com/IUserHome/DelWish?productSysNos=48073&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLProductViewController&sign=8660889989679a334a4d08ec68078655"


//分享整个页面
#define SHARURL @"http://www.benlai.com/IShare/ShareUrl?Url=http%253A%252F%252Fm.benlai.com%252Fgz%252FproductNewProducts&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLShareManager&sign=2dd8c522ce8e5e8b3000d07bd39223da"

//http://www.benlai.com/IShare/ShareUrl?Url=http%253A%252F%252Fm.benlai.com%252Fgz%252FproductHotProducts&version=2.1.8&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLShareManager&sign=aa82f54c439026b0d6ceeae46b9b8762

//http://www.benlai.com/IShare/ShareUrl?Url=http%253A%252F%252Fm.benlai.com%252Fhuanan%252Fzt%252F20160419hxmj%253FwebSiteSysNo%253D2%2526deliverySysNo%253D244%2526source%253D1&version=2.1.8&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLShareManager&sign=d101b32a9b627be65bbf3d9485ad245b

//分享某个商品
#define SHARURL1 @"http://www.benlai.com/IShare/ShareUrl?Url=http%253A%252F%252Fm.benlai.com%252Fgz%252Fproduct%252F48073&version=2.1.7&systemVersion=9.2&phoneModel=iPhone&source=1&localcity=244&deviceId=0C7623E0-CAAB-4285-BA0C-AF8830D2CE53&channel=AppStore&pageid=BLShareManager&sign=02d87095f529ecfb24e0e096f2c2bacc"


//获取验证码 {"mobile":"13763067913"}
#define GETAUTHCODE  @"http://m.anong.com/register/validate_mobile"
#define GETAUTHCODE1 @"http://m.anong.com/register/auth_code"
//注册 {"mobile":"13763067912","authCode":"9138","password":"888888","name":"huai"}
#define VALSMSCODE1  @"http://m.anong.com/register/mobile"
//获取个人中
#define GETUSER      @"http://m.anong.com/user_center"
//获取上传照片的token
#define GETSTSTOKEN  @"http://m.anong.com/sts_token"
//返回的数据
//{
//    "RequestId": "11AF49E4-642D-4874-8AF6-89CD6B3F48D8",
//    "AssumedRoleUser": {
//        "AssumedRoleId": "388271644470393137:anong_app",
//        "Arn": "acs:ram::1318328315371629:role\/osswriterrole\/anong_app"
//    },
//    "Credentials": {
//        "AccessKeySecret": "2LrpwTNoQm1CC7NfW6DQKCoFzt6Qt1oRKpdUyY9M9S6N",
//        "AccessKeyId": "STS.Bdb3srzLAzSzYAGNxyyXEfFu7",
//        "Expiration": "2016-04-17T05:45:34Z",
//        "SecurityToken": "CAES9gIIARKAARsDICP17GYCeCP62o3+4D+cTkGvOAOsOGBYvM958nug+qf7\/4cT7wS4yY9bG\/N0prF9ULz0iDGYwaIUiLCJ4U6P2UIArg2PmFNGwWR7Qe3Riu0uheOOulhxf39dsqzp0GqG0HQCisOTiDg8XqG\/M\/17EL0oQbn4Vq+cqN601\/1MGh1TVFMuQmRiM3NyekxBelN6WUFHTnh5eVhFZkZ1NyISMzg4MjcxNjQ0NDcwMzkzMTM3Kglhbm9uZ19hcHAw2OOClsIqOgZSc2FNRDVCSgoBMRpFCgVBbGxvdxIbCgxBY3Rpb25FcXVhbHMSBkFjdGlvbhoDCgEqEh8KDlJlc291cmNlRXF1YWxzEghSZXNvdXJjZRoDCgEqShAxMzE4MzI4MzE1MzcxNjI5UgUyNjg0MloPQXNzdW1lZFJvbGVVc2VyYABqEjM4ODI3MTY0NDQ3MDM5MzEzN3INb3Nzd3JpdGVycm9sZXjtwL3Xs+CrAg=="
//    }
//}

//上传图片
#define UPDATEAREA    @"http://anongtmp.oss-cn-beijing.aliyuncs.com/%@?SecurityToken=%@&Arn=%@&AssumedRoleId=%@&AccessKeyId%@&AccessKeySecret=%@&Expiration=%@&token=%@"
//更改照片
//{"server_id":"11AF49E4-642D-4874-8AF6-89CD6B3F48D8","clientType":"app"}
#define CHANGEAVATAR  @"http://m.anong.com/change/avatar"

//{
//    "success": true
//}

#define GETSTATUS    @"http://m.anong.com/login_status"


//POST http://m.anong.com/register/auth_code HTTP/1.1
//Host: m.anong.com
//state: %2Flogin%2Fmobile
//Accept: application/json, text/plain, */*
//                                        Proxy-Connection: keep-alive
//                                        Accept-Language: zh-cn
//                                        Content-Type: application/json;charset=UTF-8
//                                        Origin: file://
//                                        Content-Length: 24
//                                        {"mobile":"13763067912"}
//                                        
//
//                                        
//                                        POST http://m.anong.com/register/mobile HTTP/1.1
//                                        Host: m.anong.com
//                                        state: %2Flogin%2Fmobile
//                                        Accept: application/json, text/plain, */*
//Proxy-Connection: keep-alive
//Accept-Language: zh-cn
//Content-Type: application/json;charset=UTF-8
//Origin: file://
//Content-Length: 76
//Connection: keep-alive
//{"mobile":"13763067912","authCode":"9138","password":"888888","name":"huai"}
//
//GET http://m.anong.com/login_status 
//
//GET http://m.anong.com/logout 
//
//
//POST http://m.anong.com/login/mobile
//{"mobile":"13763067912","password":"888888"}
//
//
//
//POST http://m.anong.com/login/mobile/loginType
//{"mobile":"13763067912","password":""}
//{"status":0}
//
//
//POST http://m.anong.com/register/validate_mobile
//http://m.anong.com/register/auth_code
//{"mobile":"13763067913"}
//{"status":true,"tips":""}
//
//
//获取图片
//GET http://m.anong.com/coupongroups/firstcoupon/received
//
//获取个人中
//GET http://m.anong.com/user_center


//POST http://m.anong.com/change/name
//{"name":"huai2"}

//POST http://m.anong.com/change/password
//{"oldPassword":"888888","password":"000000"}

//GET http://m.anong.com/logout


//GET http://m.anong.com/carts/sum
//GET http://m.anong.com/coupongroups/firstcoupon/received

#endif





