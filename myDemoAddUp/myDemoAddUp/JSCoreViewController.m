//
//  JSCoreViewController.m
//  myDemoAddUp
//
//  Created by zhang on 16/4/26.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "JSCoreViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>


//http://www.cocoachina.com/ios/20140409/8127.html
//http://www.cocoachina.com/ios/20140415/8167.html


@interface JSCoreViewController ()

@end

@implementation JSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    
    
}



-(void)someThing
{
    //JSVirtualMachine为JavaScript的运行提供了底层资源，JSContext就为其提供着运行环境，通过- (JSValue *)evaluateScript:(NSString *)script;方法就可以执行一段JavaScript脚本，并且如果其中有方法、变量等信息都会被存储在其中以便在需要的时候使用。而JSContext的创建都是基于JSVirtualMachine：- (id)initWithVirtualMachine:(JSVirtualMachine *)virtualMachine;，如果是使用- (id)init;进行初始化，那么在其内部会自动创建一个新的JSVirtualMachine对象然后调用前边的初始化方法。
    
    
     //JSValue则可以说是JavaScript和Object-C之间互换的桥梁，它提供了多种方法可以方便地把JavaScript数据类型转换成Objective-C，或者是转换过去。其一一对应方式可见下表：
    
    JSContext *content = [[JSContext alloc]init];
    JSValue *jsValue = [content evaluateScript:@"21+7"];
    int jsint = [jsValue toInt32]; //
    NSLog(@"%d",jsint);
    
    
    
    
    //还可以存一个JavaScript变量在JSContext中，然后通过下标来获取出来。而对于Array或者Object类型，JSValue也可以通过下标直接取值和赋值。
    
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var arr = [21, 7 , 'iderzheng.com'];"];
    JSValue *jsArr = context[@"arr"]; // Get array from JSContext
    
    NSLog(@"JS Array: %@; Length: %@", jsArr, jsArr[@"length"]);
    jsArr[1] = @"blog"; // Use JSValue as array
    jsArr[7] = @7;
    
    NSLog(@"JS Array: %@; Length: %d", jsArr, [jsArr[@"length"] toInt32]);
    
    NSArray *nsArr = [jsArr toArray];
    NSLog(@"NSArray: %@", nsArr);

    
  //  通过输出结果很容易看出代码成功把数据从Objective-C赋到了JavaScript数组上，而且JSValue是遵循JavaScript的数组特性：无下标越位，自动延展数组大小。并且通过JSValue还可以获取JavaScript对象上的属性，比如例子中通过"length"就获取到了JavaScript数组的长度。在转成NSArray的时候，所有的信息也都正确转换了过去。
    

    
    
    
    
    
    
    
}

-(void)useingBlock
{
    JSContext *context = [[JSContext alloc] init];
    context[@"log"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
        NSLog(@"-------End Log-------");
    };
    
    [context evaluateScript:@"log('ider', [7, 21], { hello:'world', js:100 });"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
