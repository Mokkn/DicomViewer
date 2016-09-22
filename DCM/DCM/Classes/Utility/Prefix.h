//
//  Prefix.h
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define DLog(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])
#define FLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif

#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)


#define NSStringIsNilOrEmpty(str) (nil == (str) || [(str) isEqualToString:@""])
#define NSLocalString(str) NSLocalizedString(str, nil)

#define SAFE_FREE(ptr) do { if (ptr) { free(ptr); ptr = NULL;} } while (0)
#define SAFE_DELETE(ptr) do { if (ptr) { delete ptr; ptr = NULL;} } while (0)

