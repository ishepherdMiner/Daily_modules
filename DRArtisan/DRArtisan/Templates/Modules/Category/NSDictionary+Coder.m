//
//  NSDictionary+Coder.m
//  Coder
//
//  Created by ishpherdme on 24/4/15.
//  Copyright (c) 2015 WDL. All rights reserved.
//

#import "NSDictionary+Coder.h"

@implementation NSDictionary (Coder)


- (NSDictionary *)splitUrlQuery:(NSURL *)url {
    NSArray *qS = [url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *qSDicM = [NSMutableDictionary dictionaryWithCapacity:qS.count];
    [qS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *paramPair = [obj componentsSeparatedByString:@"="];
        [qSDicM setObject:paramPair.lastObject forKey:paramPair.firstObject];
    }];
    return [qSDicM copy];
}

#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    
    [desc appendString:@"\t{\n"];
    
    // 遍历数组,self就是当前的数组
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, str];
                    } else {
                        [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}
#endif


@end

@implementation NSDictionary (CleanDescription)

- (NSString *)cleanDescription
{
    NSString *result;
    
    NSMutableString *elements = [NSMutableString string];
    for (id key in self) {
        id value = [self objectForKey:key];
        [elements appendFormat:@"%@ = %@; ", [key cleanDescription], [value cleanDescription]];
    }
    NSUInteger length = [elements length];
    if (length) {
        [elements deleteCharactersInRange:NSMakeRange(length - 1, 1)];
    }
    
    result = [NSString stringWithFormat:@"{%@}", elements];
    
    return result;
}

@end

