//
//  WQFactoryUI.m
//  优款
//
//  Created by gut on 16/12/19.
//  Copyright © 2016年 com.personal. All rights reserved.
//

#import "WQFactoryUI.h"

@implementation WQFactoryUI

+ (UILabel *)createLabelWithtextFont:(NSInteger)font textBackgroundColor:(UIColor *)bgColor textAliment:(NSTextAlignment)type textColor:(UIColor *)textColor textFrame:(CGRect)frame text:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.textAlignment = type;
    label.backgroundColor = bgColor;
    
    return label;
}

+ (UIView *)createViewWithFrame:(CGRect)frame viewBackgroundColor:(UIColor *)bgColor{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view;
}

+ (UIButton *)createButtonWithTitleFont:(NSInteger)font buttonBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)textColor buttonFrame:(CGRect)frame text:(NSString *)text cornerRadius:(CGFloat)radius{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = bgColor;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.cornerRadius = radius;
    button.layer.masksToBounds = YES;
    
    return button;
}

//创建imageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    
    imageView.layer.borderColor = borderColor.CGColor;
    imageView.layer.borderWidth = borderWidth;
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = YES;
    
    return imageView;
}

//创建textField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placehold:(NSString *)placehold textFont:(CGFloat)fontSize textColor:(UIColor *)textColor attributedPlaceholder:(NSMutableAttributedString *)placeholderAttr tintColor:(UIColor *)tintColor{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placehold;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textColor = textColor;
    textField.attributedPlaceholder = placeholderAttr;  //占位文字的样式
    textField.tintColor = tintColor;   //光标的颜色
    return textField;
}

@end
