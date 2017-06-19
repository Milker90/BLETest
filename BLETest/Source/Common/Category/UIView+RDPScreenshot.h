//
//  UIView+RDPScreenshot.h
//  Pods
//
//  Created by Allan Liu on 16/9/9.
//
//

#import <UIKit/UIKit.h>

@interface UIView (RDPScreenshot)

- (UIImage *)rdpScreenshot;
- (UIImage *)rdpScreenshotWithOffset:(CGFloat)deltaY;

@end
