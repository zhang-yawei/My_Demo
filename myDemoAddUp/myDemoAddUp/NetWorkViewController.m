//
//  NetWorkViewController.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/10.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "NetWorkViewController.h"
#import <Security/Security.h>

#import <CommonCrypto/CommonCrypto.h>


@interface NetWorkViewController ()<NSURLConnectionDelegate>

@end

@implementation NetWorkViewController

/**
 
    -------- 第三章------------
 *  1.HTTPS会加密整个http消息,S-HTTP 只会加密消息体.
    2.
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSMutableURLRequest *mutableRe = [NSMutableURLRequest requestWithURL:url];
    // 向请求添加一个头,头的名字为 content-length 值为:en
    
    [mutableRe addValue:@"en" forHTTPHeaderField:@"content-length"];
    // 向请求添加一个头,此时头的名字为 content-length 值为:en,de
    [mutableRe addValue:@"de" forHTTPHeaderField:@"content-length"];
    // 对于请求中的标准头,iOS并没有提供好的删除方式,可以用置空的方式
    [mutableRe setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];

    // 开发者也可以向头信息中添加自定义的头.自定义的头名不能包含 冒号和 空格. 区分大小写
    [mutableRe setValue:@"haha" forHTTPHeaderField:@"my_custome_hander"];
    
    
}

// 查看相应头
- (IBAction)responseHeader:(id)sender {

    NSURL *url = [NSURL URLWithString:@"http://www.baidddd.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
            if(response){
                
                if([response isKindOfClass:[NSHTTPURLResponse class]]){
                
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    NSDictionary *headerDic = httpResponse.allHeaderFields;
                    NSLog(@"%@",headerDic);
                    
                }
                

// www.wrox.com/WileyCDA/WroxTitle/Professional-iOS-Network-Programming-Connenting-the-Enterprise-to-the-iPhone-and-iPad.productCd-1118362403.html
                
            }
            
    }];
    [dataTask resume];
    

   
}


/**
 *  验证服务器通信
    确保客户端只与期望的服务器进行通信.
 
 可以用    NSURLProtectionSpace(保护空间) 验证客户端和服务器之间的通信.
 NSURLProtectionSpace表示需要认证的服务器或域.  是进来的NSURLAuthenticationChallenge的一个属性.
 
 创建保护空间,与challenge中的信息做比对
 
 */
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
//.........1.. 服务器认证 ......//
    // 创建保护空间,可以与challenge中的信息比对
    // 创建认证信息的时候,要充分考虑到备份认证服务器.
    NSURLProtectionSpace *defaultSpace = [[NSURLProtectionSpace alloc]initWithHost:@"baidu.com" port:443 protocol:NSURLProtectionSpaceHTTPS realm:@"mobile" authenticationMethod:NSURLAuthenticationMethodDefault];
    NSURLProtectionSpace *trustSpace = [[NSURLProtectionSpace alloc]initWithHost:@"baidu.com" port:443 protocol:NSURLProtectionSpaceHTTPS realm:@"mobilebanking" authenticationMethod:NSURLAuthenticationMethodClientCertificate];
    NSArray *protectionArray = @[defaultSpace,trustSpace];

    if (![protectionArray containsObject:challenge.protectionSpace]) {
        
        NSLog(@"认证不成功,无法安全连接至服务器");
        
        // 调用的一个代理方法.
        [challenge.sender cancelAuthenticationChallenge:challenge];
        
        
    }else{
        
        // 创建服务器新人的  NSURLCredential
        
    }
    
    
    
    
 //..........2.... 服务器认证 ......//
    //比较灵活的方式也可以只验证challenge(认证挑战)中的某些属性.
    if(challenge.protectionSpace.port == 443 || [challenge.protectionSpace.host  isEqualToString:@"ddd"]){
     //...........
    }
    
