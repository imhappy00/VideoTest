//
//  Helper+Views.m
//
//  Created by vernepung on 15/6/9.
//  Copyright (c) 2015年 vernepung. All rights reserved.
// 

#import "Helper+UIView.h"
//#import "RefreshTableView.h"
#import "UIImage+Additional.h"
#import "DHWindowManager.h"
#import "UIView+Additional.h"
@implementation Helper (UIView)

//+ (UITableViewCell *)getSeparatorCellWithRefreshTableView:(RefreshTableView *)tableView
//{
//    return [Helper getSeparatorCellWithTableView:[tableView getTableView]];
//}

+ (UITableViewCell *)getSeparatorCellWithTableView:(UITableView *)tableView
{
    static NSString *emptyCellIdentifier = @"emptyCellIdentifier";
    /**
     *  分隔行
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = kDefaultBackgroundColor;
        cell.backgroundColor = kDefaultBackgroundColor;
    }
    return cell;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message withBtnTitle:(NSString*)btnTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:btnTitle
                                              otherButtonTitles:nil];
    [alertView show];
}

+(void)createTopSeperatorLineView:(UIView*)superView
{
    if(!superView || superView.height==0){
        return;
    }
    UIImageView* topImageView = [superView viewWithTag:9901];
    if (!topImageView)
    {
        topImageView = [[UIImageView alloc]init];
        topImageView.backgroundColor = kSeparatorLineColor;
        topImageView.tag = 9901;
        [superView addSubview:topImageView];
    }
    topImageView.frame = CGRectMake(0, 0, superView.width, kOnePixelWidth);
}

+(void)createBottomSeperatorLineView:(UIView*)superView
{
    if(superView.height==0){
        return;
    }
    
    for(UIView *subView in superView.subviews){
        if(subView.tag == 9902){
            [subView removeFromSuperview];
            break;
        }
    }
    
    UIImageView* bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, superView.height-kOnePixelWidth, superView.width, kOnePixelWidth)];
    bottomImageView.backgroundColor = kSeparatorLineColor;
    bottomImageView.tag = 9902;
    [superView addSubview:bottomImageView];
}
@end
