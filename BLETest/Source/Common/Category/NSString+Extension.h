//
//  NSString+Extension.h
//  RongFramework
//
//  Created by dicky on 15/5/15.
//  Copyright (c) 2015年 dicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

///获取一个字符串转换为URL
#define URL(str) [NSURL URLWithString:[str UTF8Encoding]]

///判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str == nil || [str isEqualToString:@""])

///判断字符串不为空并且不为空字符串
#define StringNotNullAndEmpty(str) (str != nil && ![str isEqualToString:@""])

///快速格式化一个字符串
#define _S(str,...) [NSString stringWithFormat:str, ##__VA_ARGS__]




/**
 *  获取文本的显示高度,  可变长文本显示时可能会用到
 */
@interface NSString (UIDisplayRect)

+(CGRect)heightForString:(NSString *)str Size:(CGSize)size Font:(UIFont *)font;
+(CGRect)heightForString:(NSString *)str Size:(CGSize)size Font:(UIFont *)font Lines:(NSInteger)lines;
/**
 *  根据字体和行间距获得文本高度
 *
 *  @param font  字体
 *  @param width 文本框宽度
 *  @param space 行间距 space <= 0 表示使用默认行间距
 *
 *  @return 文本所需高度
 */
- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width andLineSpacing:(CGFloat)space;
- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width;
/**
 *  单行文本所需宽度
 *
 *  @param font   字体
 *  @param height 限高
 *
 *  @return 单行文本所需宽度
 */
- (CGFloat)getWidthWithFont:(UIFont *)font height:(CGFloat)height;
/**
 *  根据字体和行间距生成attributedString
 *
 *  @param font  字体
 *  @param space 行间距
 *
 *  @return 属性字符串
 */
- (NSMutableAttributedString *)getAttributedStringWithFont:(UIFont *)font andLineSpacing:(CGFloat)space;

@end


/**
 *  字符串加密(编码)、解密(解码)相关，   MD5   Base64  AES256
 */
@interface NSString (Coding)

//获取MD5解码后的串
+ (NSString *)md5Decode:(NSString *)str;
- (NSString *)md5Decode;

//获取MD5加密后的串
+ (NSString *)md5Encode:(NSString *)str;
- (NSString *)md5Encode;

//对NSData进行Base64编码，返回编码后的串
+ (NSString *)base64Encode:(NSData *)data;
- (NSString *)base64Encode;

//对NSString进行Base64解码，返回解码后的串
+ (NSData *)base64Decode:(NSString *)string;
- (NSString *)base64Decode;

// url编码
- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

// utf8编码
- (NSString *)UTF8Encoding;

- (NSString *)UnicodeDecoding;

// 将json字符串转成转义
- (NSString *)convertToEscapedJSONString;

@end


@interface NSString (Extension)

/**
 *  去除字符串中收尾空格和换行
 *
 *  @return 去掉空格后的字符串
 */
- (NSString *)trimString;

/**
 *  计算字符串字节数，英文为1，中文为2
 *
 *  @return 字符串字节数
 */
- (NSInteger)byteCount;

/**
 *  @param pattern 正则式
 *
 *  @return 是否匹配正则式
 */
- (BOOL)isMatchedPattern:(NSString *)pattern;

/**
 *
 *  @param splitStr 插入的字符串
 *  @param eachLen  每隔几个字符插入
 *
 *  @return 返回插入新字符后的字符串
 */
- (NSString*)splitWithString:(NSString*)splitStr each:(NSUInteger)eachLen;

/**
 *  从后面添加分割符号
 *
 *  @param splitStr 插入的字符串
 *  @param eachLen  每隔几个字符插入
 *
 */
- (NSString*)endSplitWithString:(NSString*)splitStr each:(NSUInteger)eachLen;

/**
 *  用*对字符串加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)secretString;

/**
 *  @param pattern 正则式
 *
 *  @return 匹配正则式的第一个字符串
 */
- (NSString *)matchStringWith:(NSString *)pattern;

/**
 *
 *  @param length 尾号长度
 *
 *  @return 长度为length的尾部字符串
 */
- (NSString *)tailByLength:(NSUInteger)length;

/**
 *
 *  @return 显示的金额字符串, 每3位用逗号分隔
 */
- (NSString *)showMoneySring;

/**
 *  分割url字符串去字典
 *
 */
- (NSDictionary *)divisionStr;

@end

@interface NSString (Valid)

/**
 *  @return 是否是合法的邮箱
 */
- (BOOL)isValidEmail;
/**
 *  @return 是否全是数字(不含小数)
 */
- (BOOL)isValidNumber;

/**
 *  @return 是否是数字(包含小数)
 */
- (BOOL)isValidDigit;

/**
 *  @return 是否是有效的金额
 */
- (BOOL)isValidAmount;

/**
 *  @return 是否是有效身份证号码
 */
- (BOOL)isValidIDNO;

/**
 *  @return 是否有效的银行卡号
 */
- (BOOL)isValidCardNO;

/**
 *  @return 是否有效的手机号码
 */
- (BOOL)isValidPhone;

/**
 *  @return 是否有效的交易密码 规则8-16位, 数字和字母组合
 */
- (BOOL)isValidTradePwd;

/**
 *  @return 是否是有效的邮编
 */
- (BOOL)isValidZipCode;

/**
 *  @return 是否是有效的固定电话 格式：区号-电话号码-分机号码
 */
- (BOOL)isValidLandlineTelephone;

@end


@interface NSString (Pinyin)

/**
 *  将汉字转换为拼音(带声调)
 *
 *  @return 转换后的拼音
 */
- (NSString *)pinYin;

/**
 *
 *  @return 不带声调的拼音
 */
- (NSString *)pinYinWithoutTone;

/**
 *  @return 拼音的首字母
 */
- (NSString *)firstCharactor;
/**
 *  字符串类别修复baseitem解析bug
 *
 *  @return 值
 */
- (unsigned long long)unsignedLongLongValue;

- (NSMutableData *)convertHexStrToData;
- (NSString *)hexStringFromString;

- (NSString *)reserverString;

@end

