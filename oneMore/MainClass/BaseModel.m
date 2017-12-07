//
//  BaseModel.m
//  ShangPinJiaZu
//
//  Created by macbook on 16/10/26.
//  Copyright © 2016年 yangzhihao. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setNilValueForKey:(NSString *)key{
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSString class]]) {
        value = [(NSString *)value stringByRemovingPercentEncoding];
    }
    [super setValue:value forKey:key];
}


- (instancetype)initWithSelf:(BaseModel *)model{
    if (self = [super init]) {
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *name = property_getName(properties[i]);
            
            NSString *propertyName = [NSString stringWithUTF8String:name];
            id propertyValue = [model valueForKey:propertyName];
            if (propertyValue) {
                [userDic setObject:propertyValue forKey:propertyName];
            }
        }
        self = [self initWithDic:userDic];
    }
    return self;
}
@end
