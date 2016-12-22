//
//  ViewController.m
//  SureWebViewController
//
//  Created by 刘硕 on 2016/12/13.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "ViewController.h"
#import "SureWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enterWebViewController:(id)sender {
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = @"https://www.baidu.com";
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
