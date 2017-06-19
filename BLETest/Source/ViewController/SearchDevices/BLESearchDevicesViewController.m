//
//  BLESearchDevicesViewController.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLESearchDevicesViewController.h"
#import "BLESearchDeviceCell.h"
#import "BabyBluetooth.h"
#import "BLEScannedPeripheralItem.h"
#import "UIView+Seperator.h"

@interface BLESearchDevicesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *devices;

@property (nonatomic, assign) BabyBluetooth *baby;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) CBPeripheral *peripheral;


@end

@implementation BLESearchDevicesViewController

- (void)dealloc {
    NSLog(@"BLESearchDevicesViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = RGBCOLOR(16,132,205);
    self.title = NSLocalizedString(@"search device title", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(blecancel)];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(0, 0, 30, 30);
    [view startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[BLESearchDeviceCell class] forCellReuseIdentifier:@"BLESearchDeviceCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellS"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //初始化BabyBluetooth 蓝牙库
    _baby = [BabyBluetooth shareBabyBluetooth];
    
    NSArray *arr = [_baby findConnectedPeripherals];
    if (arr.count > 0) {
        self.devices = [NSMutableArray array];
        CBPeripheral *peripheral = [arr safeObjectAtIndex:0];
        if (peripheral) {
            BLEScannedPeripheralItem *item = [BLEScannedPeripheralItem new];
            item.peripheral = peripheral;
            item.isConnected = YES;
            [peripheral readRSSI];
            [_devices safeAddObject:item];
            self.peripheral = peripheral;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(readRssi)
                                                        userInfo:nil
                                                         repeats:1.5];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
        
    } else {
        self.devices = [NSMutableArray array];
    }
    
    //设置蓝牙委托
    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    _baby.scanForPeripherals().begin();
    
    
}

- (void)readRssi {
    if (_peripheral) {
        [_peripheral readRSSI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)blecancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BLEScannedPeripheralItem *)findPeripheralInArr:(CBPeripheral *)peripheral {
    BLEScannedPeripheralItem *sitem = nil;
    for (BLEScannedPeripheralItem *item in _devices) {
        if (item.peripheral == peripheral) {
            sitem = item;
            break;
        }
    }
    return sitem;
}

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    
    [_baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            //[SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    [_baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        BLEScannedPeripheralItem *item = [weakSelf findPeripheralInArr:_peripheral];
        item.rssi = [RSSI integerValue];
        [weakSelf.tableView reloadData];
    }];
    
    //设置扫描到设备的委托
    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@, %@, %@",peripheral, advertisementData, RSSI);
        BOOL isConnectable =  [advertisementData boolAtPath:CBAdvertisementDataIsConnectable];
        if (isConnectable) {
            BLEScannedPeripheralItem *item = [weakSelf findPeripheralInArr:peripheral];
            if (!item) {
                item = [BLEScannedPeripheralItem new];
                item.peripheral = peripheral;
                item.rssi = [RSSI integerValue];
                item.isConnected = NO;
                [weakSelf.devices safeAddObject:item];
            } else {
                item.rssi = [RSSI integerValue];
            }
            [weakSelf.tableView reloadData];
        }
    }];
    
    //设置发现设备的Services的委托
    [_baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    
    //设置发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    
    //设置读取characteristics的委托
    [_baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    
    //设置发现characteristics的descriptors的委托
    [_baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    
    //设置读取Descriptor的委托
    [_baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [_baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [_baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);

    }];
    
    //设置设备连接失败的委托
    [_baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    [_baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [_baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [_devices safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:[BLEScannedPeripheralItem class]]) {
        BLESearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLESearchDeviceCell" forIndexPath:indexPath];
        [cell addLineByMask:kBottomMask startMargin:55];
        [cell updateUI:data];
        return cell;
    }
    
    return [UITableViewCell new];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id data = [_devices safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:[BLEScannedPeripheralItem class]]) {
        BLEScannedPeripheralItem *item = (BLEScannedPeripheralItem *)data;
        if (item.isConnected) {
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(selectedDevice:)]) {
            [_delegate selectedDevice:item.peripheral];
        }
        [_baby cancelScan];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
