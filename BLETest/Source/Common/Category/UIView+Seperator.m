//
//  UIView+Seperator.m
//  Pods
//
//  Created by whj on 15/5/31.
//
//

#import "UIView+Seperator.h"
#import "BLESeperatorLine.h"
#import "UIView+RDPExtension.h"

#define FIRST_SEP_TAG       20150609
#define SECOND_SEP_TAG      20150610
#define LEFT_MARGIN         14
#define HEIGHT_SEPERATOR    1.f

#define SEPEATOR_LINE_BASE_TAG    (20150710)


@implementation UIView (Seperator)

- (void)addDefaultSeperator {
    [self addLineByMask:kBottomMask startMargin:15];
}

- (void)addLineByMask:(kMarginMask)mask {
    [self addLineByMask:mask margin:0];
}

- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin {
    [self addLineByMask:mask startMargin:startMargin endMargin:0];
}

- (void)addLineByMask:(kMarginMask)mask margin:(CGFloat)margin {
    [self addLineByMask:mask startMargin:margin endMargin:margin];
}

- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin endMargin:(CGFloat)endMargin {
    [self addLineByMask:mask startMargin:startMargin endMargin:endMargin color:nil height:0];
}

- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin endMargin:(CGFloat)endMargin color:(UIColor *)color height:(CGFloat)showHeight {
    NSInteger lineTag = ABS([self hash] - (mask + SEPEATOR_LINE_BASE_TAG));
    BLESeperatorLine *line = (BLESeperatorLine *)[self viewWithTag:lineTag];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat height = showHeight > 0 ? showHeight : 1.f / scale;
    CGFloat lineSize = MAX(ceilf(showHeight), HEIGHT_SEPERATOR);
    CGRect rect = CGRectZero;
    UIViewAutoresizing viewMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    switch (mask) {
        case kBottomMask:
            rect.origin.y = self.rdpHeight - lineSize;
            rect.origin.x = startMargin;
            rect.size.height = lineSize;
            rect.size.width = self.rdpWidth - startMargin - endMargin;
            break;
        case kTopMask:
            rect.origin.y = 0;
            rect.origin.x = startMargin;
            rect.size.height = lineSize;
            rect.size.width = self.rdpWidth - startMargin - endMargin;
            viewMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case kLeftMask:
            rect.origin.y = startMargin;
            rect.origin.x = 0;
            rect.size.width = lineSize;
            rect.size.height = self.rdpHeight - startMargin - endMargin;
            viewMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
            break;
        case kRightMask:
            rect.origin.y = startMargin;
            rect.origin.x = self.rdpWidth - lineSize;
            rect.size.width = lineSize;
            rect.size.height = self.rdpHeight - startMargin - endMargin;
            viewMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
            break;
        default:
            break;
    }
    
    if (!line) {
        line = [[BLESeperatorLine alloc] initWithFrame:rect];
        [line setBackgroundColor:[UIColor clearColor]];
        line.autoresizingMask = viewMask;
        line.tag = lineTag;
        [self addSubview:line];
    }
    
    line.frame = rect;
    
    UIColor *showColor = color ?: RDP_SEPARATOR_COLOR;
    [line setSeperatorMask:mask color:showColor height:height];
}

- (void)removeAllLine {
    for (kMarginMask mask = kBottomMask; mask <= kRightMask; mask++) {
        [self removeLineByMask:mask];
    }
}

- (void)removeLineByMask:(kMarginMask)mask {
    NSInteger tag = ABS([self hash] - (mask + SEPEATOR_LINE_BASE_TAG));;
    UIView *line = [self viewWithTag:tag];
    [line removeFromSuperview];
}

@end
