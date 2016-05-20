//
//  NSString+HashWithType.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/16.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "NSString+HashWithType.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (HashWithType)

-(NSString *)hashWithType:(HashType)type
{
    
    const char *pstr = [self UTF8String];
    NSInteger bufferSize;
    
    switch (type) {
        case HASHTYPE_MD5:
            bufferSize = CC_MD5_DIGEST_LENGTH;

            break;
        case HASHTYPE_SHA1:
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
        case HASHTYPE_SHA256:
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
            
        default:
            break;
    }
    
    
    
    unsigned char buffer[bufferSize];
    
    
    switch (type) {
        case HASHTYPE_MD5:
            CC_MD5(pstr,strlen(pstr),buffer);
            
            break;
        case HASHTYPE_SHA1:
            CC_SHA1(pstr,strlen(pstr),buffer);
            break;
        case HASHTYPE_SHA256:
            CC_SHA256(pstr,strlen(pstr),buffer);
            break;
            
        default:
            break;
    }
    
    
    NSMutableString *hashString = [NSMutableString stringWithCapacity:bufferSize *2];
    for (int i = 0; i<bufferSize; i++) {
        [hashString appendFormat:@"%02x",buffer[i]];
    }
    
    return hashString;
    
    
}

-(NSString *)md5
{
    return [self hashWithType:HASHTYPE_MD5];
}
-(NSString *)sha1
{
     return [self hashWithType:HASHTYPE_SHA1];
}

-(NSString *)sha256
{
     return [self hashWithType:HASHTYPE_SHA256];
}

@end
