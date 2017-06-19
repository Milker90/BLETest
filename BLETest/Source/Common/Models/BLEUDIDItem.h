//
//  BLEUDIDItem.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BLEUDIDItem : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL close;
@property (nonatomic, copy) NSString *key;

@end
