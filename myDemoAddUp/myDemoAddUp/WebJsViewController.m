//
//  WebJsViewController.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/4.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "WebJsViewController.h"
#import "JSWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JsNativeBridge.h"

#define iosJsBridge @"iosJsBridge"

@interface WebJsViewController ()<UIWebViewDelegate>
{
    JSWebView *_webView;
}

@end

@implementation WebJsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"webjs" ofType:@"html"];
    NSURL *htmlUrl = [NSURL URLWithString:htmlPath];
    
    _webView = [[JSWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:htmlUrl];
    [_webView loadRequest:request];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(200, 200, 100, 50);
    [_webView addSubview:button];
    [button addTarget:self action:@selector(buttonPressDown) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _webView.delegate =self;
    
    
    
}

#pragma mark-- button responder method

-(void)buttonPressDown
{
    JSContext *jscontext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
   JSValue *jsValue = [jscontext evaluateScript:@"window.returnFromJS();"];
    NSString *string = [jsValue toString];
    NSLog(@"执行js方法的返回值:%@",string);
    
}

#pragma mark -- webView delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     JSContext *jscontext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    JSValue *jsObject = jscontext[iosJsBridge];
    if (![jsObject toBool]) {
        jscontext[iosJsBridge] = [JsNativeBridge shareInstance];
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
