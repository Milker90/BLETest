//
//  NSString+Extension.m
//  RongFramework
//
//  Created by dicky on 15/5/15.
//  Copyright (c) 2015年 dicky. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extension.h"
#import "NSArray+RDPExtension.h"
#import <CoreFoundation/CFURL.h>
#import "NSDictionary+RDPExtension.h"

@implementation NSString (UIDisplayRect)

+ (CGRect)heightForString:(NSString *)str Size:(CGSize)size Font:(UIFont *)font
{
    return [NSString heightForString:str Size:size Font:font Lines:0];
}

+ (CGRect)heightForString:(NSString *)str Size:(CGSize)size Font:(UIFont *)font Lines:(NSInteger)lines
{
    if (StringIsNullOrEmpty(str))
    {
        return CGRectMake(0, 0, 0, 0);
    }
    static UILabel *lbtext;
    if (lbtext == nil)
    {
        lbtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    else
    {
        lbtext.frame = CGRectMake(0, 0, size.width, size.height);
    }
    lbtext.font = font;
    lbtext.text = str;
    lbtext.numberOfLines = lines;
    CGRect rect = [lbtext textRectForBounds:lbtext.frame limitedToNumberOfLines:lines];
    if(rect.size.height < 0)
    {
        rect.size.height = 0;
    }
    if (rect.size.width < 0)
    {
        rect.size.width = 0;
    }
    return rect;
}
- (NSMutableAttributedString *)getAttributedStringWithFont:(UIFont *)font andLineSpacing:(CGFloat)space {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    if (space > 0) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    }
    if (font) {
        [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [self length])];
    }
    return str;
}
- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width andLineSpacing:(CGFloat)space {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (font) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    CGFloat singleLineWidth = [self getWidthWithFont:font height:MAXFLOAT];
    if (singleLineWidth > width && space > 0) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    if (attributes.count > 0) {
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:NULL];
        return stringRect.size.height;
    }
    else {
        return 0;
    }
}

- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    return [self getHeightWithFont:font width:width andLineSpacing:0];
}

- (CGFloat)getWidthWithFont:(UIFont *)font height:(CGFloat)height
{
    if (!font) {
        return 0;
    }
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute safeSetObject:font forKey:NSFontAttributeName];
    CGRect stringRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:NULL];
    return stringRect.size.width;
}

@end


@implementation NSString (Coding)

+ (NSString *)md5Decode:(NSString *)str
{
    if (StringIsNullOrEmpty(str)) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19],
            result[20], result[21], result[22], result[23],
            result[24], result[25], result[26], result[27],
            result[28], result[29], result[30], result[31]
            ];
}

- (NSString *)md5Decode
{
    return [NSString md5Decode:self];
}

+ (NSString *)md5Encode:(NSString *)str
{
    if(StringIsNullOrEmpty(str))
    {
        return nil;
    }
    
    const char *value = [str UTF8String];
    if (NULL == value) {
        return nil;
    }
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
    {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)md5Encode
{
    return [NSString md5Encode:self];
}

+ (NSData *)base64Decode:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4]={0}, outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return nil;
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

- (NSString *)base64Decode
{
    return [[NSString alloc] initWithData:[NSString base64Decode:self] encoding:NSUTF8StringEncoding];
}


