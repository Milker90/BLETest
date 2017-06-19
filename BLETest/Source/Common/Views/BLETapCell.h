//
//  BLETapCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLETapItem.h"

@protocol BLETapCellDelegate <NSObject>

- (void)bletap:(BLETapItem *)item;
- (void)hasDoneAction;

@end

@interface BLETapCell : BLEBaseTableViewCell

@property (nonatomic, weak) id <BLETapCellDelegate> delegate;

@end
