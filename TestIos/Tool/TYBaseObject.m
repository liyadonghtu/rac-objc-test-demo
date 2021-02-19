//
//  TYBaseObject.m
//  Liyadong
//
//  Created by Liyadong on 2019/4/8.
//  Copyright © 2019 Liyadong. All rights reserved.
//

#import "TYBaseObject.h"
#import <objc/runtime.h>
@implementation TYBaseObject

- (NSString *)description
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";
        [dictionary setObject:value forKey:name];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@:%p> -- %@", [self class], self, dictionary];
    
}

@end
