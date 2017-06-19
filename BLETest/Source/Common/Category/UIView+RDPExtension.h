//
//  UIView+RDPExtension.h
//  Pods
//
//  Created by whj on 15/5/14.
//
//

#import <UIKit/UIKit.h>

// 过期提醒
#define RDPDeprecated(instead)  NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

@interface UIView (RDPExtension)

/**
 *  @return frame.origin.x
 */
- (CGFloat)rdpLeft;

/**
 *  @return CGRectGetMaxX(self.frame)
 */
- (CGFloat)rdpRight;

/**
 *  @return frame.origin.y
 */
- (CGFloat)rdpTop;

/**
 *  @return CGRectGetMaxY(self.frame)
 */
- (CGFloat)rdpBottom;

/**
 *  @return frame.size.width
 */
- (CGFloat)rdpWidth;

/**
 *  @return frame.size.height
 */
- (CGFloat)rdpHeight;

/**
 *  @return CGRectGetMidX(self.frame)
 */
- (CGFloat)rdpCenterX;

/**
 *  @return CGRectGetMidY(self.frame)
 */
- (CGFloat)rdpCenterY;

/**
 *  @return frame.size
 */
- (CGSize)rdpSize;

/**
 *  设置 frame.origin.x
 */
- (void)setRdpLeft:(CGFloat)left;

/**
 *  设置 frame.origin.y
 */
- (void)setRdpTop:(CGFloat)top;

/**
 *  设置 frame.size.width
 */
- (void)setRdpWidth:(CGFloat)width;

/**
 *  设置 frame.size.height
 */
- (void)setRdpHeight:(CGFloat)height;

/**
 *  设置view横向的中间坐标
 */
- (void)setRdpCenterX:(CGFloat)centerX;

/**
 *  设置view纵向的中间坐标
 */
- (void)setRdpCenterY:(CGFloat)centerY;

/**
 *  @param size 设置 frame.size
 */
- (void)setRdpSize:(CGSize)size;

/**
 *    设置右边距
 *
 */
- (void)setRdpRight:(CGFloat)right;

/**
 *    设置底部边距
 *
 */
- (void)setRdpBottom:(CGFloat)bottom;

/**
 *  @return frame.origin.x
 */
- (CGFloat)left RDPDeprecated("使用rdpLeft代替");

/**
 *  @return CGRectGetMaxX(self.frame)
 */
- (CGFloat)right RDPDeprecated("使用rdpRight代替") ;

/**
 *  @return frame.origin.y
 */
- (CGFloat)top RDPDeprecated("使用rdpTop代替");

/**
 *  @return CGRectGetMaxY(self.frame)
 */
- (CGFloat)bottom RDPDeprecated("使用rdpBottom代替");


/**
 *  @return frame.size.width
 */
- (CGFloat)width RDPDeprecated("使用rdpWidth代替");

/**
 *  @return frame.size.height
 */
- (CGFloat)height RDPDeprecated("使用rdpHeight代替");

/**
 *  @return CGRectGetMidX(self.frame)
 */
- (CGFloat)centerX RDPDeprecated("使用rdpCenterX代替");

/**
 *  @return CGRectGetMidY(self.frame)
 */
- (CGFloat)centerY RDPDeprecated("使用rdpCenterY代替");

/**
 *  @return frame.size
 */
- (CGSize)size RDPDeprecated("使用rdpSize代替");

/**
 *  设置 frame.origin.x
 */
- (void)setLeft:(CGFloat)left RDPDeprecated("使用rdpLeft代替");
/**
 *    设置右边距
 *
 */
- (void)setRight:(CGFloat)right RDPDeprecated("使用rdpRight代替");

/**
 *  设置 frame.origin.y
 */
- (void)setTop:(CGFloat)top RDPDeprecated("使用rdpTop代替");

/**
 *    设置底部边距
 *
 */
- (void)setBottom:(CGFloat)bottom RDPDeprecated("使用rdpBottom代替");

/**
 *  设置 frame.size.width
 */
- (void)setWidth:(CGFloat)width RDPDeprecated("使用rdpWidth代替");

/**
 *  设置 frame.size.height
 */
- (void)setHeight:(CGFloat)height RDPDeprecated("使用rdpHeight代替");

/**
 *  设置view横向的中间坐标
 */
- (void)setCenterX:(CGFloat)centerX RDPDeprecated("使用setRdpCenterX代替");

/**
 *  设置view纵向的中间坐标
 */
- (void)setCenterY:(CGFloat)centerY RDPDeprecated("使用setRdpCenterY代替");

/**
 *  @param size 设置 frame.size
 */
- (void)setSize:(CGSize)size RDPDeprecated("使用setRdpSize代替");

/**
 *  移除当前view的所有子view
 */
- (void)rdpRemoveAllSubViews;

@end
