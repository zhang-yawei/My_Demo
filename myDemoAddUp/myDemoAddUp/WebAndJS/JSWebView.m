//
//  JSWebView.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/4.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "JSWebView.h"

#import <JavaScriptCore/JavaScriptCore.h>

@implementation JSWebView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self confignationJs];
    }
    return self;
}

-(void)confignationJs
{
    self.backgroundColor=[UIColor lightGrayColor];
    
    
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"log"] = ^(NSString *string) {
        
        
        NSLog(@"传的值是:%@",string);
        
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
        
    };
}




@end