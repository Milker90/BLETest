//
//  BLEMaDaCell.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEMaDaCell.h"
#import "BLECustomButton.h"
#import "NSString+Extension.h"

@interface BLEMaDaCell()

@property (nonatomic, weak) BLEMaDaItem *item;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray *valueButtons;

@end

@implementation BLEMaDaCell

- (void)setupUI {
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton addTarget:self action:@selector(bledone) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_doneButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    self.valueButtons = [NSMutableArray array];
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEMaDaItem class]]) {
        return;
    }
    
    BLEMaDaItem *item = (BLEMaDaItem *)data;
    self.item = item;
    
    UIView *leftView = self.contentView;
    CGFloat left = 20;
    if (item.canCheck) {
        _doneButton.hidden = NO;
        _doneButton.frame = CGRectMake(0, 0, 50, 50);
        if (item.checked) {
            _doneButton.tintColor = RGBCOLOR(152, 217, 77);
        } else {
            _doneButton.tintColor = RGBCOLOR(167, 167, 167);
        }
        [_doneButton setImage:[[UIImage imageNamed:@"done"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        leftView = _doneButton;
        left = 0;
    } else {
        _doneButton.hidden = YES;
    }
    
    CGFloat width = [item.title getWidthWithFont:_titleLabel.font height:20] + 4;
    _titleLabel.text = item.title;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (leftView == self.contentView) {
            make.left.mas_equalTo(leftView).offset(left);
        } else {
            make.left.mas_equalTo(leftView.mas_right).offset(left);
        }
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20);
    }];
    
    if (_valueButtons.count == 0) {
        CGFloat left = 10.f;
        for (NSInteger i = 0; i < item.values.count; i++) {
            NSDictionary *dict = [item.values safeObjectAtIndex:i];
            NSString *title = [dict stringAtPath:@"title"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            button.layer.cornerRadius = 10.f;
            button.layer.borderColor = BLE_TITLE_COLOR.CGColor;
            button.layer.borderWidth = 1.f;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:BLE_TITLE_COLOR forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bleAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 10000;
            [self.contentView addSubview:button];
            [_valueButtons addObject:button];
            
            CGFloat width = [title getWidthWithFont:button.titleLabel.font height:15] + 20;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleLabel.mas_right).offset(left);
                make.centerY.mas_equalTo(self.contentView);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(30);
            }];
            left += width + 10;
        }
    }
    [self setNeedsLayout];
}

- (void)bledone {
    _item.checked = !_item.checked;
    if (_delegate && [_delegate respondsToSelector:@selector(hasDoneAction)]) {
        [_delegate hasDoneAction];
    }
}

- (void)bleAction:(UIButton *)button {
    _item.value = button.tag - 10000;
    if (_delegate && [_delegate respondsToSelector:@selector(madaAction:)]) {
        [_delegate madaAction:_item];
    }
}

@end
