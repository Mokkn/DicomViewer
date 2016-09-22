//
//  DicomDictionary.h
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

@interface DicomDictionary : NSObject

@property(nonatomic) NSDictionary *dictionary;

+ (id)sharedInstance;

- (NSString *)valueForKey:(NSString *)key;

@end
