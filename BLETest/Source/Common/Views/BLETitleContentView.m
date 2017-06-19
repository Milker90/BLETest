//
//  BLETitleContentView.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLETitleContentView.h"
#import "NSString+Extension.h"
#import "BLEDISItem.h"

@interface BLETitleContentView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *valueLabel;

@end

@implementation BLETitleContentView

- (void)setupUI {
    self.layer.borderColor = BLE_TITLE_COLOR.CGColor;
    self.layer.borderWidth = 1.f;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.f;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = BLE_TITLE_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    _valueLabel = [UITextField new];
    _valueLabel.textColor = BLE_CONTENT_COLOR;
    _valueLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_valueLabel];
    
}

- (void)updateUI:(id)data {
    if (!data) {
        return;
    }
    
    _titleLabel.text = [data valueForKey:@"title"];
    CGFloat tWidth = [_titleLabel.text getWidthWithFont:_titleLabel.font height:20] + 4;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(tWidth, 20));
    }];
    
    _valueLabel.text = [data valueForKey:@"value"];
    [_valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    _valueLabel.enabled = [[data valueForKey:@"autoed"] boolValue];
}


@end
