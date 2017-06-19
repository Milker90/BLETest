//
//  BLECustomButton.h
//  BLETest
//
//  Created by Allan Liu on 16/9/28.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLECustomButton : UIControl

/**
 *  highlighted为yes时的背景颜色
 */
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

/**
 *  selected为yes时的背景颜色
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  按钮的图片
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  正常的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  按钮的背景图片
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 *  设置title
 *
 *  @param title
 */
- (void)setTitle:(NSString *)title;

/**
 *  配置UI
 */
- (void)setupUI;

/**
 *  扩展响应范围
 */
@property (nonatomic, assign) UIEdgeInsets extendedRange;

/**
 *  延迟响应时间
 */
@property (nonatomic, assign) CGFloat delayResponseTime;

@end
