//
//  BaseModel.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/28.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding,NSCopying,NSMutableCopying>
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *identification;
/**
 *  解析字典
 */
+ (id)objectFromDictionary:(NSDictionary*)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
