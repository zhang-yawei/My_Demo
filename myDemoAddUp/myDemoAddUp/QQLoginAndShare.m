//
//  QQLoginAndShare.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#define appid @"1105353673"
#define appKey q4oD0YJfa33ayXbB

#import "QQLoginAndShare.h"
#import <TencentOpenAPI/TencentOAuth.h>


@interface QQLoginAndShare ()<TencentSessionDelegate>

@end

@implementation QQLoginAndShare


-(void)viewDidLoad
{
    
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    TencentOAuth *_tencentOAuth = [[TencentOAuth alloc]initWithAppId:appid andDelegate:self];
    
    
}



- (IBAction)QQlogin:(id)sender {
    
    
    
}


- (IBAction)shareToQQzone:(id)sender {
    
    
    
}

- (IBAction)shareToQQFriend:(id)sender {
    
    
    
    
}


// 登录成功后的回调
- (void)tencentDidLogin
{
    
}
// 登录失败后的回调
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

// 登录时网络有问题的回调

- (void)tencentDidNotNetWork
{
    
}

// 返回信息
- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions
                      withExtraParams:(NSDictionary *)extraParams
{
    
    return nil;
}


@end
