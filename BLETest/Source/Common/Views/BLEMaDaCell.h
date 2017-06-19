//
//  BLEMaDaCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLEMaDaItem.h"

@protocol BLEMaDaCellDelegate <NSObject>

- (void)madaAction:(BLEMaDaItem *)item;
- (void)hasDoneAction;

@end

@interface BLEMaDaCell : BLEBaseTableViewCell

@property (nonatomic, weak) id<BLEMaDaCellDelegate>delegate;

@end
