//
//  UIImage+RDPExtension.h
//  Pods
//
//  Created by whj on 15/5/25.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (RDPExtension)

+ (UIImage *)imgForColor:(UIColor *)color;
+ (UIImage *)imgForColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)stretchImg;

+ (UIImage *)imgWithColor:(UIColor *)color
               rectCorner:(UIRectCorner)rectCorner
                   bounds:(CGRect)bounds
              cornerRadii:(CGSize)cornerRadii;

/**
 *  将渐变色转换成图片
 *
 *  @param colors 渐变色数组，元素类型是UIColor
 *  @param bounds 图片的frame
 *
 *  @return 图片
 */
+ (UIImage *)imgWithColors:(NSArray *)colors
                    bounds:(CGRect)bounds;


/**
 *
 *
 *  @param color  圆颜色
 *  @param radius 半径
 *
 *  @return 生成的圆的图片
 */
+ (UIImage *)circleImgWithColor:(UIColor *)color radius:(CGFloat)radius;

@end
