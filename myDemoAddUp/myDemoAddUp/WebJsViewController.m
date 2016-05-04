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
@interface WebJsViewController ()
{
    JSWebView *webView;
}

@end

@implementation WebJsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"webjs" ofType:@"html"];
    NSURL *htmlUrl = [NSURL URLWithString:htmlPath];
    
    webView = [[JSWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:htmlUrl];
    [webView loadRequest:request];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(200, 200, 100, 50);
    [webView addSubview:button];
    [button addTarget:self action:@selector(buttonPressDown) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonPressDown
{
    JSContext *jscontext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
   JSValue *jsValue = [jscontext evaluateScript:@"window.returnFromJS();"];
    NSString *string = [jsValue toString];
    NSLog(@"执行js方法的返回值:%@",string);
    
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
