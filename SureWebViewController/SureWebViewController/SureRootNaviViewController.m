//
//  SureRootNaviViewController.m
//  SureWebViewController
//
//  Created by 刘硕 on 2016/12/14.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureRootNaviViewController.h"

@interface SureRootNaviViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SureRootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(gesture:)];
    }
}

- (void)gesture:(UIGestureRecognizer*)ges {
    if ([self.pop_delegate respondsToSelector:@selector(backPopGestureResponse)]) {
        [self.pop_delegate backPopGestureResponse];
    }
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