//...............3...  HTTP认证 ........//
/*
NSURLAuthenticationMethodDefault;

NSURLAuthenticationMethodHTTPBasic;
    
NSURLAuthenticationMethodHTTPDigest;
    
NSURLAuthenticationMethodHTMLForm;
    
NSURLAuthenticationMethodNTLM ;
 
NSURLAuthenticationMethodNegotiate;
    
NSURLAuthenticationMethodClientCertificate;
    
NSURLAuthenticationMethodServerTrust;

 
 
HTTP Basic,HTTP Digest,NTLM .都是基于用户名,密码的认证.
 */
    
    // NSURLCredential 适合大多是的认证请求,只需要一NSURLCredential的方式指定所需要的信息就可以了.
    // 可以表示 用户名/密码组合,客户端证书以及服务器信任创建的认证信息...认证信息有各种持久化选项:不持久化,只对当前对话持久化,以及永久持久化
    // 方法名和密码认证.
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic){
        
        if(challenge.previousFailureCount == 0){
    
            NSURLCredential *credential = [[NSURLCredential alloc]initWithUser:@"userName" password:@"passWord" persistence:NSURLCredentialPersistenceForSession]; // 指定持久化选项
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            
        }else{
            
            // 取消尝试认证
            [challenge.sender cancelAuthenticationChallenge:challenge];
            NSLog(@"invalid credentials");
        }
        
     //在确定 challenge是针对 HTTP Basic 或者别的认证类型后,应该确保挑战没有失败.如果认证失败,一定要取消challenge
        
    }
    
    
    

    
}

// 客户端证书认证.....没有写完
-(void)test01
{
    
    // 假装这里是相应的数据
    BOOL _registerDevice = YES;
    NSMutableData *responseData = [[NSMutableData alloc]init];
    
    
    NSError *error = nil;
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    if (_registerDevice == YES) {
        NSString *cerString = [response objectForKey:@"certificate"];
        NSData *cerData = [[NSData alloc]initWithBase64EncodedString:cerString options:NSDataBase64Encoding64CharacterLineLength];
        
        SecIdentityRef identity = NULL;
        SecCertificateRef certificate = NULL;
        [self identify:&identity andCertification:&certificate fromPKCS12Data:cerData withPassphrase:@"test"];
        
    }
    
    
}

-(void)identify:(SecIdentityRef *)identify andCertification:(SecCertificateRef *)certificate fromPKCS12Data:(NSData *)cerData withPassphrase:(NSString *)passphrase
{
    // 转换数据类型
    CFStringRef importPassphrase = (__bridge CFStringRef)passphrase;
    CFDataRef importData = (__bridge CFDataRef)cerData;
    //
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {importPassphrase};
    
    CFDictionaryRef importOptions = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef importResults = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus pkcs12ImportStatus = errSecSuccess;
    pkcs12ImportStatus = SecPKCS12Import(importData, importOptions, &importResults);
    if (pkcs12ImportStatus == errSecSuccess) {
        
        CFDictionaryRef identityAndTrust = CFArrayGetValueAtIndex(importResults, 0);
        
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(identityAndTrust, kSecImportItemIdentity);
        *identify = (SecIdentityRef)tempIdentity;
        
        
        SecCertificateRef tempCertificate = NULL;
        OSStatus certificateStatus = errSecSuccess;
        certificateStatus = SecIdentityCopyCertificate(*identify, &tempCertificate);
        *certificate = (SecCertificateRef)tempCertificate;
        
        
    }
    
    if (importOptions) {
        CFRelease(importOptions);
    }

}











-(IBAction)tryCatch:(id)sender
{
    
    @try {
        
        NSException *exction = [NSException exceptionWithName:@"crash" reason:@"这里是一个错误" userInfo:nil];
        @throw exction;
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception.reason);
        
    } @finally {

        
        
    }
 
}



/**
 * 苹果自带两个xml解析
    NSXmlParser,libxml
 
 解析XML文档,有两种解析方式.
    Simple API for XML:(SAX)事件驱动,顺序解析XML文档中的元素.
    Document Object Model :(DOM)DOM会将整个XML文档以可遍历的节点树的形式读取到内存中.
 
 
 */




// ---------------------------------------------------

// 所有认证完成后,就可以开始请求数据了 . 如何保证信息传输的安全呢,可以










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
    
    
}



@end
