//
//  IntroViewController.m
//  CALS
//
//  Created by seoungchul bae on 2021/01/07.
//  Copyright © 2021 Quintet Systems. All rights reserved.
//

#import "IntroViewController.h"
#import "QaaS.h"
#import "QSManager.h"
#import "ViewController.h"
#import "LoginNode.h"
#import "BasePopUpViewController.h"
@interface IntroViewController ()<BasePopUpDelegate>

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_group_enter(dispatchGroup);
    [self fetchLoginPreferenctWithCompletionBlock:^{
        dispatch_group_leave(dispatchGroup);
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
        
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        if([QaaS savedAutoLoginEnabled]){
            [self fetchLoginWithUserId:[QaaS savedUserId] withPassword:[QaaS savedPassword] withApplicationId:[QaaS savedApplicationId] withAutoLogin:[QaaS savedAutoLoginEnabled]];
        }else{
            [self toLoginViewController];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

- (void)toLoginViewController {
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.35f;
    
    UIViewController *prevViewController = [[UIViewController alloc] init];
    UIView *prevView = [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] snapshotViewAfterScreenUpdates:NO];
    prevViewController.view = prevView;
    UIWindow *transitionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    transitionWindow.rootViewController = prevViewController;
    [transitionWindow makeKeyAndVisible];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow.layer addAnimation:animation forKey:@"windowTransition"];
    keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] initWithNode:[LoginNode new]]];
    [keyWindow makeKeyAndVisible];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [transitionWindow removeFromSuperview];
    }];
    [CATransaction commit];
}

- (void)fetchLoginPreferenctWithCompletionBlock:(void(^)(void))completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [QSLoadingIndicator showLoadingIndicator:nil];
    });
    [QaaS loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [QSLoadingIndicator dismissLoadingIndicator];
            if (completionBlock) {
                completionBlock();
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [QSLoadingIndicator dismissLoadingIndicator];
            [QSToast showErrorToastWithMessage:error.localizedDescription];
            [self toLoginViewController];
        });
    }];
}

- (void)fetchLoginWithUserId:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];

    __weak typeof(self) weakSelf = self;
    [QaaS loadApplicationById:applicationId completionBlock:^(UIViewController *rootViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf transitionToRootViewController:rootViewController animated:YES];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            
            if(error.code == QSErrorCodeUserNewPassword){
                //비밀번호 변경
                [self pushForgotPassword:@"change"];
            }else{
                if (error){
                    [QSToast showErrorToastWithMessage:error.localizedDescription];
                }
                [self toLoginViewController];
            }
        });
    }];
}

- (void)transitionToRootViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        animation.duration = 0.35f;
        
        UIViewController *prevViewController = [[UIViewController alloc] init];
        UIView *prevView = [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] snapshotViewAfterScreenUpdates:NO];
        prevViewController.view = prevView;
        UIWindow *transitionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        transitionWindow.rootViewController = prevViewController;
        [transitionWindow makeKeyAndVisible];
        
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        [keyWindow.layer addAnimation:animation forKey:@"windowTransition"];
        keyWindow.rootViewController = viewController;
        [keyWindow makeKeyAndVisible];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [transitionWindow removeFromSuperview];
        }];
        [CATransaction commit];
    } else {
        [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    }
}

- (void)pushForgotPassword:(NSString*)type {
    //type : e-mail, change
    [[QSManager shared].navigator pushForgatPasswordViewcontrollerWithType:type animated:YES completionBlock:^(BOOL finished) {
        if(finished){
            //성공
            [self toLoginViewController];
        }
    }];
}
//BasePopUpDelegate
#pragma mark -  BasePopUpDelegate

- (void)confirm:(NSString*)type{

}

- (void)cancel:(NSString*)type{
    
}


@end
