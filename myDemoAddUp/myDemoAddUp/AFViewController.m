//
//  AFViewController.m
//  myDemoAddUp
//
//  Created by zhang on 16/4/27.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "AFViewController.h"

@interface AFViewController ()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
{
    NSURLSessionDataTask *_dataTask;
}

@end
/**

 * NSURL 对象包括基地址  base address ,web应用和需要传送的参数
 
 
 *NSURLRequest 对象负责保存需要传送给web服务器的全部数据. 包括一个url对象,缓存方案(caching policy),等待web服务器响应的最长时间和需要通过http传输的额外信息. header body等
 
 *NSURLSessionTask 对象表示一个NSURLRequest的声明周期. NSURLSessionTask可以追踪NSURLRequest,还可以对NSURLRequest执行取消\暂停\继续等操作.有三个不同功能的子类
 
 *NSURLSession 对象可以看作是一个NSURLSessionTask 对象的工厂.设置其出产的NSURLSessionTask的通用属性,如请求头等. 他还有一个代理,可以追踪task的状态.

 
 */








@implementation AFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableURLRequest *mutabRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/data.json"]];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];

 //   _dataTask = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://127.0.0.1/data.json"]];
    
    
    _dataTask = [urlSession dataTaskWithRequest:mutabRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        
    NSString *decode_str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"decode_str : %@",decode_str);
  
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSLog(@"NSURLSessionDataTask 从 http://127.0.0.1/data.json 请求成功 : %@",dic);
        
    }];
    
    
}



- (IBAction)beginUrlSessionTask:(id)sender {
    
    [_dataTask resume];

}


- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    
    
    
    
}
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{



}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler
{
    
    
    
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
    
    
    
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
