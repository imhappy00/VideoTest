//
//  TCRequestHelper.m
//  teacherSecretary
//
//  Created by user on 15/5/11.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "FTRequestConfig.h"
#import "VPBaseRequest.h"
#import "VPNetConfig.h"
#import "AFURLRequestSerialization.h"
#import "Helper+Device.h"
#import "AppDelegate.h"
#import "VPJSONRequestSerializer.h"
#import "NSData+Godzippa.h"
#import "VPNetCacheManager.h"
#import "AFSecurityPolicy.h"
#import "YYKit.h"
//#import "FTUnBindDeviceRequest.h"
NSString *const FTServerBaseUrl = @"http://192.168.1.22:8180/";
//#if isBeta && !isPre
//NSString *const FTServerBaseUrl = @"http://";
//#elif !isBeta && isPre
//NSString *const FTServerBaseUrl = @"http://";
//#else
//NSString *const FTServerBaseUrl = @"http://";
//#endif

NSString *const HTClientName = @"HealthDemo";
//code :200  表示成功，800 表示服务器异常 700 表示客户端要进入登录界面 message : 错误信息内容

/** 成功返回码 */
static NSInteger const kSuccessRet = 200;
/** 取返回码的key值 */
static NSString *const kGetRetKey = @"status";
NSString *const kMessageKey = @"message";
NSString *const kJsonArrayKey = @"content";
NSString *const kRootKey = @"data";

/** token失效，被挤下登陆了 */
static NSInteger const kNeedLoginRet = 700;

@implementation FTRequestConfig
+ (void)load{
    [VPNetConfig registerConfig:[self class]];
}

- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}

- (NSString *)requestBaseUrl{
    return FTServerBaseUrl;
}

- (NSInteger)requestSuccessCode{
    return kSuccessRet;
}

- (NSString *)requestCodeKey{
    return kGetRetKey;
}

- (NSInteger)requestNeedLoginCode{
    return kNeedLoginRet;
}

- (AFSecurityPolicy *)securityPolicy{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
    securityPolicy.allowInvalidCertificates = YES;
    return securityPolicy;
}

- (AFHTTPRequestSerializer *)requestSerializer{
    AFHTTPRequestSerializer *requestSerializer = [super requestSerializer];
    if (!requestSerializer){
        requestSerializer = [AFHTTPRequestSerializer serializer];//[PPJSONRequestSerializer serializer];
    }
    
    NSDictionary *httpRequestHeaderDic = [[VPNetConfig defaultConfig] requestHttpHeader];
    [httpRequestHeaderDic enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![requestSerializer valueForHTTPHeaderField:field]) {
            [requestSerializer setValue:value forHTTPHeaderField:field];
        }
    }];
    requestSerializer.timeoutInterval = 30.f;
    return requestSerializer;
}

- (id)handleOnResponse:(NSURLResponse *)response data:(NSData *)responseData{
    //    NSData *resultData = responseData;
    //    NSHTTPURLResponse *httpResonse = (NSHTTPURLResponse *)response;
    //    if (httpResonse && [httpResonse respondsToSelector:@selector(allHeaderFields)]){
    //        NSString *isGzip = [httpResonse allHeaderFields][@"Content-Encoding"];
    //        if (isGzip && [[isGzip lowercaseString] isEqualToString:@"gzip"]){
    //            resultData = [resultData gunzippedData];
    //        }
    //    }
    return responseData;
}

- (id)getCacheWithMethodName:(NSString *)methodName params:(NSDictionary *)params{
    NSMutableArray<NSString *> *keysArray = [NSMutableArray arrayWithArray: [params allKeys]];
    [keysArray sortUsingSelector:@selector(compare:)];
    NSMutableString *keysString = [self appendAllKeysValues:params];
    // 连接请求URL
    [keysString appendString:methodName];
    // 加密作为Key
    NSString *encryptKey = [keysString md5];
    NSString *fileName = [encryptKey stringByAppendingPathExtension:@"cache"];
    [[VPNetCacheManager shareManager] cacheWithEncryptKey:encryptKey cacheKey:nil];
    NSString *filePath = [[VPNetCacheManager shareManager] filePathWithFileName:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        @try {
            return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        } @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            return nil;
        }
    }else{
        return nil;
    }
}

- (void)cacheRequestWithMethodName:(NSString *)methodName params:(NSDictionary *)params result:(id)result{
    if ([params.allKeys containsObject:@"page"]){
        NSInteger page = [params[@"page"] integerValue];
        if (page!=1){
            return;
        }
    }
    NSMutableArray<NSString *> *keysArray = [NSMutableArray arrayWithArray: [params allKeys]];
    [keysArray sortUsingSelector:@selector(compare:)];
    NSMutableString *keysString = [self appendAllKeysValues:params];
    // 连接请求URL
    [keysString appendString:methodName];
    // 加密作为Key
    NSString *encryptKey = [keysString md5];
    NSString *fileName = [encryptKey stringByAppendingPathExtension:@"cache"];
    NSString *filePath = [[VPNetCacheManager shareManager] filePathWithFileName:fileName];
    if (!result){
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        return;
    }
    BOOL archiverSuccess = [NSKeyedArchiver archiveRootObject:result toFile:filePath];
    if (archiverSuccess){
        [[VPNetCacheManager shareManager] cacheWithEncryptKey:encryptKey cacheKey:nil];
    }
}

