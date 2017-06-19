//
//  BLELEDItem.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLELEDItem.h"

@implementation BLELEDItem

- (NSString *)getHexValue {
    NSString *valueStr = nil;
    NSDictionary *dict = [_values safeObjectAtIndex:_value];
    if (!dict) {
        return valueStr;
    }
    BLELEDSelectType type = [[dict numberAtPath:@"value"] integerValue];
    if ([_key isEqualToString:@"blue"]) {
        if (type == kBLELEDLightType) {
            return @"11";
        } else if (type == kBLELEDCloseType) {
            return @"10";
        } else if (type == kBLELEDFlashType) {
            return @"12";
        } else if (type == kBLELEDBreathType) {
            return @"14";
        }
    } else if ([_key isEqualToString:@"green"]) {
        if (type == kBLELEDLightType) {
            return @"21";
        } else if (type == kBLELEDCloseType) {
            return @"20";
        } else if (type == kBLELEDFlashType) {
            return @"22";
        } else if (type == kBLELEDBreathType) {
            return @"24";
        }
    } else if ([_key isEqualToString:@"red"]) {
        if (type == kBLELEDLightType) {
            return @"31";
        } else if (type == kBLELEDCloseType) {
            return @"30";
        } else if (type == kBLELEDFlashType) {
            return @"32";
        } else if (type == kBLELEDBreathType) {
            return @"34";
        }
    }
    return valueStr;
}

@end
