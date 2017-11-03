//
//  HomeRequest.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest
- (instancetype)initHomeRequest {
    self = [super initPostMethod:@"Server/mvc/getParamNames"];
    [self setValue:@"haojile" forKey:@"name"];
    [self setIntegerValue:18  forKey:@"age"];
    return self;
}

- (id)processResultWithDic:(NSMutableDictionary *)resultDic {
    return resultDic;
}
@end
