//
//  BLEHeaderCell.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEHeaderCell.h"
#import "NSString+Extension.h"

@interface BLEHeaderCell ()

@property (nonatomic, weak) BLEHeaderItem *item;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BLEHeaderCell

- (void)setupUI {
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = BLE_TITLE_COLOR;
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton addTarget:self action:@selector(bleaction) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setTitleColor:BLE_TITLE_COLOR forState:UIControlStateNormal];
    _actionButton.layer.cornerRadius = 12.5;
    _actionButton.layer.borderWidth = 1.f;
    _actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _actionButton.layer.borderColor = BLE_TITLE_COLOR.CGColor;
    [self.contentView addSubview:_actionButton];
    
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEHeaderItem class]]) {
        return;
    }
    
    BLEHeaderItem *item = (BLEHeaderItem *)data;
    self.item = item;
    _nameLabel.text = item.title;
    if (item.btTitle.length > 0) {
        _actionButton.hidden = NO;
        [_actionButton setTitle:item.btTitle forState:UIControlStateNormal];
        CGFloat width = [item.btTitle getWidthWithFont:_actionButton.titleLabel.font height:30] + 18;
        [_actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(width, 25));
        }];
    } else {
        _actionButton.hidden = YES;
    }
    
}

- (void)bleaction {
    if (_delegate && [_delegate respondsToSelector:@selector(headerAction:)]) {
        [_delegate headerAction:_item];
    }
}

@end
