//
//  BLEHeaderCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLEHeaderItem.h"

@protocol BLEHeaderCellDelegate <NSObject>

- (void)headerAction:(BLEHeaderItem *)item;

@end

@interface BLEHeaderCell : BLEBaseTableViewCell

@property (nonatomic, weak) id <BLEHeaderCellDelegate> delegate;

@end
