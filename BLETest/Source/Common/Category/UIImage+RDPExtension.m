//
//  UIImage+RDPExtension.m
//  Pods
//
//  Created by whj on 15/5/25.
//
//

#import "UIImage+RDPExtension.h"
#import "NSArray+RDPExtension.h"

@implementation UIImage (RDPExtension)

+ (UIImage *)imgForColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.4, 0.4, 0.4, 0.4)];
}

+ (UIImage *)imgForColor:(UIColor *)color size:(CGSize)size {
    if (!color) {
        return nil;
    }
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage stretchImg];
}

- (UIImage *)stretchImg {
    CGFloat width = MIN(self.size.width * 0.1, 1);
    CGFloat height = MIN(self.size.height * 0.1, 1);
    CGFloat insertX = (self.size.width - width) / 2.f;
    CGFloat insertY = (self.size.height - height) / 2.f;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(insertY, insertX, insertY, insertX)];
}


+ (UIImage *)imgWithColor:(UIColor *)color
               rectCorner:(UIRectCorner)rectCorner
                   bounds:(CGRect)bounds
              cornerRadii:(CGSize)cornerRadii {
    if (!color) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                     byRoundingCorners:rectCorner
                                                           cornerRadii:cornerRadii];
    [color setFill];
    [bezierPath fill];
    
    CGContextAddPath(context, bezierPath.CGPath);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imgWithColors:(NSArray *)colors bounds:(CGRect)bounds {
    if (!colors) {
        return nil;
    }
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bounds;
    
    NSMutableArray *colorRefs = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorRefs safeAddObject:(id)color.CGColor];
    }
    layer.colors = colorRefs;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)circleImgWithColor:(UIColor *)color radius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2 * radius, 2 * radius), NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 2 * radius, 2 * radius));
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
