//
//  BLEUARTViewController.m
//  BLETest
//
//  Created by Allan Liu on 16/10/7.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEUARTViewController.h"
#import "NSString+Extension.h"
#import "UIView+Seperator.h"
#import "BLECustomButton.h"
#import "UIImage+RDPExtension.h"
#import "BLESearchDevicesViewController.h"
#import "BabyBluetooth.h"

@interface BLEUARTViewController () <BLESearchDevicesViewControllerDelegate>

@property (nonatomic, assign) BabyBluetooth *baby;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSArray *services;

@property (nonatomic, strong) UIImage *autoImage;
@property (nonatomic, strong) UIImage *unautoImage;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) BLECustomButton *hexDisplayButton;
@property (nonatomic, strong) UILabel *hexReceiveByteLabel;
@property (nonatomic, strong) UITextField *sendTextField;
@property (nonatomic, strong) BLECustomButton *hexSendButton;
@property (nonatomic, strong) UILabel *hexSendByteLabel;

@property (nonatomic, assign) CGRect originRect;

@end

@implementation BLEUARTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    //初始化BabyBluetooth 蓝牙库
    _baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

- (void)setupUI {
    self.autoImage = [[UIImage imageNamed:@"btn_auto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.unautoImage = [[UIImage imageNamed:@"btn_unauto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UILabel *label1 = [UILabel new];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = BLE_TITLE_COLOR;
    label1.text = NSLocalizedString(@"Receive Data", nil);
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.view).offset(12);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    NSString *clearStr = NSLocalizedString(@"Clear", nil);
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton addTarget:self action:@selector(bleclearaction) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:BLE_TITLE_COLOR forState:UIControlStateNormal];
    [clearButton setTitle:clearStr forState:UIControlStateNormal];
    clearButton.layer.cornerRadius = 12.5;
    clearButton.layer.borderWidth = 1.f;
    clearButton.titleLabel.font = [UIFont systemFontOfSize:12];
    clearButton.layer.borderColor = BLE_TITLE_COLOR.CGColor;
    [self.view addSubview:clearButton];
    CGFloat width = [clearStr getWidthWithFont:clearButton.titleLabel.font height:30] + 18;
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(width, 24));
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = HEXCOLOR(0xc7c8cc);
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.view).offset(44);
        make.height.mas_equalTo(DRAW_LINE_WIDTH);
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
    
    _hexSendButton = [BLECustomButton new];
    [_hexSendButton addTarget:self action:@selector(blehexsend) forControlEvents:UIControlEventTouchUpInside];
    _hexSendButton.titleLabel.text = NSLocalizedString(@"HEX Send", nil);
    _hexSendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _hexSendButton.imageView.tintColor = [UIColor grayColor];
    _hexSendButton.imageView.image = _unautoImage;
    [self.view addSubview:_hexSendButton];
    CGFloat hexsendwidth = [_hexSendButton.titleLabel.text getWidthWithFont:[UIFont systemFontOfSize:14] height:18];
    [_hexSendButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hexSendButton).offset(5);
        make.centerY.mas_equalTo(_hexSendButton);
        make.size.mas_equalTo(CGSizeMake(hexsendwidth + 5, 18));
    }];
    [_hexSendButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_hexSendButton).offset(-5);
        make.centerY.mas_equalTo(_hexSendButton);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_hexSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.view).offset(-84);
        make.size.mas_equalTo(CGSizeMake(hexsendwidth + 35, 30));
    }];
    
    _hexSendByteLabel = [UILabel new];
    _hexSendByteLabel.textColor = BLE_TITLE_COLOR;
    _hexSendByteLabel.font = [UIFont systemFontOfSize:14];
    NSString *hexSendBtyeStr = [NSString stringWithFormat:@"%@:0", NSLocalizedString(@"Send Byte", nil)];
    NSMutableAttributedString *hexSendBtyeAttr = [[NSMutableAttributedString alloc] initWithString:hexSendBtyeStr];
    NSRange range1 = [hexSendBtyeStr rangeOfString:@"0"];
    [hexSendBtyeAttr addAttribute:NSForegroundColorAttributeName value:BLE_CONTENT_COLOR range:range1];
    _hexSendByteLabel.attributedText = hexSendBtyeAttr;
    [self.view addSubview:_hexSendByteLabel];
    [_hexSendByteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.view).offset(-84);
        make.size.mas_equalTo(CGSizeMake(hexsendwidth + 35, 30));
    }];
    
    _sendTextField = [UITextField new];
    _sendTextField.borderStyle = UITextBorderStyleRoundedRect;
    _sendTextField.font = [UIFont systemFontOfSize:14];
    _sendTextField.textColor = BLE_CONTENT_COLOR;
    [self.view addSubview:_sendTextField];
    [_sendTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_hexSendButton.mas_top).offset(-8);
        make.height.mas_equalTo(44);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = HEXCOLOR(0xc7c8cc);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.bottom.mas_equalTo(_sendTextField.mas_top).offset(-10);
        make.height.mas_equalTo(DRAW_LINE_WIDTH);
    }];
    
    
    UILabel *sendlabel = [UILabel new];
    sendlabel.backgroundColor = [UIColor clearColor];
    sendlabel.textColor = BLE_TITLE_COLOR;
    sendlabel.text = NSLocalizedString(@"Send Data", nil);
    sendlabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:sendlabel];
    [sendlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(line2.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    NSString *sendStr = NSLocalizedString(@"Send", nil);
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(blesendaction) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:BLE_TITLE_COLOR forState:UIControlStateNormal];
    [sendButton setTitle:sendStr forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 12.5;
    sendButton.layer.borderWidth = 1.f;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sendButton.layer.borderColor = BLE_TITLE_COLOR.CGColor;
    [self.view addSubview:sendButton];
    CGFloat sendstrwidth = [sendStr getWidthWithFont:sendButton.titleLabel.font height:30] + 18;
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(line2.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(sendstrwidth, 24));
    }];
    
    _hexDisplayButton = [BLECustomButton new];
    [_hexDisplayButton addTarget:self action:@selector(blehexdisplay) forControlEvents:UIControlEventTouchUpInside];
    _hexDisplayButton.titleLabel.text = NSLocalizedString(@"HEX Display", nil);
    _hexDisplayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _hexDisplayButton.imageView.tintColor = [UIColor grayColor];
    _hexDisplayButton.imageView.image = _unautoImage;
    [self.view addSubview:_hexDisplayButton];
    CGFloat hexdiswidth = [_hexDisplayButton.titleLabel.text getWidthWithFont:[UIFont systemFontOfSize:14] height:18];
    [_hexDisplayButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hexDisplayButton).offset(5);
        make.centerY.mas_equalTo(_hexDisplayButton);
        make.size.mas_equalTo(CGSizeMake(hexdiswidth + 5, 18));
    }];
    [_hexDisplayButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_hexDisplayButton).offset(-5);
        make.centerY.mas_equalTo(_hexDisplayButton);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_hexDisplayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(sendButton.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(hexdiswidth + 35, 30));
    }];
    
    _hexReceiveByteLabel = [UILabel new];
    _hexReceiveByteLabel.textColor = BLE_TITLE_COLOR;
    _hexReceiveByteLabel.font = [UIFont systemFontOfSize:14];
    NSString *hexReceiveByteStr = [NSString stringWithFormat:@"%@:0", NSLocalizedString(@"Receive Byte", nil)];
    NSMutableAttributedString *hexReceiveByteAttr = [[NSMutableAttributedString alloc] initWithString:hexReceiveByteStr];
    NSRange range2 = [hexReceiveByteStr rangeOfString:@"0"];
    [hexReceiveByteAttr addAttribute:NSForegroundColorAttributeName value:BLE_CONTENT_COLOR range:range2];
    _hexReceiveByteLabel.attributedText = hexReceiveByteAttr;
    [self.view addSubview:_hexReceiveByteLabel];
    [_hexReceiveByteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(sendButton.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(hexdiswidth + 35, 30));
    }];
    
    _textView = [UITextView new];
    _textView.editable = NO;
    _textView.pagingEnabled = NO;
    _textView.scrollEnabled = YES;
    _textView.showsVerticalScrollIndicator = YES;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = BLE_CONTENT_COLOR;
    _textView.layer.borderColor = HEXCOLOR(0xc7c8cc).CGColor;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.cornerRadius = 4.f;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(_hexDisplayButton.mas_top).offset(-10);
        make.top.mas_equalTo(line1.mas_top).offset(10);
    }];
}

