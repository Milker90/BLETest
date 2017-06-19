//
//  BLEDISCell.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEDISCell.h"
#import "BLECustomButton.h"
#import "BLETitleContentView.h"

@interface BLEDISCell ()

@property (nonatomic, weak) BLEDISItem *item;

@property (nonatomic, strong) BLETitleContentView *titleContentView;
@property (nonatomic, strong) BLECustomButton *autoButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIImage *autoImage;
@property (nonatomic, strong) UIImage *unautoImage;

@end

@implementation BLEDISCell

- (void)setupUI {
    _titleContentView = [BLETitleContentView new];
    _titleContentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleContentView];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton addTarget:self action:@selector(bledone) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_doneButton];
    
    _autoButton = [BLECustomButton new];
    [_autoButton addTarget:self action:@selector(bleselect) forControlEvents:UIControlEventTouchUpInside];
    _autoButton.titleLabel.text = NSLocalizedString(@"Auto", nil);
    _autoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _autoButton.imageView.tintColor = [UIColor grayColor];
    [self.contentView addSubview:_autoButton];
    [_autoButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_autoButton).offset(5);
        make.centerY.mas_equalTo(_autoButton);
        make.size.mas_equalTo(CGSizeMake(50, 18));
    }];
    
    [_autoButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_autoButton).offset(-5);
        make.centerY.mas_equalTo(_autoButton);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    self.autoImage = [[UIImage imageNamed:@"btn_auto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.unautoImage = [[UIImage imageNamed:@"btn_unauto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[BLEDISItem class]]) {
        return;
    }
    
    BLEDISItem *item = (BLEDISItem *)data;
    self.item = item;
    
    UIView *leftView = self.contentView;
    CGFloat left = 20;
    if (item.canCheck) {
        _doneButton.hidden = NO;
       // _doneButton.backgroundColor = [UIColor redColor];
        _doneButton.frame = CGRectMake(0, 0, 50, 50);
        if (item.checked) {
            _doneButton.tintColor = RGBCOLOR(152, 217, 77);
        } else {
            _doneButton.tintColor = RGBCOLOR(167, 167, 167);
        }
        [_doneButton setImage:[[UIImage imageNamed:@"done"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        leftView = _doneButton;
        left = 50;
    } else {
        _doneButton.hidden = YES;
    }
    
    UIView *rightView = self.contentView;
    CGFloat right = 15;
    _autoButton.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 65, 30);
    if (item.canAuto) {
        _autoButton.hidden = NO;
        
        if (item.autoed) {
            _autoButton.imageView.image = _autoImage;
        } else {
            _autoButton.imageView.image = _unautoImage;
        }
        
        rightView = _autoButton;
        right = 85;
    } else {
        _autoButton.hidden = YES;
    }
    
    _titleContentView.frame = CGRectMake(left, 10, SCREEN_WIDTH - left - right, 30);
    [_titleContentView updateUI:item];
}

- (void)bledone {
    _item.checked = !_item.checked;
    if (_delegate && [_delegate respondsToSelector:@selector(hasDoneAction)]) {
        [_delegate hasDoneAction];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)bleselect {
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    return v;
}

@end
