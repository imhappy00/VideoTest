//
//  BaseCell.h
//  Health
//
//  Created by DuHongXing on 2017/10/26.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell
/**
 *  用xib创建Cell
 */
+ (id)loadFromXib;
/**
 *  用代码创建Cell时候设置的cellIdentifier
 */
+ (NSString*)cellIdentifier;
/**
 *  计算cell高度
 *  子类去实现
 */
+ (CGFloat)rowHeightForObject:(id)object;

+ (instancetype)initCellFromXibWithTableView:(UITableView *)tableView;
@end
