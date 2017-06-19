//
//  UIView+Seperator.h
//  Pods
//
//  Created by whj on 15/5/31.
//
// 添加的分割线位于view的底部

#import <UIKit/UIKit.h>
#import "BLESeperatorLine.h"

@interface UIView (Seperator)

/**
 *  添加默认cell的分隔线: 位于底部, 左边距15
 */
- (void)addDefaultSeperator;

/**
 *  添加铺满的分割线
 *
 *  @param mask 分割线的位置类型
 */
- (void)addLineByMask:(kMarginMask)mask;

/**
 *  添加结束边距的分隔线
 *
 *  @param mask        分割线位置类型
 *  @param startMargin 起始边距
 */
- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin;

/**
 *  添加居中的分割线(起始边距和结束边距一样)
 *
 *  @param mask   分割线位置类型
 *  @param margin 起始边距和结束边距
 */
- (void)addLineByMask:(kMarginMask)mask margin:(CGFloat)margin;

/**
 *  添加默认高度和颜色的分割线
 *
 *  @param mask        分割线位置类型
 *  @param startMargin 起始边距
 *  @param endMargin   结束边距
 */
- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin endMargin:(CGFloat)endMargin;

/**
 *  添加高度自定义的分割线
 *
 *  @param mask        分割线位置类型
 *  @param startMargin 起始边距
 *  @param endMargin   结束边距
 *  @param color       分割线颜色
 *  @param showHeight  分割线高度
 */
- (void)addLineByMask:(kMarginMask)mask startMargin:(CGFloat)startMargin endMargin:(CGFloat)endMargin color:(UIColor *)color height:(CGFloat)showHeight;

/**
 *   移除所有的分割线
 */
- (void)removeAllLine;

/**
 *  移除某类型的分割线
 *
 *  @param mask 需移除分割线的类型
 */
- (void)removeLineByMask:(kMarginMask)mask;

@end
