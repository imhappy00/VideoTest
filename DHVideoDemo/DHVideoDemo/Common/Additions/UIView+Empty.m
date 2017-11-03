//
//  UIView+Empty.m
//  teacherSecretary
//
//  Created by verne on 16/5/31.
//  Copyright © 2016年 vernepung. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIView+Additional.h"
#import "UtilsMacro.h"
#import "UIView+Additional.h"
const NSUInteger EMPTYVIEWTAG = NSUIntegerMax - 10;
const NSUInteger EMPTYLABELVIEWTAG = NSUIntegerMax - 11;
const NSUInteger EMPTYIMAGEVIEWTAG = NSUIntegerMax - 12;
// 40 + 140 + 40
const CGFloat  MINEMPTYVIEWHEIGHT = 180;
static UIImage *emptyImage;
#import "UIView+Empty.h"

@implementation UIView (Empty)

//+ (void)registerEmptyImageWithImageName:(NSString *)name{
//    [[self class] registerEmptyImage:name];
//}

+ (void)registerEmptyImage:(NSString *)imageName {
    emptyImage = [UIImage imageNamed:imageName];
    NSAssert(emptyImage, @"dont find empty image");
}

//- (void)showFriendlyTipsForNoDataWithMessage:(NSString *)msg{
//    [self showFriendlyTipsWithMessage:msg];
//}

- (void)showFriendlyTipsWithMessage:(NSString *)msg {
    [self showFriendlyTipsWithMessage:msg frame:self.bounds];
}

//- (void)showFriendlyTipsForNoDataWithMessage:(NSString *)msg frame:(CGRect)frame{
//    [self showFriendlyTipsWithMessage:msg frame:frame];
//}

- (void)showFriendlyTipsWithMessage:(NSString *)msg frame:(CGRect)frame {
    [self hideFriendlyTips];
    UIView *emptyView = [self emptyView];
    emptyView.userInteractionEnabled = NO;
    emptyView.frame = frame;
    if (![emptyView isDescendantOfView:self]){
        [self addSubview:emptyView];
    }
    CGFloat height = CGRectGetHeight(self.bounds);
    UIImageView *imageView = [self emptyImageView];
    if (![imageView isDescendantOfView:emptyView]){
        [emptyView addSubview:imageView];
    }
    imageView.left = (CGRectGetWidth(frame) - imageView.width) / 2;
    imageView.top = (CGRectGetHeight(frame) - imageView.height) * .25;
    
    
    if (height >= MINEMPTYVIEWHEIGHT){
        UILabel *msgLabel = [self emptyLabel];
        if (![msgLabel isDescendantOfView:emptyView]){
            [emptyView addSubview:msgLabel];
        }
        msgLabel.text = msg;
        msgLabel.width = ScreenWidth * 0.85;
        msgLabel.height = 40;
        msgLabel.numberOfLines = 2;
        //        [msgLabel sizeToFit];
        msgLabel.left = (CGRectGetWidth(frame) - msgLabel.width) / 2;
        msgLabel.hidden = NO;
    }else{
        [[self emptyLabel] removeFromSuperview];
    }
    [self addSubview:emptyView];
    [self bringSubviewToFront:emptyView];
}
//
//- (void)hideFriendlyTipsForNoData{
//    [self hideFriendlyTips];
//}

- (void)hideFriendlyTips {
    UIView *emptyView = [self emptyView];
    if (!emptyView){
        return;
    }
    [emptyView removeAllSubviews];
    [emptyView removeFromSuperview];
}

- (UIView *)emptyView{
    UIView *_emptyView = [self viewWithTag:EMPTYVIEWTAG];
    if (!_emptyView){
        _emptyView = [UIView new];
        _emptyView.tag = EMPTYVIEWTAG;
    }
    return _emptyView;
}

- (UIImageView *)emptyImageView{
    UIImageView *_emptyImageView = (UIImageView *)[[self emptyView] viewWithTag:EMPTYIMAGEVIEWTAG];
    if (!_emptyImageView){
        NSAssert(emptyImage, @"dont find empty image");
        CGSize size = emptyImage.size;
        _emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_emptyImageView setImage:emptyImage];
        _emptyImageView.tag = EMPTYIMAGEVIEWTAG;
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel{
    UILabel *_emptyLabel = (UILabel *)[[self emptyView] viewWithTag:EMPTYLABELVIEWTAG];
    if (!_emptyLabel){
        _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [self emptyImageView].bottom + 20, CGRectGetWidth(self.bounds), 20)];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:16];
        _emptyLabel.textColor = UIColorFromRGB(0x666666);
        _emptyLabel.tag = EMPTYLABELVIEWTAG;
    }
    return _emptyLabel;
}

@end
