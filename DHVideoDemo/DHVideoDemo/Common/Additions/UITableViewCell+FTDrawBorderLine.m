//
//  UITableViewCell+FTDrawBorderLine.m
//  FaceTraningForManager
//
//  Created by DuHongXing on 2017/8/11.
//  Copyright © 2017年 aopeng. All rights reserved.
//

#import "UITableViewCell+FTDrawBorderLine.h"
#import <objc/runtime.h>
@interface UITableViewCell()
@property (strong, nonatomic) CAShapeLayer *cellBorderLayer;
@property (strong, nonatomic) CAShapeLayer *cellMaskLayer;
@end
@implementation UITableViewCell (FTDrawBorderLine)

static void *cellBorderLayerKey = &cellBorderLayerKey;
static void *cellMaskLayerKey = &cellMaskLayerKey;

- (void)setCellBorderLayer:(CAShapeLayer *)cellBorderLayer {
    objc_setAssociatedObject(self, &cellBorderLayerKey, cellBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)cellBorderLayer {
    return objc_getAssociatedObject(self, &cellBorderLayerKey);
}

- (void)setCellMaskLayer:(CAShapeLayer *)cellMaskLayer {

}

- (CAShapeLayer *)cellMaskLayer {
    return objc_getAssociatedObject(self, &cellMaskLayerKey);
}

#pragma mark - 画圆角和线
- (void)dhx_separatorColorWillDisplaySetCornerRadius:(CGFloat)cornerRadius
                                     separatorColor:(UIColor *)separatorColor
                                   cornerRadiusType:(FTDrawBorderLineType)cornerType {
    if (cornerType == FTDrawBorderLineTypeLineNone) {
        return;
    }
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    cornerRadius = MIN(cornerRadius, 10);
    if(cornerType != FTDrawBorderLineTypeLine) {
        if (!self.cellMaskLayer) {
            self.cellMaskLayer = [CAShapeLayer layer];
            self.cellMaskLayer.frame = CGRectMake(0, 0, w, h);
            self.cellMaskLayer.fillColor = separatorColor.CGColor;
        }
    }
    if (!self.cellBorderLayer) {
        self.cellBorderLayer = [CAShapeLayer layer];
        self.cellBorderLayer.frame = CGRectMake(0, 0, w, h);
        self.cellBorderLayer.lineWidth = 0.75f;
        self.cellBorderLayer.strokeColor = separatorColor.CGColor;
        self.cellBorderLayer.fillColor = [UIColor clearColor].CGColor;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPath];
    switch (cornerType) {
        case FTDrawBorderLineTypeRadiusTop:
            {
                self.layer.cornerRadius = cornerRadius;
                bezierPath = [self dhx_drawRectUIRectCornerTopLeft:cornerRadius bezierPath:bezierPath];
                bezierPath = [self dhx_drawRectUIRectCornerTopRight:cornerRadius bezierPath:bezierPath];
                borderBezierPath = [self dhx_drawBorderLineTopSizeWidth:w height:h CornerRadius:cornerRadius];
            }
            break;
        case FTDrawBorderLineTypeRadiusBottom:
            {
                self.layer.cornerRadius = cornerRadius;
                bezierPath = [self dhx_drawRectUIRectCornerBottomLeft:cornerRadius bezierPath:bezierPath];
                bezierPath = [self dhx_drawRectUIRectCornerBottomRight:cornerRadius bezierPath:bezierPath];
                borderBezierPath = [self dhx_drawBorderLineBottomSizeWidth:w height:h CornerRadius:cornerRadius];
            }
            break;
        case FTDrawBorderLineTypeRadiusTopAndBottom:
            {
                self.layer.cornerRadius = cornerRadius;
                bezierPath = [self dhx_drawRectUIRectCornerTopLeft:cornerRadius bezierPath:bezierPath];
                bezierPath = [self dhx_drawRectUIRectCornerTopRight:cornerRadius bezierPath:bezierPath];
                bezierPath = [self dhx_drawRectUIRectCornerBottomLeft:cornerRadius bezierPath:bezierPath];
                bezierPath = [self dhx_drawRectUIRectCornerBottomRight:cornerRadius bezierPath:bezierPath];
                borderBezierPath = [self dhx_drawBorderLineTopAndBottomSizeWidth:w height:h CornerRadius:cornerRadius];
            }
            break;
        case FTDrawBorderLineTypeLine:
            {
                borderBezierPath = [self dhx_drawBorderLineNormalSizeWidth:w height:h CornerRadius:cornerRadius];
            }
            break;
        default:
            break;
    }
    if (cornerType != FTDrawBorderLineTypeLine) {
        self.cellMaskLayer.path = bezierPath.CGPath;
    }
    self.cellBorderLayer.path = borderBezierPath.CGPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(cornerType != FTDrawBorderLineTypeLine){
            [self.layer addSublayer:self.cellMaskLayer];
        }
        [self.contentView.layer insertSublayer:self.cellBorderLayer atIndex:0];
    });
}

