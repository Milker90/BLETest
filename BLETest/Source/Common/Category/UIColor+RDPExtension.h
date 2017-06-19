//
//  UIColor+RDPExtension.h
//  Pods
//
//  Created by Allan Liu on 16/6/24.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (RDPExtension)

+ (UIColor *)colorWithHex:(int)color;
+ (UIColor *)colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end
