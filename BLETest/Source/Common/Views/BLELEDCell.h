//
//  BLELEDCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLELEDItem.h"

@protocol BLELEDCellDelegate <NSObject>

- (void)ledAction:(BLELEDItem *)item;
- (void)hasDoneAction;

@end

@interface BLELEDCell : BLEBaseTableViewCell

@property (nonatomic, weak) id<BLELEDCellDelegate>delegate;

@end