/**画顶部带有圆角的线*/
- (UIBezierPath *)dhx_drawBorderLineTopSizeWidth:(CGFloat)w height:(CGFloat)h CornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPath];

    [borderBezierPath moveToPoint:CGPointMake(0, h)];
    [borderBezierPath addLineToPoint:CGPointMake(0, cornerRadius)];
    [borderBezierPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:(M_PI_2 + M_PI) clockwise:YES];
    [borderBezierPath moveToPoint:CGPointMake(cornerRadius, 0)];
    [borderBezierPath addLineToPoint:CGPointMake(w - cornerRadius, 0)];
    [borderBezierPath addArcWithCenter:CGPointMake(w - cornerRadius, cornerRadius) radius:cornerRadius startAngle:(M_PI_2 + M_PI) endAngle:0 clockwise:YES];
    [borderBezierPath moveToPoint:CGPointMake(w, cornerRadius)];
    [borderBezierPath addLineToPoint:CGPointMake(w,h)];
    return borderBezierPath;
}
/**画底部带有圆角的线*/
- (UIBezierPath *)dhx_drawBorderLineBottomSizeWidth:(CGFloat)w height:(CGFloat)h CornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPath];
    [borderBezierPath moveToPoint:CGPointMake(0, 0)];
    [borderBezierPath addLineToPoint:CGPointMake(0, h - cornerRadius)];
    [borderBezierPath addArcWithCenter:CGPointMake(cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    [borderBezierPath moveToPoint:CGPointMake(cornerRadius, h)];
    [borderBezierPath addLineToPoint:CGPointMake(w - cornerRadius, h)];
    [borderBezierPath addArcWithCenter:CGPointMake(w - cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [borderBezierPath moveToPoint:CGPointMake(w, h - cornerRadius)];
    [borderBezierPath addLineToPoint:CGPointMake(w,0)];
    return borderBezierPath;
}
/**画底部和顶部都带有圆角的线*/
- (UIBezierPath *)dhx_drawBorderLineTopAndBottomSizeWidth:(CGFloat)w height:(CGFloat)h CornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    return borderBezierPath;
}
/**画普通的线*/
- (UIBezierPath *)dhx_drawBorderLineNormalSizeWidth:(CGFloat)w height:(CGFloat)h CornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPath];
    [borderBezierPath moveToPoint:CGPointMake(0, 0)];
    [borderBezierPath addLineToPoint:CGPointMake(0, h)];
    [borderBezierPath moveToPoint:CGPointMake(w, 0)];
    [borderBezierPath addLineToPoint:CGPointMake(w, h)];
    return borderBezierPath;
}
//        左上角
- (UIBezierPath *)dhx_drawRectUIRectCornerTopLeft:(CGFloat)cornerRadius
                                   bezierPath:(UIBezierPath *)bezierPath{
    [bezierPath moveToPoint:CGPointMake(cornerRadius, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, cornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:(M_PI_2 + M_PI) clockwise:YES];
    return bezierPath;
}
//        右上角
- (UIBezierPath *)dhx_drawRectUIRectCornerTopRight:(CGFloat)cornerRadius
                                    bezierPath:(UIBezierPath *)bezierPath{
    CGFloat w = self.bounds.size.width;
    [bezierPath moveToPoint:CGPointMake(w, cornerRadius)];
    [bezierPath addLineToPoint:CGPointMake(w, 0)];
    [bezierPath addLineToPoint:CGPointMake(w - cornerRadius, 0)];
    [bezierPath addArcWithCenter:CGPointMake(w - cornerRadius, cornerRadius) radius:cornerRadius startAngle:(M_PI_2 + M_PI) endAngle:0 clockwise:YES];
    return bezierPath;
}
//        左下角
- (UIBezierPath *)dhx_drawRectUIRectCornerBottomLeft:(CGFloat)cornerRadius
                                      bezierPath:(UIBezierPath *)bezierPath{
    CGFloat h = self.bounds.size.height;
    [bezierPath moveToPoint:CGPointMake(cornerRadius, h)];
    [bezierPath addLineToPoint:CGPointMake(0, h)];
    [bezierPath addLineToPoint:CGPointMake(0, h - cornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    return bezierPath;
}
//        右下角
- (UIBezierPath *)dhx_drawRectUIRectCornerBottomRight:(CGFloat)cornerRadius
                                       bezierPath:(UIBezierPath *)bezierPath{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    [bezierPath moveToPoint:CGPointMake(w, h - cornerRadius)];
    [bezierPath addLineToPoint:CGPointMake(w, h)];
    [bezierPath addLineToPoint:CGPointMake(w - cornerRadius, h)];
    [bezierPath addArcWithCenter:CGPointMake(w - cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    return bezierPath;
}
@end
