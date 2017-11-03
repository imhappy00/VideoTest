//
//  UITableViewCell+FTDrawBorderLine.h
//  FaceTraningForManager
//
//  Created by DuHongXing on 2017/8/11.
//  Copyright © 2017年 aopeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,FTDrawBorderLineType) {
    /**不画线*/
    FTDrawBorderLineTypeLineNone = 1,
    /**画顶部带圆角的线*/
    FTDrawBorderLineTypeRadiusTop = 2,
    /**画底部带圆角的线*/
    FTDrawBorderLineTypeRadiusBottom = 3,
    /**画顶部和底部都带圆角的线*/
    FTDrawBorderLineTypeRadiusTopAndBottom = 4,
    /**不带圆角的线*/
    FTDrawBorderLineTypeLine = 5,
};
@interface UITableViewCell (FTDrawBorderLine)
- (void)dhx_separatorColorWillDisplaySetCornerRadius:(CGFloat)cornerRadius
                                     separatorColor:(UIColor *)separatorColor
                                   cornerRadiusType:(FTDrawBorderLineType)cornerType;
@end
