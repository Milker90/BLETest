//
//  NSMutableAttributedString+RDPExtension.m
//  Pods
//
//  Created by whj on 15/8/20.
//
//

#import "NSMutableAttributedString+RDPExtension.h"

@implementation NSMutableAttributedString (RDPExtension)

- (void)setNumFont:(UIFont *)font color:(UIColor *)color {
    [self setPattern:@"[\\d.%]+" font:font color:color];
}

- (void)setSingleNumFont:(UIFont *)font color:(UIColor *)color {
    [self setPattern:@"[\\d.]+" font:font color:color];
}

- (void)setLetterFont:(UIFont *)font color:(UIColor *)color {
    [self setPattern:@"[A-Za-z]+" font:font color:color];
}

- (void)setPattern:(NSString *)pattern font:(UIFont *)font color:(UIColor *)color {
    
    if (pattern.length == 0) {
        return;
    }
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [expression matchesInString:self.string options:NSMatchingReportProgress range:NSMakeRange(0, self.string.length)];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        NSRange range = obj.range;
        if (range.location != NSNotFound) {
            [self addAttribute:NSFontAttributeName value:font range:range];
            [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }];
}

- (void)setSubString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    if (string.length == 0) {
        return;
    }
    
    NSRange range = [self.string rangeOfString:string];
    if (range.location != NSNotFound) {
        [self addAttribute:NSFontAttributeName value:font range:range];
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font andLineSpacing:(CGFloat)space {
    if (string.length <= 0) {
        return nil;
    }
    
    self = [self initWithString:string];
    if (self) {
        if (space > 0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:space];
            [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        }
        if (font) {
            [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [string length])];
        }
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
                          font:(UIFont *)font
                         color:(UIColor*)color
                andLineSpacing:(CGFloat)space {
    self = [self initWithString:string font:font andLineSpacing:space];
    if (self) {
        if (color) {
            [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [string length])];
        }
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    return [self initWithString:string font:font color:color andLineSpacing:0.f];
}

@end
