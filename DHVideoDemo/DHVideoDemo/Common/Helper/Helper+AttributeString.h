//
//  Helper+AttributeString.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/31.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "Helper.h"

@interface Helper (AttributeString)

+ (void)addString:(NSMutableAttributedString *)attributeString fontAttribute:(UIFont *)font range:(NSRange)range;
+ (void)addString:(NSMutableAttributedString *)attributeString fontColorAttribute:(UIColor *)color range:(NSRange)range;

@end
