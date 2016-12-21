//
//  SureRootNaviViewController.h
//  SureWebViewController
//
//  Created by 刘硕 on 2016/12/14.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackPopGestureDelegate <NSObject>

- (void)backPopGestureResponse;

@end

@interface SureRootNaviViewController : UINavigationController

@property (nonatomic, weak) id<BackPopGestureDelegate>pop_delegate;

@end
