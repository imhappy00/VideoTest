//
//  Helper+Views.h
//
//  Created by vernepung on 15/6/9.
//  Copyright (c) 2015年 vernepung. All rights reserved.
// 

#import "Helper.h"
@class RefreshTableView;


@interface Helper (UIViews)
+ (UITableViewCell *)getSeparatorCellWithTableView:(UITableView *)tableView;
//+ (UITableViewCell *)getSeparatorCellWithRefreshTableView:(RefreshTableView *)tableView;
/**show alert**/
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message withBtnTitle:(NSString*)btnTitle;
/**
 *	@brief	在view的顶部画线
 */
+(void)createTopSeperatorLineView:(UIView*)superView;
/**
 *	@brief	在view的底部画线
 */
+(void)createBottomSeperatorLineView:(UIView*)superView;

@end
