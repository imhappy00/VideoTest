//
//  ColorConst.h
//  HealthDemo
//
//  Created by DuHongXing on 2017/10/27.
//  Copyright © 2017年 duxing. All rights reserved.
//

#ifndef ColorConst_h
#define ColorConst_h
/** 项目背景色 */
#define kDefaultBackgroundColor UIColorFromRGB(0xf5f6f5)
/** 分割线色 */
#define kSeparatorLineColor UIColorFromRGB(0xE1E7E2)
#define kOtherFontColor UIColorFromRGB(0x999999)
/** 普通文字色 */
#define kNormalFontColor  UIColorFromRGB(0x666666)

#define kWhiteColor UIColorFromRGB(0xFFFFFF)

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]
#define WHITECOLOR [UIColor whiteColor]
/** 项目主色 */
#define kMainColor RGB(255, 192, 223)

#endif /* ColorConst_h */
