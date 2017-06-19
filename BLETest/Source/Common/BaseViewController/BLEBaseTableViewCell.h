//
//  BLEBaseTableViewCell.h
//  Pods
//
//  Created by TommyLiu on 15/6/17.
//
//

#import <UIKit/UIKit.h>

@interface BLEBaseTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showCustomBackgroundLayer;
@property (nonatomic, strong) UIView *mBackGroundLayer;

@property (nonatomic, assign) BOOL showCustomAccessoryView;
@property (nonatomic, strong) UIImageView *customAccessoryView;

- (void)setupUI;

- (void)updateUI:(id)data;

+ (CGFloat)getCellHeightWithData:(id)data;

@end
