//
//  BLEFactoryTestViewController.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEFactoryTestViewController.h"
#import "BLESearchDevicesViewController.h"
#import "UIImage+RDPExtension.h"
#import "UIView+Seperator.h"
#import "NSString+Extension.h"
#import "BabyBluetooth.h"
#import "BLEHeaderCell.h"
#import "BLEDISCell.h"
#import "BLELEDCell.h"
#import "BLEMaDaCell.h"
#import "BLETapCell.h"
#import "BLEUDIDCell.h"
#import "BLEHeaderItem.h"
#import "BLEDISItem.h"
#import "BLELEDItem.h"
#import "BLEMaDaItem.h"
#import "BLETapItem.h"
#import "BLEUDIDItem.h"

@interface BLEFactoryTestViewController () <BLESearchDevicesViewControllerDelegate,UITableViewDataSource,UITableViewDelegate, BLEHeaderCellDelegate, BLELEDCellDelegate, BLEMaDaCellDelegate, BLEUDIDCellDelegate, BLETapCellDelegate, BLEDISCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *workArray;

@property (nonatomic, assign) BabyBluetooth *baby;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSArray *services;

@end

@implementation BLEFactoryTestViewController

- (void)dealloc
{
    [_baby cancelAllPeripheralsConnection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    self.workArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLEHeaderCell class] forCellReuseIdentifier:@"BLEHeaderCell"];
    [_tableView registerClass:[BLEDISCell class] forCellReuseIdentifier:@"BLEDISCell"];
    [_tableView registerClass:[BLELEDCell class] forCellReuseIdentifier:@"BLELEDCell"];
    [_tableView registerClass:[BLEMaDaCell class] forCellReuseIdentifier:@"BLEMaDaCell"];
    [_tableView registerClass:[BLETapCell class] forCellReuseIdentifier:@"BLETapCell"];
    [_tableView registerClass:[BLEUDIDCell class] forCellReuseIdentifier:@"BLEUDIDCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset (-84);
        make.top.mas_equalTo(self.view);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[ImageNamed(@"ConnectButton") stretchImg] forState:UIControlStateNormal];
    [button setBackgroundImage:[ImageNamed(@"ConnectButtonPressed") stretchImg] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(searchDevice) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"search device", nil) forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.wirelessImageView.mas_top).offset (-10);
        make.size.mas_equalTo(CGSizeMake(155, 44));
    }];
    
    //初始化BabyBluetooth 蓝牙库
    _baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    [self.noDataView updateUI:@{@"title":NSLocalizedString(@"Please Select Device", nil), @"icon":@"scanning"}];
    [self.view addSubview:self.noDataView];
}

