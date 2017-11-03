//
//  WQFactoryUI.h
//  优款
//
//  Created by gut on 16/12/19.
//  Copyright © 2016年 com.personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WQFactoryUI : NSObject

//创建label
+ (UILabel *)createLabelWithtextFont:(NSInteger)font textBackgroundColor:(UIColor *)bgColor textAliment:(NSTextAlignment)type textColor:(UIColor *)textColor textFrame:(CGRect)frame text:(NSString *)text;

//创建view
+ (UIView *)createViewWithFrame:(CGRect)frame viewBackgroundColor:(UIColor *)bgColor;

//创建button
+ (UIButton *)createButtonWithTitleFont:(NSInteger)font buttonBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)textColor buttonFrame:(CGRect)frame text:(NSString *)text cornerRadius:(CGFloat)radius;

//创建imageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius;

//创建textField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textFont:(CGFloat)fontSize textColor:(UIColor *)textColor attributedPlaceholder:(NSMutableAttributedString *)placeholderAttr tintColor:(UIColor *)tintColor;


@end
