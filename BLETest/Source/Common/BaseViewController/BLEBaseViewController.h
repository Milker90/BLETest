//
//  BLEBaseViewController.h
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLENoDataView.h"

typedef enum {
    BLEViewControllerTransPush = 1,
    BLEViewControllerTransPresent,
    BLEViewControllerTransPresentAndPush, //presnet进入，下个界面还能push
}BLEViewControllerTransType;

@interface BLEBaseViewController : UIViewController

@property (nonatomic, strong) NSDictionary *startParams;

@property (nonatomic, strong) BLENoDataView *noDataView;
@property (nonatomic, strong) UILabel *wirelessImageView;

- (void)goToNextViewController:(NSString *)className
                     trasnType:(BLEViewControllerTransType)transType
                        params:(NSDictionary *)params;

@end
