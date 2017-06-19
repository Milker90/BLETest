//
//  BLEHomeListItem.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, BLEHomeType) {
    kBLEHomeDFUType = 1,
    kBLEHomePROCUTIONType,
    kBLEHomeDiagnosticType,
    kBLEHomeUARTType,
};

@protocol BLEHomeItem;

@interface BLEHomeItem : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BLEHomeType type;

@end

@interface BLEHomeListItem : JSONModel

@property (nonatomic, strong) NSArray<BLEHomeItem> *list;

@end
