//
//  BLEDISItem.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BLEDISItem : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *cmdkey;

@property (nonatomic, assign) BOOL autoed;
@property (nonatomic, assign) BOOL canAuto;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL canCheck;

@end
