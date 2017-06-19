//
//  BLETTViewController.m
//  BLETest
//
//  Created by Allan Liu on 16/10/1.
//  Copyright © 2016年 GO. All rights reserved.
//

#import "BLETTViewController.h"

@interface BLETTViewController ()

@end

@implementation BLETTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.noDataView updateUI:@{@"title":NSLocalizedString(@"Waiting", nil), @"icon":@"scanning"}];
    [self.view addSubview:self.noDataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