- (NSMutableString *)appendAllKeysValues:(NSDictionary *)dic{
    if (!dic){
        return nil;
    }
    NSMutableArray<NSString *> *keysArray = [NSMutableArray arrayWithArray: [dic allKeys]];
    [keysArray sortUsingSelector:@selector(compare:)];
    NSMutableString *keysString = [NSMutableString string];
    // 排序所有参数 并连接
    [keysArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [keysString appendString:[NSString stringWithFormat:@"%@=%@|",obj,dic[obj]]];
    }];
    return keysString;
}

#pragma mark -
- (NSMutableDictionary *)requestParameters:(NSDictionary *)parametersDic{
    NSMutableDictionary *requestParamDic = [NSMutableDictionary dictionaryWithDictionary:parametersDic];
//    if ([requestParamDic containsObjectForKey:@"uid"] || [requestParamDic containsObjectForKey:@"token"] || [requestParamDic containsObjectForKey:@"clazzId"] ){
//        @throw [NSException exceptionWithName:@"request params error" reason:@"请移除Request中对uid和token、clazzId的入参定义" userInfo:nil];
//    }
    if ([HTGlobal isLoggedIn]){
        [requestParamDic setObject:[HTGlobal token] forKey:@"token"];
        [requestParamDic setObject:[HTGlobal userId] forKey:@"uid"];
    }
    return [requestParamDic copy];
}

- (NSDictionary *)requestHttpHeader{
    static NSString *version = nil;
    static NSString *versionStr = nil;
    if (!version){
        version = appVersion();
        versionStr = [version stringByReplacingOccurrencesOfString:@"." withString:@"0"];
    }
    NSString *deviceInfo = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f; [%0.f,%0.f])", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale], ScreenWidth,ScreenHeight];
    NSString *udid = [[AppDelegate shareAppDelegate].wrapper objectForKey:(id)kSecAttrLabel];
    if (!udid || [Helper isBlankString:udid]){
        udid = [Helper getCurrentDeviceUDID];
        [[AppDelegate shareAppDelegate].wrapper setObject:udid forKey:(id)kSecAttrLabel];
    }
    
    NSDictionary *dict = @{
                           @"Content-Type":@"application/x-www-form-urlencoded",
                           @"imei":udid,
                           @"device":@"ios",
                           @"appname":HTClientName,
                           @"deviceInfo":deviceInfo,
                           @"versionname":version,
                           @"versioncode":versionStr,
                           @"machineModelName":[UIDevice currentDevice].machineModelName
                           };
    return dict;
    
}

- (void (^)(NSDictionary *))requestBusinessFailureBlock{
    return ^(NSDictionary *dict){
        NSString *message = dict[kMessageKey] ?: kNetworkError;
        if ([DHWindowManager shareWindowManager].activitiedWindowType == HTWindowTypeLogin){
            [[DHWindowManager shareWindowManager].loginWindow makeToast:message];
        }else{
            [[DHWindowManager shareWindowManager].contentWindow makeToast:message];
        }
    };
}

- (void (^)(NSError *))requestFailFinishBlock{
    return ^(NSError *error){
        [[DHWindowManager shareWindowManager].activitiedWindowType == HTWindowTypeLogin ? [DHWindowManager shareWindowManager].loginWindow : [DHWindowManager shareWindowManager].contentWindow makeToast:kNetworkError];
    };
}
//#pragma mark -
//- (void)whenServerLogout{
//    @synchronized (self) {
//        if ([VPWindowManager shareWindowManager].activitiedWindowType != TSWindowTypeLogin){
//            [[VPWindowManager shareWindowManager] setValue:@(TSWindowTypeLogin) forKey:@"_activitiedWindowType"]; // 此处作用只是为了避免多次700导致的跳转Bug
//            //调回首页
//            UITabBarController *tabbarController = (UITabBarController *)[VPWindowManager shareWindowManager].menuController.rootViewController;
//            UINavigationController *topNavController = tabbarController.selectedViewController;
//            [topNavController.topViewController.view makeToast:@"请重新登录" duration:1.f position:CSToastPositionCenter];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // 解除绑定
//                [[[FTUnBindDeviceRequest alloc] init] sendRequestSuccFinishBlock:^(id result) {
//                } requestFinalBlock:^{
//                } showToast:YES];
//                [TSGlobal logout];
//            });
//        }
//    }
//}

@end
