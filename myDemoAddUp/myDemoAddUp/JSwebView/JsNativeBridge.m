//
//  JsNativeBridge.m
//  myDemoAddUp
//
//  Created by 张大威 on 16/6/18.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "JsNativeBridge.h"


@implementation JsNativeBridge

+(instancetype)shareInstance
{
    
    static JsNativeBridge *bridge_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge_instance = [[JsNativeBridge alloc]init];
        
    });
    return bridge_instance;
}



-(void)testLog:(NSString *)string
{
    NSLog(@"from jsNativeBrideg----testLog:%@",string);
    
}



-(void)testTwo:(NSString *)str ArgLog:(NSInteger)count
{
    NSLog(@"from jaNativeBridge -- testTwoArgLog: %@-----%ld",str,(long)count);
}



@end
