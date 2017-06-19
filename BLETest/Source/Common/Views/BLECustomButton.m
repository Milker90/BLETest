//
//  BLECustomButton.m
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLECustomButton.h"
#import <objc/message.h>

@interface BLECustomButton()

/**
 *  按钮背景
 */
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) BOOL isDelaing;

@property (nonatomic, weak) id rltarget;
@property (nonatomic, assign) SEL rlaction;

@end

@implementation BLECustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.delayResponseTime = 0.0f;
        [self addTarget:self action:@selector(resetUI) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        //self.highlightedBackgroundColor = HEXACOLOR(0x000000, 0.3);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.frame = self.bounds;
        if (_highlightedBackgroundColor == nil) {
            _backgroundView.backgroundColor = [UIColor clearColor];
        } else {
            _backgroundView.backgroundColor = _highlightedBackgroundColor;
        }
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (self.selectedBackgroundColor) {
        return;
    }
    
    if (highlighted) {
        if (_highlightedBackgroundColor) {
            [self.backgroundView bringSubviewToFront:_backgroundView];
            self.backgroundView.backgroundColor = _highlightedBackgroundColor;
        }
        
        self.imageView.highlighted = YES;
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (controlEvents == UIControlEventTouchUpInside) {
        self.rltarget = target;
        self.rlaction = action;
        [super addTarget:self action:@selector(delayClick) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    
    [super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)delayClick {
    if (_isDelaing) {
        return;
    }
    self.isDelaing = YES;
    __weak typeof(self)weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, _delayResponseTime * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        if (weakSelf.rltarget) {
            if ([weakSelf.rltarget respondsToSelector:weakSelf.rlaction]) {
                weakSelf.backgroundView.backgroundColor = [UIColor clearColor];
                [weakSelf sendSubviewToBack:weakSelf.backgroundView];
                weakSelf.imageView.highlighted = NO;
                ((void (*) (id, SEL, id))objc_msgSend)(weakSelf.rltarget, weakSelf.rlaction, weakSelf);
            }
        }
        weakSelf.isDelaing = NO;
    });
}

- (void)resetUI {
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.imageView.highlighted = NO;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = CGRectMake(self.extendedRange.left, self.extendedRange.top, self.rdpWidth - self.extendedRange.left + self.extendedRange.right, self.rdpHeight - self.extendedRange.top + self.extendedRange.bottom);
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (_backgroundView && _backgroundView == v) {
        return self;
    }
    return v;
}

@end
