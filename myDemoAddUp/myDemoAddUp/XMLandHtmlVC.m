//
//  XMLandHtmlVC.m
//  myDemoAddUp
//
//  Created by zhang on 16/6/23.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "XMLandHtmlVC.h"
#import "GDataXMLNode.h"
#import "TFHpple.h"
@interface XMLandHtmlVC ()

@end

@implementation XMLandHtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}
/**
 1. 导入GDataXML http://code.google.com/p/gdata-objectivec-client/source/browse/trunk/Source/XMLSupport/
 
 2. 工程中添加 libxml2.dylib库
 3.Header Search Path 中添加路径 /usr/include/libxml2
 4.complier source 中指定complier flags  -fno-objc-arc
 
 5.gdata是采用DOM的方式解析
 
 
 
 */

// 解析xml
- (IBAction)analyzXml:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"monlthyInfo" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    NSString *responseXml = [[NSString alloc ]initWithData: xmlData encoding:NSUTF8StringEncoding] ;
    
    if(responseXml == nil || [responseXml isEqualToString:@""]) {
        
        NSLog(@" xml 无数据");
    }
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseXml options:0 error:nil];
    if (doc == nil) {
        NSLog(@" xml 无数据");

    }
    GDataXMLElement *rootElement = [doc rootElement];
    if (rootElement == nil) {
        NSLog(@" xml 无数据");

    }
    NSArray *nodeArry = [rootElement nodesForXPath:@"//Response"  error:nil];
    if(nodeArry == nil || nodeArry.count <=0) {
        NSLog(@" xml 无数据");
    }
    GDataXMLElement *rootNode = [nodeArry objectAtIndex:0] ;
    
    
    GDataXMLElement *rspElement = [[rootNode elementsForName:@"GetPackProductInfoListRsp"] objectAtIndex:0];
    
    GDataXMLElement *myProductListElement = [[rspElement elementsForName:@"productList"] objectAtIndex:0];
    NSArray *myProductList = [myProductListElement elementsForName:@"ProductInfo"];
    if ([myProductList count] > 0) {
        for (GDataXMLElement *productElement in myProductList) {
            [self analyWithXmlElement:productElement];
        }
    }

}


- (void)analyWithXmlElement:(GDataXMLElement *)xmlElement{
    
    NSMutableString *logStr = [[NSMutableString alloc]initWithFormat:@"catalogID:"];
    
    [logStr appendString:[[[xmlElement elementsForName:@"catalogID"] objectAtIndex:0] stringValue]];
    
    [logStr appendString:@"------catalogName:"];
    [logStr appendString:[[[xmlElement elementsForName:@"catalogName"] objectAtIndex:0] stringValue]];

    
    [logStr appendString:@"------chargeChannel:"];
    [logStr appendString:[[[xmlElement elementsForName:@"chargeChannel"]objectAtIndex:0] stringValue]];

        
    [logStr appendString:@"------bigLogo:"];
        [logStr appendString:[[[xmlElement elementsForName:@"bigLogo"] objectAtIndex:0] stringValue]];
    
    [logStr appendString:@"------smallLogo:"];
    [logStr appendString:[[[xmlElement elementsForName:@"smallLogo"] objectAtIndex:0] stringValue]];
    
    [logStr appendString:@"------description:"];
    [logStr appendString:[[[xmlElement elementsForName:@"description"] objectAtIndex:0] stringValue]];
    
    [logStr appendString:@"------price:"];
    [logStr appendString:[[[xmlElement elementsForName:@"price"] objectAtIndex:0] stringValue]];
    
    [logStr appendString:@"------readPointPrice:"];
    [logStr appendString: [[[xmlElement elementsForName:@"readPointPrice"] objectAtIndex:0] stringValue]];
    
    
    [logStr appendString:@"------subscribeTime:"];
    
    [logStr appendString:[[[xmlElement elementsForName:@"updateTime"] objectAtIndex:0] stringValue]];
    
    
    [logStr appendString:@"------contentCount:"];
    [logStr appendString:[[[xmlElement elementsForName:@"contentCount"] objectAtIndex:0] stringValue]];
     
     
    [logStr appendString:@"------monthType:"];
    [logStr appendString:[[[xmlElement elementsForName:@"monthType"] objectAtIndex:0] stringValue]];

    
    NSLog(logStr);

}

//生成xml
- (IBAction)creatXml:(id)sender {
    
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"Request"];
    GDataXMLElement *createThirdPayOrderRequest = [GDataXMLNode elementWithName:@"SyncOrderStatusForThirdPayReq"];
    
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"payTime" stringValue:@"2016"]];
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"payFee" stringValue:[NSString stringWithFormat:@"%ld", (long)100]]];
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"rechargeWay" stringValue:[NSString stringWithFormat:@"%ld", (long)10000]]];
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"statusSyncCode" stringValue:[NSString stringWithFormat:@"%ld", (long)1]]];
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"tradeNo" stringValue:@"123445"]];
    
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"statusReason" stringValue:@"status reason"]];
    
    [createThirdPayOrderRequest addChild:[GDataXMLNode elementWithName:@"token" stringValue:@"token-token"]];
    
    
    [requestElement addChild:createThirdPayOrderRequest];

    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    [doc setCharacterEncoding:@"UTF-8"];
    NSData *xmlData = [doc XMLData];
    NSLog(@" xml = %@", [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding]);

    
    
    
    
}

// 解析html
// html只是特殊一点的xml而已
- (IBAction)anazlyHtml:(id)sender {
    
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"webjs" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlPath];
    TFHpple *h = [[TFHpple alloc]initWithHTMLData:htmlData];
    NSArray *buttonArr = [h searchWithXPathQuery:@"//button"];
    NSLog(@"%@",buttonArr);
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
