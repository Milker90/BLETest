//
//  BLEMaDaItem.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEMaDaItem.h"

@implementation BLEMaDaItem

- (NSString *)getHexValue {
    NSString *valueStr = nil;
    NSDictionary *dict = [_values safeObjectAtIndex:_value];
    if (!dict) {
        return valueStr;
    }
    BLEMaDaSelectType type = [[dict numberAtPath:@"value"] integerValue];
    if (type == kBLEMaDaOpenType) {
        return @"41";
    } else if (type == kBLEMaDaCloseType) {
        return @"40";
    }
    return valueStr;
}

@end
