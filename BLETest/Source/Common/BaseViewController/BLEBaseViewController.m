//
//  BLEBaseViewController.m
//  BLETest
//
//  Created by Allan Liu on 16/9/24.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLEBaseViewController.h"
#import "BLENavigationController.h"

@interface BLEBaseViewController ()

@end

@implementation BLEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(16,132,205);
    UIImage *image = [UIImage imageNamed:@"BluetoothLogo"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    self.navigationItem.titleView = imageView;
    
    
    _wirelessImageView = [UILabel new];
    _wirelessImageView.text = @"Wireless by DGC";
    _wirelessImageView.textColor = RGBCOLOR(39, 35, 36);
    _wirelessImageView.font = [UIFont systemFontOfSize:14];
    _wirelessImageView.textAlignment = NSTextAlignmentCenter;
    //_wirelessImageView.image = ImageNamed(@"BackgroundTitle");
    [self.view addSubview:_wirelessImageView];
    [_wirelessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(self.view).offset(-10);
    }];
}

- (BLENoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [BLENoDataView new];
        _noDataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 84-64);
        [self.view addSubview:_noDataView];
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToNextViewController:(NSString *)className
                     trasnType:(BLEViewControllerTransType)transType
                        params:(NSDictionary *)params {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (params.count > 0) {
        [dic addEntriesFromDictionary:params];
    }
    BLEBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    if (vc && [vc isKindOfClass:[BLEBaseViewController class]]) {
        vc.startParams = params;
        if (BLEViewControllerTransPush == transType) {
            [self.navigationController pushViewController:vc animated:YES];
        } else if (BLEViewControllerTransPresentAndPush == transType){            
            BLENavigationController *nav = [[BLENavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }
}

@end
