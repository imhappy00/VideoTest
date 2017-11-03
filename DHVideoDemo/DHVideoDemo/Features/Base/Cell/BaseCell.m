//
//  BaseCell.m
//  Health
//
//  Created by DuHongXing on 2017/10/26.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)rowHeightForObject:(id)object{
    return 0.f;
}

+ (NSString *)cellIdentifier {
    return  NSStringFromClass(self);
}

#pragma mark - Xib
+ (instancetype)initCellFromXibWithTableView:(UITableView *)tableView
{
    id cell = [tableView dequeueReusableCellWithIdentifier:[[self class] cellIdentifier]];
    if (!cell)
    {
        cell = [[self class] loadFromXib];
    }
    return cell;
}

+ (id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}
@end