+ (NSString *)base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    NSInteger length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    if (NULL == raw) {
        return nil;
    }
    ixtext = 0;
    
    while (true)
    {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++)
        {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining)
        {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (NSString *)base64Encode
{
    return [NSString base64Encode:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                            (CFStringRef)self,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)URLDecoding {
    NSString *str = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
    
}

- (NSString *)UTF8Encoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                            (CFStringRef)self,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            NULL,
                                                                            kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)UnicodeDecoding {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSString *)convertToEscapedJSONString {
    NSMutableString *s = [NSMutableString stringWithString:self];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

@end


@implementation NSString (Extension)

- (NSString *)trimString
{
    NSString *newString = nil;
    
    if (StringNotNullAndEmpty(self))
    {
        newString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (StringIsNullOrEmpty(newString))
    {
        newString = nil;
    }
    
    return newString;
}

- (NSInteger)byteCount
{
    NSInteger count = 0;
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char* cString = [self cStringUsingEncoding:gbkEncoding];
    
    if (cString)
    {
        count = strlen(cString);
    }
    
    return count;
}

- (BOOL)isMatchedPattern:(NSString *)pattern {
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger num = [expression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return num > 0;
}

- (NSString *)matchStringWith:(NSString *)pattern {
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [expression rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    if (range.location != NSNotFound) {
        return [self substringWithRange:range];
    }
    
    return @"";
}

- (NSString *)tailByLength:(NSUInteger)length {
    if (self.length <= length) {
        return self;
    }
    
    return [self substringFromIndex:self.length - length];
}

- (NSString*)splitWithString:(NSString*)splitStr each:(NSUInteger)eachLen {
    NSMutableString *retString = [NSMutableString stringWithString:self];
    NSInteger strLen = self.length;
    NSInteger splitOffset = 0;
    NSInteger idx = 0;
    while (idx < strLen) {
        if (idx > eachLen - 1) {
            [retString insertString:splitStr atIndex:idx+splitOffset];
            splitOffset++;
        }
        idx += eachLen;
    }
    return retString;
}

- (NSString*)endSplitWithString:(NSString*)splitStr each:(NSUInteger)eachLen {
    NSMutableString *retString = [NSMutableString stringWithString:self];
    NSInteger strLen = self.length;
    NSInteger idx = 0;
    while (idx < strLen) {
        if (idx > eachLen - 1) {
            [retString insertString:splitStr atIndex:strLen-idx];
        }
        idx += eachLen;
    }
    return retString;
}

- (NSString*)secretStringhead:(NSUInteger)head tail:(NSUInteger)tail {
    NSString* orgStr = self;
    NSUInteger orgLen = [orgStr length];
    NSInteger starCount = orgLen - (head + tail);
    if (starCount < 0) {
        return orgStr;
    }
    
    NSMutableString* strRet = [NSMutableString string];
    if (head > 0) {
        [strRet appendString:[orgStr substringWithRange:NSMakeRange(0, head)]];
    }
    
    for (int i = 0; i < starCount; i++) {
        [strRet appendString:@"*"];
    }
    
    if (tail > 0) {
        [strRet appendString:[orgStr substringWithRange:NSMakeRange(orgLen - tail, tail)]];
    }
    
    return strRet;
}

- (NSString *)secretString {
    NSString *result = @"";
    if ([self isValidEmail]) {
        NSRange range = [self rangeOfString:@"@"];
        result = [self secretStringhead:2 tail:[self length] - range.location + 2];
    } else if ([self isValidPhone]) {
        result = [self secretStringhead:3 tail:4];
    } else if ([self isValidIDNO]) {
        result = [self secretStringhead:3 tail:3];
    } else if ([self isValidCardNO]) {
        result = [self secretStringhead:4 tail:4];
    } else {
        if (self.length == 2) {
            result = [self secretStringhead:0 tail:1];
        } else {
            result = [self secretStringhead:1 tail:1];
        }
    }
    
    return result;
}

- (NSString *)showMoneySring {
    if (![self isValidAmount]) {
        return self;
    }
    
    NSArray *array = [self componentsSeparatedByString:@"."];
    if ([array count] == 0) {
        return self;
    }
    NSMutableString *showStr = [NSMutableString string];
    NSString *preAmount = [array strAt:0];
    NSInteger length = preAmount.length;
    NSInteger num = 0;
    for (NSInteger i = length - 1; i >= 0; i--) {
        num ++;
        NSString *subChar = [preAmount substringWithRange:NSMakeRange(i, 1)];
        [showStr insertString:subChar atIndex:0];
        if (num % 3 == 0 && i != 0 && i != length - 1) {
            [showStr insertString:@"," atIndex:0];
        }
    }
    
    NSString *suffixAmount = [array strAt:1];
    if (suffixAmount.length > 0) {
        [showStr appendFormat:@".%@", suffixAmount];
    }
    return showStr;
}

- (NSDictionary *)divisionStr
{
    NSArray *arr = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *subStr in arr) {
        NSArray *subArr = [subStr componentsSeparatedByString:@"="];
        if (2 == subArr.count) {
            NSString *value = [[subArr safeObjectAtIndex:1] URLDecoding];
            [dic safeSetObject:value forKey:[subArr safeObjectAtIndex:0]];
        }
    }
    return dic;
}

@end


@implementation NSString (Valid)

- (BOOL)isValidEmail {
    
    if (self.length == 0) {
        return NO;
    }
    
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidNumber {
    long length = [self length];
    if (length <= 0) {
        return NO;
    }
    
    for (int index = 0; index < length; index++)
    {
        unichar endCharacter = [self characterAtIndex:index];
        if (endCharacter < '0' || endCharacter > '9') {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isValidDigit
{
    if ([self length] == 0) {
        return NO;
    }
    
    NSString* patternStr = @"^([+-]?([1-9]\\d*)|0)(\\.\\d*)?$";
    return [self isMatchedPattern:patternStr];
}

- (BOOL)isValidAmount {
    if ([self length] == 0) {
        return NO;
    }
    
    NSString* patternStr = @"^(([1-9]\\d*)|0)(\\.\\d*)?$";
    return [self isMatchedPattern:patternStr];
}

- (BOOL)isValidIDNO {
    UInt16 len = [self length];
    if (len != 15 && len != 18) {
        return NO;
    }
    
    BOOL isNewStyle = len == 18;
    NSString* regexString = isNewStyle ? @"^[1-9]\\d{5}((1\\d)|(20))\\d{2}((0[1-9])|(1[0-2]))((0[1-9])|([12]\\d)|(3[01]))\\d{3}[\\dxX]$" : @"^[1-9]\\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([12]\\d)|(3[01]))\\d{3}$";
    
    return [self isMatchedPattern:regexString] && (!isNewStyle || [self verifyNewStyleIDNumber]);
}

- (BOOL)verifyNewStyleIDNumber {
    int total = 0;
    NSString * upper = [self uppercaseString];
    unichar verify = [upper characterAtIndex:17];
    //w[i] = pow(2, 18-i-1) mod 11
    static int w[17] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    static int v[11] = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};
    for (int i = 0; i < 17; ++i) {
        int a = [[upper substringWithRange:NSMakeRange(i, 1)] intValue];
        total += a * w[i];
    }
    int mod = total % 11;
    return v[mod] == verify;
}

- (BOOL)isValidCardNO {
    return self.length >= 12 && [self isValidNumber];
}

- (BOOL)isValidPhone {
    return self.length == 11 && [self isValidNumber];
}

- (BOOL)isValidTradePwd {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    return [self isMatchedPattern:pattern];
}

- (BOOL)isValidZipCode {
    NSString *pattern = @"^\\d{6}$";
    return [self isMatchedPattern:pattern];
}

- (BOOL)isValidLandlineTelephone {
    NSString *pattern = @"^(?:010|02\\d|0[3-9]\\d{2})\\-\\d{7,8}\\-(?:\\d{1,4}$)?";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* match = [expression matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    if (match.count > 0) {
        for (NSUInteger i = 0; i < match.count; i++) {
            NSTextCheckingResult *subMatch = match[i];
            if (subMatch.range.length == self.length) {
                return YES;
            }
        }
        return NO;
    }
    else {
        return NO;
    }
}

@end


@implementation NSString (Pinyin)

- (NSString*)pinYin
{
    //先转换为带声调的拼音
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL,kCFStringTransformMandarinLatin,NO);
    return str;
}

- (NSString *)pinYinWithoutTone {
    NSMutableString *str = [[self pinYin] mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL,kCFStringTransformStripDiacritics,NO);
    return str;
}

- (NSString*)firstCharactor
{
    NSString *pinYin = [[[self substringToIndex:1] pinYin] uppercaseString];
    return [pinYin substringToIndex:1];
}

- (unsigned long long)unsignedLongLongValue {
    
    return self.longLongValue;
}

//将16进制的字符串转换成NSData
- (NSMutableData *)convertHexStrToData {
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([self length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

- (NSString *)hexStringFromString {
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(NSInteger i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length] == 1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (NSString *)reserverString {
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:self.length];
    for (int i = self.length - 1; i >=0 ; i --) {
        unichar ch = [self characterAtIndex:i];
        [newString appendFormat:@"%c", ch];
    }
    return newString;
}

@end
