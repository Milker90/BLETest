//
//  UIView+RDPExtension.m
//  Pods
//
//  Created by whj on 15/5/14.
//
//

#import "UIView+RDPExtension.h"

@implementation UIView (RDPExtension)

- (CGFloat)rdpLeft {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)rdpRight {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)rdpTop {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)rdpBottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)rdpWidth {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)rdpHeight {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)rdpCenterX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)rdpCenterY {
    return CGRectGetMidY(self.frame);
}

- (CGSize)rdpSize {
    return self.frame.size;
}

- (void)setRdpLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (void)setRdpTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (void)setRdpWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setRdpHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setRdpCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setRdpCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setRdpSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setRdpRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setRdpBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)rdpRemoveAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
