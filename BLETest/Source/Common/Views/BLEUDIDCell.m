//
//  BLEUDIDCell.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEUDIDCell.h"
#import "NSString+Extension.h"

@interface BLEUDIDCell ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation BLEUDIDCell

- (void)setupUI {
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = BLE_TITLE_COLOR;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = @"UDID:";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    NSString *title = NSLocalizedString(@"Close RF", nil) ;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:title forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(bleclose) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.layer.cornerRadius = 12.5;
    _closeButton.layer.borderWidth = 1.f;
    _closeButton.layer.borderColor = BLE_TITLE_COLOR.CGColor;
    [_closeButton setTitleColor:BLE_TITLE_COLOR forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_closeButton];
    CGFloat wi = [title getWidthWithFont:[UIFont systemFontOfSize:16] height:18] + 18;
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(wi, 25));
    }];
    
    _valueLabel = [UILabel new];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.textColor = BLE_TITLE_COLOR;
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    _valueLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEUDIDItem class]]) {
        return;
    }
    
    BLEUDIDItem *item = (BLEUDIDItem *)data;
    _nameLabel.text = item.title;
    _valueLabel.text = item.value;
}

- (void)bleclose {
    if (_delegate && [_delegate respondsToSelector:@selector(bleclose)]) {
        [_delegate bleclose];
    }
}


@end
