//
//  BLESeperatorLine.h
//  Pods
//
//  Created by whj on 15/6/17.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    kBottomMask = 1,
    kTopMask,
    kLeftMask,
    kRightMask,
} kMarginMask;

@interface BLESeperatorLine : UIView

- (void)setSeperatorMask:(kMarginMask)mask color:(UIColor *)color height:(CGFloat)height;

@end
