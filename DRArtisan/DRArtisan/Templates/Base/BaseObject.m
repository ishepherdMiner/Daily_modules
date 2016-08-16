//
//  BaseObject.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"
#import <objc/message.h>

@implementation BaseObject


+ (instancetype)modelWithDic:(NSDictionary *)dic {
    
    id obj = [[self alloc] init];
    
    NSArray *propertyList = [self jas_propertyList];
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:[propertyList  count]];
    
    // the Foundation class type solve step
    if (kFoundationProperty(obj)) {
        return obj = dic;
    }
    
    if (kCollectionProperty(obj)) {
        for (id element in obj) {
            [element modelWithDic:element];
        }
    }
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([obj respondsToSelector:@selector(whitePropertiesList)]) {
        propertyList = [obj whitePropertiesList];
    }
    
    if ([obj respondsToSelector:@selector(blackPropertiesList)]) {
        NSMutableArray *propertyListM = [NSMutableArray arrayWithArray:propertyList];
        for (id property in [obj blackPropertiesList]) {
            if ([propertyListM indexOfObject:property] != NSNotFound) {
                [propertyListM removeObject:property];
            }
        }
        propertyList = [propertyListM copy];
        
    }
    
    if ([obj respondsToSelector:@selector(mapperProperties)]) {
        NSDictionary *mapDic = [obj performSelector:@selector(mapperProperties)];
        for (NSString *property in propertyList) {
            id mapResult = [mapDic objectForKey:property];
            // the class property be mapped
            if(mapResult) {
                [propertyDic setValue:dic[mapResult] forKey:property];
            }else {
                
                // the class property not map but in property list
                // 1.Developer forget to map
                // 2.model property named is the same as server field
                if ([propertyList indexOfObject:property] != NSNotFound) {
                    [propertyDic setValue:dic[property] forKey:property];
                }else {
#if DEBUG
                    // the class property not in model which is from server
                    XcLog(@"the %@ property %@ not in model wihich is from server.",obj,property);
#endif
                }
            }
        }
        for (NSString *property in propertyList) {
            if ([propertyDic objectForKey:property]) {
                XcLog(@"value = %@, key = %@",[propertyDic objectForKey:property],property);
                [obj setValue:[propertyDic objectForKey:property] forKeyPath:property];
            }
        }
    }else {
        // Not implement mapperProperties
        for (NSString *property in propertyList) {
            id mapResult = [dic objectForKey:property];
            if(mapResult){
                [obj setValue:mapResult forKey:property];
            }else {
                [obj setValue:[NSNull null] forKey:property];
            }
        }
    }
    
#pragma clang diagnostic pop
    
    return obj;
}

#pragma mark - DEBUG
+ (void)hookMethod:(Class)cls OriginSelector:(SEL)originalSelector SwizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(cls, originalSelector); \
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector); \
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)dealloc {
    [self jas_logDealloc];
}
@end
