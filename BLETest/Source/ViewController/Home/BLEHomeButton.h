//
//  BLEHomeButton.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseView.h"
#import "BLEHomeListItem.h"

@protocol BLEHomeButtonDelegate <NSObject>

- (void)homebuttonTouchAction:(BLEHomeItem *)item;

@end

@interface BLEHomeButton : BLEBaseView

@property (nonatomic, weak) id <BLEHomeButtonDelegate>delegate;

@end
