//
//  JsNativeBridge.h
//  myDemoAddUp
//
//  Created by 张大威 on 16/6/18.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JsNativeBridgeDelegate <JSExport>


-(void)testLog:(NSString *)string;

-(void)testTwo:(NSString *)str ArgLog:(NSInteger)count;

@end


@interface JsNativeBridge : NSObject<JsNativeBridgeDelegate>

+(instancetype)shareInstance;

@end
