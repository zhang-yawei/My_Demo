//
//  NSString+HashWithType.h
//  myDemoAddUp
//
//  Created by zhang on 16/5/16.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HashType) {
    HASHTYPE_MD5 = 0,
    HASHTYPE_SHA1,
    HASHTYPE_SHA256
};

@interface NSString (HashWithType)

-(NSString *)hashWithType:(HashType)type;

@end
