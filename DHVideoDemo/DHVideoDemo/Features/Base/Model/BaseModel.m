//
//  BaseModel.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "BaseModel.h"
#import "MJExtension.h"
#import "HTGlobal.h"
#import <objc/runtime.h>
@implementation BaseModel
static NSString *idPropertyName = @"id";
static NSString *idPropertyNameOnObject = @"objectId";
- (instancetype)init
{
    self = [super init];
    if (self && ![self isKindOfClass:[HTGlobal class]]) {
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i=0; i<count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
            if ([BaseModel isNSStringProperty:[self class] propertyName:key]) {
                if ([BaseModel isPropertyReadOnly:[self class] propertyName:key]){
                    [self setValue:@"" forKey:[NSString stringWithFormat:@"_%@",key]];
                }else{
                    [self setValue:@"" forKey:key];
                }
            }
        }
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.mj_keyValues];
    if (self.objectId) {
        [dic setObject:self.objectId forKey:idPropertyName];
    }
    return dic;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.objectId forKey:idPropertyNameOnObject];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([key isEqualToString:@"objectId"]){
                    continue ;
                }
                [encoder encodeObject:[self valueForKey:key] forKey:key];
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        [self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
        
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i=0; i<count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
            if ([BaseModel isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
            id value = [decoder decodeObjectForKey:key];
            if (value != [NSNull null] && value != nil) {
                [self setValue:value forKey:key];
            }
        }
        Class superClass = [[[[self class] alloc] superclass] class];
        do {
            if (superClass){
                propertyList = class_copyPropertyList(superClass, &count);
                for (unsigned int i=0; i<count; i++) {
                    NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                    if ([key isEqualToString:@"objectId"]){
                        continue ;
                    }
                    if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                        continue;
                    }
                    id value = [decoder decodeObjectForKey:key];
                    if (value != [NSNull null] && value != nil) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            superClass = [[[superClass alloc] superclass] class];
        } while (superClass && superClass != [NSObject class]);
        
    }
    return self;
}


/**
 *  解析字典
 */
+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    return [[self class] mj_objectWithKeyValues:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    id selfClass;
    @try {
        selfClass = [[self class] mj_objectWithKeyValues:dictionary];
    } @catch (NSException *exception) {
        DLog(@"反序列化错误！ [BaseModel initWithDictionary] line:42");
    }//    NSAssert(selfClass, @"检查返回数据格式是否正确");
    return selfClass;
}

- (id)copyWithZone:(NSZone *)zone{
    id newModel = [[[self class] allocWithZone:zone]init];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if ([BaseModel isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        id value = [self valueForKey:key];
        if (value != [NSNull null] && value != nil) {
            [newModel setValue:value forKey:key];
        }
    }
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                    continue;
                }
                id value = [self valueForKey:key];
                if (value != [NSNull null] && value != nil) {
                    [newModel setValue:value forKey:key];
                }
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
    return newModel;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    id newModel = [[[self class] allocWithZone:zone]init];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if ([BaseModel isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        id value = [self valueForKey:key];
        if (value != [NSNull null] && value != nil) {
            if ([value respondsToSelector:@selector(mutableCopyWithZone:)]){
                [newModel setValue:[value mutableCopyWithZone:zone] forKey:key];
            }else{
                [newModel setValue:value forKey:key];
            }
        }
    }
    
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                    continue;
                }
                id value = [self valueForKey:key];
                if (value != [NSNull null] && value != nil) {
                    if ([value respondsToSelector:@selector(mutableCopyWithZone:)]){
                        [newModel setValue:[value mutableCopyWithZone:zone] forKey:key];
                    }else{
                        [newModel setValue:value forKey:key];
                    }
                }
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
    return newModel;
}

+ (BOOL)isNSStringProperty:(Class)klass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    return [typeAttribute rangeOfString:@"T@\"NSString\""].length > 0;
}

+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:1];
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
    return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.objectId, [dic description]];
}

- (BOOL)isEqual:(id)object {
    if (object == nil || ![object isKindOfClass:[BaseModel class]]) return NO;
    
    BaseModel *model = (BaseModel *)object;
    
    return [self.objectId isEqualToString:model.objectId];
}
@end
