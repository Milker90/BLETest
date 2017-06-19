//
//  BLENoDataView.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLENoDataView.h"

@interface BLENoDataView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation BLENoDataView

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = BLE_TITLE_COLOR;
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
}

- (void)updateUI:(id)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)data;
    _imageView.image = ImageNamed([dict stringAtPath:@"icon"]);
    _nameLabel.text = [dict stringAtPath:@"title"];
    CGSize size = _imageView.image.size;
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY).offset(-40);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(size);
    }];
    
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
    }];
}

@end
