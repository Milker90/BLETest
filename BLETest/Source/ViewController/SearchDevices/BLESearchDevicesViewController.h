//
//  BLESearchDevicesViewController.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLESearchDevicesViewControllerDelegate <NSObject>

- (void)selectedDevice:(CBPeripheral *)peripheral;

@end

@interface BLESearchDevicesViewController : UIViewController

@property (nonatomic, weak) id <BLESearchDevicesViewControllerDelegate>delegate;

@end
