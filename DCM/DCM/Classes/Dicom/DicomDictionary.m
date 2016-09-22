//
//  DicomDictionary.m
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import "DicomDictionary.h"
static DicomDictionary *instance;

@implementation DicomDictionary

+ (id)sharedInstance {
    if (!instance) {
        instance = [[DicomDictionary alloc] init];
    }
    
    return instance;
}

- (id) init {
    self = [super init];
    
    if (self) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"DicomDictionary" ofType:@"plist"];
        self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

- (id)valueForKey:(NSString *)key {
    if (!key || [key isEqualToString:@""]) {
        return nil;
    }
    
    id retValue = nil;
    if (self.dictionary) {
        retValue = [self.dictionary valueForKey:key];
    }
    
    return retValue;
}

@end
