//
//  Helper.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 22/06/22.
//

#import "Helper.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation Helper

+ (void)load {
    [SVProgressHUD setRingThickness:6.0];
    [SVProgressHUD setForegroundColor:[UIColor blueColor]];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor darkGrayColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

+ (void)showLoadingIndicator:(UIView *)containerView {
    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD show];
}

+ (void)dismissLoadingIndicator {
    [SVProgressHUD popActivity];
    [SVProgressHUD dismiss];
//    while ([SVProgressHUD sharedView].activityCount) {
//        [SVProgressHUD popActivity];
//    }
}

+ (void)progressIndicator:(CGFloat)progress withMsg:(NSString *)msg {
    [SVProgressHUD showProgress:(float)progress status:msg];
}
@end
