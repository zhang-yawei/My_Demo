//
//  QQLoginAndShare.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "QQLoginAndShare.h"
#import <TencentOpenAPI/TencentOAuth.h>


@implementation QQLoginAndShare


-(void)viewDidLoad
{
    
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    
}



- (IBAction)QQlogin:(id)sender {
}


- (IBAction)shareToQQzone:(id)sender {
}

- (IBAction)shareToQQFriend:(id)sender {
}



@end