- (void)bleclearaction {
    _sendTextField.text = nil;
    _textView.text = nil;
}

- (void)blehexdisplay {
    
}

- (void)blehexsend {
    
}

- (void)blesendaction {
    
}

- (void)searchDevice {
    BLESearchDevicesViewController *vc = [BLESearchDevicesViewController new];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)tapAction {
    if ([_sendTextField isFirstResponder]) {
        [_sendTextField resignFirstResponder];
    }
}

#pragma mark
#pragma mark - 蓝牙

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    //__weak typeof(self) weakSelf = self;
    [_baby setBlockOnCentralManagerDidUpdateStateAtChannel:@"UART" block:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            //[SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    
    //设置发现设备的Services的委托
    [_baby setBlockOnDiscoverServicesAtChannel:@"UART" block:^(CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"搜索到服务:\n%@",peripheral.services);
    }];
    
    //设置发现设service的Characteristics的委托
    [_baby setBlockOnDiscoverCharacteristicsAtChannel:@"UART" block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        //NSLog(@"服务:%@\n characteristics:%@\n",service, service.characteristics);
        //NSLog(@"\n\n");
    }];
    
    //设置读取characteristics的委托
    [_baby setBlockOnReadValueForCharacteristicAtChannel:@"UART" block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //NSLog(@"characteristic name:%@ value is:%@",characteristic.UUID, [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
    }];
    
    //设置发现characteristics的descriptors的委托
    [_baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:@"UART" block:^(CBPeripheral *peripheral, CBCharacteristic *service, NSError *error) {
        //NSLog(@"===characteristic name:%@",service.UUID);
        //for (CBDescriptor *d in service.descriptors) {
            //NSLog(@"CBDescriptor name is :%@",d.UUID);
        //}
    }];
    
    [_baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:@"" block:^(CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
    //设置读取Descriptor的委托
    [_baby setBlockOnReadValueForDescriptorsAtChannel:@"UART" block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        //NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    [_baby setBlockOnDidWriteValueForCharacteristicAtChannel:@"UART" block:^(CBCharacteristic *characteristic, NSError *error) {
        //NSLog(@"%@", characteristic);
    }];
    
    //
    [_baby setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:@"UART" block:^(CBCentralManager *centralManager) {
        //NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_baby setBlockOnConnectedAtChannel:@"UART" block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);
    }];
    
    //设置设备连接失败的委托
    [_baby setBlockOnFailToConnectAtChannel:@"UART" block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    [_baby setBlockOnDisconnectAtChannel:@"UART" block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        //NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
}

#pragma mark
#pragma mark - BLESearchDevicesViewControllerDelegate
- (void)selectedDevice:(CBPeripheral *)peripheral {
    if (!_baby) {
        return;
    }
    self.peripheral = peripheral;
    
    _baby.having(peripheral).and.channel(@"UART").then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    
    //[self setupData];
    //[self performSelector:@selector(updateDevice) withObject:nil afterDelay:1];
}

#pragma mark
#pragma mark - Keyboard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    _tabelView.contentInset = contentInsets;
    CGRect rect = self.view.frame;
    self.originRect = rect;
    rect.origin.y -= kbSize.height;
    self.view.frame = rect;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    _tabelView.contentInset = contentInsets;
//    _tabelView.scrollIndicatorInsets = contentInsets;
    self.view.frame = _originRect;
}

@end
