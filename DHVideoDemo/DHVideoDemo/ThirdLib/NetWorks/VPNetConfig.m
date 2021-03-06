//
//  BaseRequestDefaultHelper.m
//  PublicProject
//
//  Created by user on 15/5/8.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import "VPNetConfig.h"
#import "VPBaseRequest.h"
#import "VPHTTPSessionManager.h"
#import "VPJSONRequestSerializer.h"
#import "VPJSONResponseSerializer.h"

/** 成功返回的返回码 */
//static const NSInteger RequestSuccessCode = 10000;
/** 标明客户端需要缓存的返回码 */
//static const NSInteger RequestCacheCode = 9999;
/** 标明客户端需要缓存的返回码 */
//const NSInteger RequestNeedLoginCode = -1;
/** 服务器返回取code的key值 */
//NSString * const RequestCodeKey = @"code";

static VPNetConfig *_sharedInstance = nil;
@implementation VPNetConfig

+ (void)registerConfig:(Class)config{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class superClass = [config superclass];
        Class defaultClass = [VPNetConfig class];
        //注册的类必须是NetworkHelper的子类
        if(superClass == defaultClass){
            _sharedInstance = [[config alloc] init];
        }
        else{
            @throw [NSException exceptionWithName:@"registerConfig" reason:@"注册的请求帮助类不是继承与VPNetConfig" userInfo:nil];
        }
    });
}

+ (instancetype)defaultConfig{
    return _sharedInstance;
}

- (AFHTTPRequestSerializer *)requestSerializer{
    return nil;
}

- (AFHTTPResponseSerializer *)responseSerializer{
    VPJSONResponseSerializer *serializer = [VPJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    return serializer;
}

- (NSString *)requestBaseUrl{
    //抛出异常
    @throw [NSException exceptionWithName:@"registerRequestHelper: error" reason:@"请重写[RequestHelper requestBaseUrl];" userInfo:nil];
//    return @"127.0.0.1";
}

- (NSInteger)requestSuccessCode{
    return 10000;
}

- (NSString *)requestCodeKey{
    return @"serverCode";
}

- (NSInteger)requestNeedLoginCode{
    return -1;
}

- (AFSecurityPolicy *)securityPolicy{
    return [AFSecurityPolicy defaultPolicy];
}

- (NSInteger)requestCacheCode{
    return 9999;
}

- (void)whenServerLogout{
    
}

#pragma mark -
/** 请求的公共参数 */
- (NSMutableDictionary *)requestCommonParam:(NSDictionary *)parametersDic{
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)requestParameters:(NSDictionary *)parametersDic{
    return [NSMutableDictionary dictionaryWithDictionary:[self requestCommonParam:parametersDic]];
}

#pragma mark -
- (id)handleOnRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters{
    return nil;
}

- (id)handleOnRequest:(VPBaseRequest *)request body:(NSDictionary *)bodyDic{
    return bodyDic;
}

- (id)handleOnResponse:(NSURLResponse *)response data:(NSData *)responseData{
    return responseData;
}

- (void)cacheRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params result:(id)result{
        
}

- (id)getCacheWithMethodName:(NSString *)methodName params:(NSDictionary *)params{
    return nil;
}
#pragma mark - 请求回调Blcok
- (void(^)(NSDictionary* response))requestBusinessFailureBlock{
    return nil;
}

- (void(^)(NSError *error))requestFailFinishBlock{
    return nil;
}
//requestBusinessFailureBlock:(void(^)(NSDictionary* response))requestBusinessFailureBlock requestFailFinishBlock:(void(^)(NSError *error))requestFailFinishBlock

#pragma mark -
- (NSDictionary *)requestHttpHeader{
    return @{
             @"Content-Type":@"application/x-www-form-urlencoded;charset=utf-8",
             @"User-Agent":@"iPhone"
             };
}
@end
