//
//  BLEScannedPeripheralItem.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEScannedPeripheralItem : JSONModel

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign) BOOL isConnected;

@end
