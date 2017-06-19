//
//  BLEHomeButton.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEHomeButton.h"

@interface BLEHomeButton()

@property (nonatomic, weak) BLEHomeItem *item;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BLEHomeButton

- (void)setupUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.f;
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:ImageNamed(@"FeatureBackground") forState:UIControlStateNormal];
    [_button setBackgroundImage:ImageNamed(@"FeatureBackgroundPressed") forState:UIControlStateHighlighted];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(78, 78));
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = RGBCOLOR(0, 0, 0);
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(_button.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(78, 18));
    }];
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEHomeItem class]]) {
        return;
    }
    
    BLEHomeItem *item = (BLEHomeItem *)data;
    self.item = item;
    _nameLabel.text = NSLocalizedString(item.name, nil);
    [_button setImage:ImageNamed(item.icon) forState:UIControlStateNormal];
}

- (void)buttonAction {
    if (_delegate && [_delegate respondsToSelector:@selector(homebuttonTouchAction:)]) {
        [_delegate homebuttonTouchAction:_item];
    }
}

@end
