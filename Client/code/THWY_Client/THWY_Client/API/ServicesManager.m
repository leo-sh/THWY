//
//  ServicesManager.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "ServicesManager.h"

@interface ServicesManager ()
{
    NSString* _userName;
    NSString* _passWord;
}

@end

@implementation ServicesManager

+(ServicesManager *)getAPI
{
    static ServicesManager *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

-(instancetype)init
{
    if (self = [super init]) {
        if ([self isLogin]) {
            _userName = [[UDManager getUD] getUserName];
            _passWord = [[UDManager getUD] getPassWord];
        }
    }
    return self;
}

#pragma mark 私有函数
- (AFHTTPSessionManager *)getManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    return manager;
}

#pragma mark 公共函数
-(void)login:(NSString *)userName
    password:(NSString *)password
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@login",API_HOST];
    NSDictionary *params = @{@"login_name":userName,
                             @"login_password":password};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            _userName = userName;
            _passWord = password;
            
            UserVO* user = [[UserVO alloc]initWithJSON:responseObject[@"datas"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUserName:userName];
                [[UDManager getUD] saveUserPassWord:password];
                [[UDManager getUD] saveUser:user];
            });
            
            onComplete(nil,user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_my_info",API_HOST];
    NSDictionary *params = @{@"login_name":_userName,
                             @"login_password":_passWord};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg,nil);
            }];
        }else
        {
            UserVO* user = [[UserVO alloc]initWithJSON:responseObject[@"datas"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UDManager getUD] saveUser:user];
            });
            onComplete(nil,user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误",nil);
    }];
}

-(void)editUserInfo:(NSString *)phoneNum
          carNumber:(NSString *)carNumber
        newUserName:(NSString *)newUserName
        newPassWord:(NSString *)newPassWord
         onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@edit_my_info",API_HOST];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"login_name"] = _userName;
    params[@"login_password"] = _passWord;
    
    if (carNumber.length > 0) {
        if (![carNumber isEqualToString:[[UDManager getUD] getUser].car_number]) {
            params[@"car_number"] = carNumber;
        }
    }
    
    if (newUserName.length > 0) {
        if (![newUserName isEqualToString:_userName]) {
            params[@"new_login_name"] = newUserName;
        }
    }

    if (newPassWord.length > 0) {
        if (![newPassWord isEqualToString:_passWord]) {
            params[@"new_login_password"] = newPassWord;
        }
    }
    
    if (params.count == 0 && [phoneNum isEqualToString:[[UDManager getUD] getUser].cellphone]) {
        onComplete(@"nil");
        return;
    }else
    {
        if (phoneNum.length == 0) {
            onComplete(@"手机号为必填");
            return;
        }
        params[@"cellphone"] = phoneNum;
    }
    
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] != 0) {
            [self getErrorMessage:responseObject[@"code"] onComplete:^(NSString *errorMsg) {
                onComplete(errorMsg);
            }];
        }else
        {
            if (newUserName.length > 0) {
                _userName = newUserName;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UDManager getUD] saveUserName:newUserName];
                });
            }
            
            if (newPassWord.length > 0) {
                _passWord = newPassWord;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UDManager getUD] saveUserPassWord:newPassWord];
                });
            }
            onComplete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

#pragma mark 环境参数判定函数
-(BOOL)isLogin{
    UserVO *user = [[UDManager getUD] getUser];
    return user != nil;
}

-(void)getErrorMessage:(NSString *)code
            onComplete:(void (^)(NSString *errorMsg))onComplete
{
    AFHTTPSessionManager *manager = [self getManager];
    NSString *urlString = [NSString stringWithFormat:@"%@get_op_msg_by_code",API_HOST];
    NSDictionary *params = @{@"k":code};
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        onComplete(responseObject[@"datas"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        onComplete(@"网络连接错误");
    }];
}

#pragma mark 测试用函数
-(void)test
{
    if (self.isLogin) {
        [My_ServicesManager editUserInfo:@"13877776666" carNumber:nil newUserName:nil newPassWord:@"111111" onComplete:^(NSString *errorMsg) {
            
        }];
    }else
    {
        [My_ServicesManager login:@"zhanghao" password:@"123123" onComplete:^(NSString *errorMsg, UserVO *user) {
            
        }];
    }
    
}
@end
