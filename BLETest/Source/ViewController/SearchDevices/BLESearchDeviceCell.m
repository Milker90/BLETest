//
//  BLESearchDeviceCell.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLESearchDeviceCell.h"
#import "BLEScannedPeripheralItem.h"

@interface BLESearchDeviceCell ()

@property (nonatomic, strong) UILabel *rissLabel;
@property (nonatomic, strong) UIImageView *flagImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BLESearchDeviceCell

- (void)setupUI {
    _rissLabel = [UILabel new];
    _rissLabel.backgroundColor = [UIColor clearColor];
    _rissLabel.font = [UIFont boldSystemFontOfSize:12];
    _rissLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rissLabel];
    [_rissLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(36);
    }];
    
    _flagImageView = [UIImageView new];
    [self.contentView addSubview:_flagImageView];
    [_flagImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rissLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 15));
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(55);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
}

- (UIImage *)getRSSIImage:(NSInteger)rssi {
    UIImage *image = nil;
    if (rssi < -90) {
        image = ImageNamed(@"Signal_0");
    }else if (rssi < -70) {
        image = ImageNamed(@"Signal_1");
    }else if (rssi < -50) {
        image = ImageNamed(@"Signal_2");
    }else{
        image = ImageNamed(@"Signal_3");
    }
    return image;
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEScannedPeripheralItem class]]) {
        return;
    }
    
    BLEScannedPeripheralItem *item = (BLEScannedPeripheralItem *)data;
    _flagImageView.image = [self getRSSIImage:item.rssi];
    _nameLabel.text = item.peripheral.name;
    _rissLabel.text = [NSString stringWithFormat:@"%@", @(item.rssi)];
}

@end
