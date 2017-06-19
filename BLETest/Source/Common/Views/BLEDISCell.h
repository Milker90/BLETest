//
//  BLEDISCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLEDISItem.h"
@protocol BLEDISCellDelegate <NSObject>

- (void)hasDoneAction;

@end

@interface BLEDISCell : BLEBaseTableViewCell

@property (nonatomic, weak) id <BLEDISCellDelegate> delegate;

@end
