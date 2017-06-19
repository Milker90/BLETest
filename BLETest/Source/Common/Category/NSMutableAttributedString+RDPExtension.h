//
//  NSMutableAttributedString+RDPExtension.h
//  Pods
//
//  Created by whj on 15/8/20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (RDPExtension)

/**
 *  设置文本中数字的大小和颜色(包含.和%符号)
 *
 *  @param font  字体大小
 *  @param color 字体颜色
 */
- (void)setNumFont:(UIFont *)font color:(UIColor *)color;

/**
 *  设置纯数字number
 *
 *  @param font  字体大小
 *  @param color 字体颜色
 */
- (void)setSingleNumFont:(UIFont *)font color:(UIColor *)color;

/**
 *  设置文本中字母的大小和颜色(包含大写和小写字母)
 *
 *  @param font  字体大小
 *  @param color 字体颜色
 */
- (void)setLetterFont:(UIFont *)font color:(UIColor *)color;

/**
 *  设置匹配正则式的文本的大小和颜色
 *
 *  @param pattern 设置正则式
 *  @param font    字体大小
 *  @param color   字体颜色
 */
- (void)setPattern:(NSString *)pattern font:(UIFont *)font color:(UIColor *)color;

/**
 *  设置文本中某个字符串的大小和颜色
 *
 *  @param string 需要设置的字符串
 *  @param font   字体大小
 *  @param color  字体颜色
 */
- (void)setSubString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

/**
 *  初始化
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param space  行间距
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font andLineSpacing:(CGFloat)space;

/**
 *  初始化
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param color  字体颜色
 *  @param space  行间距
 */
- (instancetype)initWithString:(NSString *)string
                          font:(UIFont *)font
                         color:(UIColor*)color
                andLineSpacing:(CGFloat)space;

/**
 *  初始化 行间距为0
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param color  字体颜色
 */
- (instancetype)initWithString:(NSString *)string
                          font:(UIFont *)font
                         color:(UIColor *)color;

@end
