//
//  BLELEDItem.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, BLELEDSelectType) {
    kBLELEDNoneType = 0,
    kBLELEDLightType,
    kBLELEDCloseType,
    kBLELEDFlashType,
    kBLELEDBreathType,
};

@interface BLELEDItem : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *cmdkey;

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL canCheck;

- (NSString *)getHexValue;

@end
