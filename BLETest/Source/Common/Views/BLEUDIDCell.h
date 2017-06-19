//
//  BLEUDIDCell.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseTableViewCell.h"
#import "BLEUDIDItem.h"

@protocol BLEUDIDCellDelegate <NSObject>

- (void)bleclose;

@end

@interface BLEUDIDCell : BLEBaseTableViewCell

@property (nonatomic, weak) id <BLEUDIDCellDelegate>delegate;

@end
