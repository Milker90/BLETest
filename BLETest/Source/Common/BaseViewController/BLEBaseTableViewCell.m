//
//  BLEBaseTableViewCell.m
//  Pods
//
//  Created by TommyLiu on 15/6/17.
//
//

#import "BLEBaseTableViewCell.h"

@implementation BLEBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}

- (void)updateUI:(id)data {
    
}

+ (CGFloat)getCellHeightWithData:(id)data {
    return 0.0f;
}

- (UIView *)mBackGroundLayer
{
    if (!_mBackGroundLayer) {
        _mBackGroundLayer = [[UIView alloc] initWithFrame:CGRectZero];
        _mBackGroundLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
    return _mBackGroundLayer;
}

- (UIImageView *)customAccessoryView {
    if (!_customAccessoryView) {
        _customAccessoryView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //_customAccessoryView.image = [RDPImage imageForName:@"accessory_arrow" bundle:@"R360DP"];
        [self.contentView addSubview:_customAccessoryView];
    }
    return _customAccessoryView;
}

- (void)setShowCustomBackgroundLayer:(BOOL)showCustomBackgroundLayer {
    _showCustomBackgroundLayer = showCustomBackgroundLayer;
    if (showCustomBackgroundLayer) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.selectedBackgroundView = self.mBackGroundLayer;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)layoutSubviews {
    //NSLog(@"layoutSubviews");
    [super layoutSubviews];
    
    if (_showCustomBackgroundLayer) {
        [self bringSubviewToFront:self.selectedBackgroundView];
        _mBackGroundLayer.frame = self.bounds;
    }
    
    if (_showCustomAccessoryView) {
        self.customAccessoryView.frame = CGRectMake(self.rdpWidth - 36.0f, (self.rdpHeight - 20)/2, 20, 20);
        self.customAccessoryView.hidden = NO;
    } else {
        _customAccessoryView.frame = CGRectZero;
        _customAccessoryView.hidden = YES;
    }
}

@end
