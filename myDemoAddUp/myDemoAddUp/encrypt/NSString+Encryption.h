//
//  NSString+Encryption.h
//  Mobile Banking
//
//  Created by Nathan Jones on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)
/**
 *  AES 加密

 *
 *  @param key <#key description#>
 *  @param iv  <#iv description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  AES解密
 *
 *  @param key <#key description#>
 *  @param iv  <#iv description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;














/**
 *  3DES加密
 *
 *  @param key <#key description#>
 *  @param iv  <#iv description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
/**
 *  3DES解密
 *
 *  @param key <#key description#>
 *  @param iv  <#iv description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end