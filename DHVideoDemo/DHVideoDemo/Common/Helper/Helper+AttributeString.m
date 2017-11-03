//
//  Helper+AttributeString.m
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/31.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "Helper+AttributeString.h"
@implementation Helper (AttributeString)
+ (void)addString:(NSMutableAttributedString *)attributeString fontAttribute:(UIFont *)font range:(NSRange)range {
    [attributeString addAttributes:@{NSFontAttributeName:font} range:range];
}
+ (void)addString:(NSMutableAttributedString *)attributeString fontColorAttribute:(UIColor *)color range:(NSRange)range {
    [attributeString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xDE2E19)} range:range];
}
@end