- (void)setupData {
    [self.noDataView removeFromSuperview];
    [_workArray removeAllObjects];

    //UDID
    BLEUDIDItem *udidm = [BLEUDIDItem new];
    udidm.title = @"UDID:";
    udidm.close = NO;
    udidm.key = @"udid";
    [_workArray addObject:@[udidm]];
    
    //DIS
    NSDictionary *config = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_config"];
    NSMutableArray *disArr = [NSMutableArray array];
    BLEHeaderItem *headerItem = [BLEHeaderItem new];
    headerItem.title = NSLocalizedString(@"DIS CONFIGURE", nil);
    headerItem.btTitle = NSLocalizedString(@"update", nil);
    headerItem.close = NO;
    headerItem.action = @"update";
    [disArr addObject:headerItem];

    BLEDISItem *dis0 = [BLEDISItem new];
    dis0.title = NSLocalizedString(@"Model Number", nil);
    dis0.key = @"model";
    dis0.cmdkey = @"ATDIS1";
    dis0.canCheck = YES;
    dis0.value = [config stringAtPath:dis0.key];
    [disArr addObject:dis0];
    
    BLEDISItem *dis1 = [BLEDISItem new];
    dis1.title = NSLocalizedString(@"Serial Number", nil);
    dis1.key = @"serial";
    dis1.canCheck = YES;
    dis1.canAuto = YES;
    dis1.cmdkey = @"ATDIS2";
    dis1.value = [config stringAtPath:dis1.key];
    [disArr addObject:dis1];
    
    BLEDISItem *dis2 = [BLEDISItem new];
    dis2.title = NSLocalizedString(@"Mac Address", nil);
    dis2.key = @"mac";
    dis2.canCheck = YES;
    dis2.canAuto = YES;
    dis2.cmdkey = @"ATDIS7";
    dis2.value = [config stringAtPath:dis2.key];
    [disArr addObject:dis2];
    
    BLEDISItem *dis3 = [BLEDISItem new];
    dis3.title = NSLocalizedString(@"Firmware Revision", nil);
    dis3.key = @"firmware";
    dis3.canCheck = YES;
    dis3.cmdkey = @"ATDIS4";
    dis3.value = [config stringAtPath:dis3.key];
    [disArr addObject:dis3];
    
    BLEDISItem *dis4 = [BLEDISItem new];
    dis4.title = NSLocalizedString(@"Hardware Revision", nil);
    dis4.key = @"hardware";
    dis4.canCheck = YES;
    dis4.cmdkey = @"ATDIS3";
    dis4.value = [config stringAtPath:dis4.key];
    [disArr addObject:dis4];
    
    BLEDISItem *dis5 = [BLEDISItem new];
    dis5.title = NSLocalizedString(@"Manufacture Name", nil);
    dis5.key = @"manufacture";
    dis5.canCheck = YES;
    dis5.cmdkey = @"ATDIS0";
    dis5.value = [config stringAtPath:dis5.key];
    [disArr addObject:dis5];
    
    [_workArray addObject:disArr];
    
    // LED
    NSMutableArray *ledArr = [NSMutableArray array];
    BLEHeaderItem *ledHeaderItem = [BLEHeaderItem new];
    ledHeaderItem.title = NSLocalizedString(@"LED Test", nil);
    ledHeaderItem.close = YES;
    [ledArr addObject:ledHeaderItem];
    
    NSArray *ledValues = @[@{@"title":NSLocalizedString(@"Light", nil), @"value":@1}, @{@"title":NSLocalizedString(@"Close", nil), @"value":@2}, @{@"title":NSLocalizedString(@"Flash", nil), @"value":@3}, @{@"title":NSLocalizedString(@"Breath", nil), @"value":@4}];

    BLELEDItem *redLEDItem = [BLELEDItem new];
    redLEDItem.title = NSLocalizedString(@"Red LED", nil);
    redLEDItem.key = @"red";
    redLEDItem.canCheck = YES;
    redLEDItem.values = ledValues;
    [ledArr addObject:redLEDItem];
    
    BLELEDItem *greenLEDItem = [BLELEDItem new];
    greenLEDItem.title = NSLocalizedString(@"Green LED", nil);
    greenLEDItem.key = @"green";
    greenLEDItem.canCheck = YES;
    greenLEDItem.values = ledValues;
    [ledArr addObject:greenLEDItem];
    
    BLELEDItem *blueLEDItem = [BLELEDItem new];
    blueLEDItem.title = NSLocalizedString(@"Blue LED", nil);
    blueLEDItem.key = @"blue";
    blueLEDItem.canCheck = YES;
    blueLEDItem.values = ledValues;
    [ledArr addObject:blueLEDItem];
    
    [_workArray addObject:ledArr];
    
    // Ma Da
    NSMutableArray *madaArr = [NSMutableArray array];
    BLEHeaderItem *madaHeaderItem = [BLEHeaderItem new];
    madaHeaderItem.close = YES;
    madaHeaderItem.title = NSLocalizedString(@"Motor Test", nil);
    [ledArr addObject:madaHeaderItem];
    
    NSArray *madaValues = @[@{@"title":NSLocalizedString(@"Open", nil), @"value":@1}, @{@"title":NSLocalizedString(@"Close", nil), @"value":@2}];
    
    BLEMaDaItem *madaItem = [BLEMaDaItem new];
    madaItem.title = NSLocalizedString(@"Vibration Motor", nil);
    madaItem.key = @"motor";
    madaItem.canCheck = YES;
    madaItem.values = madaValues;
    [madaArr addObject:madaItem];
    
    [_workArray addObject:madaArr];
    
    // Tap
    NSMutableArray *tapArr = [NSMutableArray array];
    BLEHeaderItem *tapHeaderItem = [BLEHeaderItem new];
    tapHeaderItem.title = NSLocalizedString(@"Tap Test", nil);
    tapHeaderItem.close = YES;
    [tapArr addObject:tapHeaderItem];
    
    BLETapItem *tapItem = [BLETapItem new];
    tapItem.title = NSLocalizedString(@"Tap Count", nil);
    tapItem.key = @"tap";
    tapItem.cmdkey = @"ATDIS1";
    tapItem.canCheck = YES;
    tapItem.canAuto = YES;
    [tapArr addObject:tapItem];
    
    [_workArray addObject:tapArr];
    
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)searchDevice {
    BLESearchDevicesViewController *vc = [BLESearchDevicesViewController new];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _workArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [_workArray safeObjectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [_workArray safeObjectAtIndex:indexPath.section];
    id data = [arr safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:[BLEUDIDItem class]]) {
        BLEUDIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLEUDIDCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell addLineByMask:kBottomMask startMargin:15];
        [cell updateUI:data];
        return cell;
    }
    
    if ([data isKindOfClass:[BLEHeaderItem class]]) {
        BLEHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLEHeaderCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell addLineByMask:kBottomMask startMargin:15];
        [cell updateUI:data];
        return cell;
    }
    
    if ([data isKindOfClass:[BLEDISItem class]]) {
        BLEDISCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLEDISCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateUI:data];
        return cell;
    }
    
    if ([data isKindOfClass:[BLELEDItem class]]) {
        BLELEDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLELEDCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateUI:data];
        return cell;
    }
    
    if ([data isKindOfClass:[BLEMaDaItem class]]) {
        BLEMaDaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLEMaDaCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateUI:data];
        return cell;
    }
    
    if ([data isKindOfClass:[BLETapItem class]]) {
        BLETapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLETapCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateUI:data];
        return cell;
    }
    
    return [UITableViewCell new];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 65.f;
    }
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CBCharacteristic *)findCharacteristic:(NSString *)serviceUdid characteristicUdid:(NSString *)characteristicUdid {
    CBCharacteristic *characteristic = nil;
    for (CBService *service in _peripheral.services) {
        if ([[service.UUID UUIDString] isEqualToString:serviceUdid]) {
            for (CBCharacteristic *tcharacteristic in service.characteristics) {
                if ([tcharacteristic.UUID.UUIDString isEqualToString:characteristicUdid]) {
                    characteristic = tcharacteristic;
                    break;
                }
            }
        }
    }
    return characteristic;
}

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    //__weak typeof(self) weakSelf = self;
    [_baby setBlockOnCentralManagerDidUpdateStateAtChannel:@"FactoryTest" block:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            //[SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    
    //设置发现设备的Services的委托
    [_baby setBlockOnDiscoverServicesAtChannel:@"FactoryTest" block:^(CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"搜索到服务:\n%@",peripheral.services);
    }];
    
    //设置发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristicsAtChannel:@"FactoryTest" block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        //NSLog(@"服务:%@\n characteristics:%@\n",service, service.characteristics);
        //NSLog(@"\n\n");
    }];
    
    //设置读取characteristics的委托
    [_baby setBlockOnReadValueForCharacteristicAtChannel:@"FactoryTest" block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //NSLog(@"characteristic name:%@ value is:%@",characteristic.UUID, [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
    }];
    
    //设置发现characteristics的descriptors的委托
    [_baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:@"FactoryTest" block:^(CBPeripheral *peripheral, CBCharacteristic *service, NSError *error) {
        //NSLog(@"===characteristic name:%@",service.UUID);
        for (CBDescriptor *d in service.descriptors) {
            //NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    
    [_baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:@"" block:^(CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
    //设置读取Descriptor的委托
    [_baby setBlockOnReadValueForDescriptorsAtChannel:@"FactoryTest" block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        //NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristicAtChannel:@"FactoryTest" block:^(CBCharacteristic *characteristic, NSError *error) {
        //NSLog(@"%@", characteristic);
    }];
    
    //
    [_baby setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:@"FactoryTest" block:^(CBCentralManager *centralManager) {
        //NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_baby setBlockOnConnectedAtChannel:@"FactoryTest" block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);
    }];
    
    //设置设备连接失败的委托
    [_baby setBlockOnFailToConnectAtChannel:@"FactoryTest" block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    [_baby setBlockOnDisconnectAtChannel:@"FactoryTest" block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
}

- (void)updateDevice {
    BLEUDIDItem *udidItem = [[_workArray safeObjectAtIndex:0] safeObjectAtIndex:0];
    udidItem.value = _peripheral.identifier.UUIDString;
    [_tableView reloadData];
    /*
    Byte b = 0x12;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    
    CBCharacteristic *characteristic = nil;
    for (CBService *service in _peripheral.services) {
        if ([[service.UUID UUIDString] isEqualToString:@"1803"]) {
            characteristic = [service.characteristics safeObjectAtIndex:0];
            break;
        }
    }
    [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
     */
    
}

- (void)hasDoneAction {
    [_tableView reloadData];
}

#pragma mark
#pragma mark - BLEUDIDCellDelegate
- (void)bleclose {
    Byte b = 0x0e;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    CBCharacteristic *characteristic = [self findCharacteristic:@"1802" characteristicUdid:@"2A06"];
    if (characteristic) {
        [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark
#pragma mark - BLESearchDevicesViewControllerDelegate
- (void)selectedDevice:(CBPeripheral *)peripheral {
    if (!_baby) {
        return;
    }
    self.peripheral = peripheral;
    
    _baby.having(peripheral).and.channel(@"FactoryTest").then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    
    [self setupData];
    [self performSelector:@selector(updateDevice) withObject:nil afterDelay:1];
}

#pragma mark
#pragma mark - BLEHeaderCellDelegate
- (void)headerAction:(BLEHeaderItem *)item {
    if ([item.action isEqualToString:@"update"]) {
        // 更新dis
        NSString *serviceUdid = @"000056EF-0000-1000-8000-00805F9B34FB";
        NSString *characteristicUdid = @"000034E1-0000-1000-8000-00805F9B34FB";
        CBCharacteristic *characteristic = [self findCharacteristic:serviceUdid characteristicUdid:characteristicUdid];
        if (!characteristic) {
            return;
        }
        
        NSArray *arr = [_workArray safeObjectAtIndex:1];
        for (BLEDISItem *item in arr) {
            if ([item isKindOfClass:[BLEDISItem class]]) {
                if (item.value.length > 0) {
                    if ([item.key isEqualToString:@"mac"]) {
                        NSMutableData *valueData = [NSMutableData dataWithData:[[NSString stringWithFormat:@"%@=", item.cmdkey] dataUsingEncoding:NSUTF8StringEncoding]];
                        NSString *value = [[item.value stringByReplacingOccurrencesOfString:@":" withString:@""] reserverString];
                        NSLog(@"%@", value);
                        NSMutableData *data = [value convertHexStrToData];
                        [valueData appendData:data];
                        [_peripheral writeValue:valueData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];

                    } else {
                        NSString *cmdStr = [NSString stringWithFormat:@"%@=%@", item.cmdkey, item.value];
                        NSLog(@"%@", cmdStr);
                        NSData *data = [cmdStr dataUsingEncoding:NSUTF8StringEncoding];
                        [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    }
                    [NSThread sleepForTimeInterval:0.05];
                }
            }
        }
        
        Byte b = 0x0f;
        NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
        CBCharacteristic *aletCharacteristic = [self findCharacteristic:@"1802" characteristicUdid:@"2A06"];
        if (aletCharacteristic) {
            [_peripheral writeValue:data forCharacteristic:aletCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
        
        [self.view addSubview:self.noDataView];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"The device has been disconnected, please reconnect the device." preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertView animated:YES completion:NULL];
    }
}

#pragma mark
#pragma mark - BLELEDCellDelegate
- (void)ledAction:(BLELEDItem *)item {    
    NSString *value = [item getHexValue];
    if (value.length > 0) {
        CBCharacteristic *characteristic = [self findCharacteristic:@"1802" characteristicUdid:@"2A06"];
        if (characteristic) {
            NSMutableData *data = [value convertHexStrToData];
            [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

#pragma mark
#pragma mark - BLEMaDaCellDelegate
- (void)madaAction:(BLEMaDaItem *)item {
    NSString *value = [item getHexValue];
    if (value.length > 0) {
        CBCharacteristic *characteristic = [self findCharacteristic:@"1802" characteristicUdid:@"2A06"];
        if (characteristic) {
            NSMutableData *data = [value convertHexStrToData];
            [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

#pragma mark
#pragma mark - BLETapCellDelegate
- (void)bletap:(BLETapItem *)item {
//    CBCharacteristic *characteristic = [self findCharacteristic:@"1802" characteristicUdid:@"2A06"];
    if (item.autoed) {
//        Byte b = 0xf0;
//        NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
//        [_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        CBCharacteristic *notifycharacteristic = [self findCharacteristic:@"000056EF-0000-1000-8000-00805F9B34FB" characteristicUdid:@"000034E2-0000-1000-8000-00805F9B34FB"];
        __weak typeof(self)weakSelf = self;
        [_baby notify:_peripheral characteristic:notifycharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
            NSLog(@"%@", characteristics);
            if (characteristics.value.length == 1) {
                NSInteger i = 0;
                [characteristics.value getBytes:&i range:NSMakeRange(0, 1)];
                BLETapItem *item = [[_workArray safeObjectAtIndex:4] safeObjectAtIndex:1];
                if (item) {
                    item.value = [NSString stringWithFormat:@"%@", @(i)];
                    [weakSelf.tableView reloadData];
                }
            }
        }];
    } else {
        CBCharacteristic *notifycharacteristic = [self findCharacteristic:@"000056EF-0000-1000-8000-00805F9B34FB" characteristicUdid:@"000034E2-0000-1000-8000-00805F9B34FB"];
        [_baby cancelNotify:_peripheral characteristic:notifycharacteristic];
    }
    [_tableView reloadData];
}

@end
