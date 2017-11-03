//
//  HTGlobal.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//
#import "HTGlobal.h"
static HTGlobal *instance = nil;
@implementation HTGlobal
+ (NSString *)fileName{
    NSString *tempName = [NSString stringWithFormat:@"%@%@",appName(),appBundleIdentifier()];
    return VPPathAtDocumentWithDirectory([NSString stringWithFormat:@"appData%@.dat",[tempName md5]]);
}
#pragma mark - singleton
+ (HTGlobal *)sharedGlobal {
    if(!instance){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [HTGlobal readGlobeVariablesFromFile];
            if(instance == nil){
                instance = [[self alloc] init];
            }
            // 单例重新创建代表程序再开启一次
            instance.luanchCounts += 1;
        });
    }
    return instance;
}

+ (void)archived {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:instance];
        if(archivedData){
            [archivedData writeToFile:[HTGlobal fileName] atomically:YES];
        }
    });
}

+ (HTGlobal *)readGlobeVariablesFromFile {
    HTGlobal * object = nil;
    if(![[NSFileManager defaultManager] fileExistsAtPath:[HTGlobal fileName]]){
        return object;
    }
    NSData *archivedData = [[NSData alloc] initWithContentsOfFile:[HTGlobal fileName]];
    if(archivedData) {
        object = (HTGlobal *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    }
    return object;
}
+ (BOOL)isLoggedIn
{
    if (![Helper isBlankString:[HTGlobal userId]] && ![Helper isBlankString:[HTGlobal token]]){
        return YES;
    }
    return NO;
}
+ (NSString *)userId{
    NSString *userId = [HTGlobal sharedGlobal].userInfo.identification;
    if (!userId){
        userId = @"";
    }
    return userId;
}

+ (NSString*)token
{
    NSString *token = [HTGlobal sharedGlobal].userInfo.token;
    if (!token) {
        token = @"";
    }
    return token;
}

- (NSString *)userName{
    if (_userName.length <= 0) {
        _userName = @"";
    }
    return _userName;
}


@end
