//
//  AppDelegate.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 09/06/22.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "Helper.h"
//#import "CalsplatzSDK.h"
#import <CalsplatzSDK/CalsplatzSDK.h>
@interface AppDelegate (){
}

@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootViewController  = [LoginVC new];
    self.viewController = rootViewController;
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_group_enter(dispatchGroup);
    [self fetchLoginPreferenctWithCompletionBlock:^{
        dispatch_group_leave(dispatchGroup);
    }];
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        if([CalsplatzSDK savedAutoLoginEnabled]){
            [CalsplatzSDK loginWithUserID:[CalsplatzSDK getCurrentUserID] withPassword:[CalsplatzSDK getCurrentUserPassword] withApplicationId:[CalsplatzSDK getCurrentApplicationId] withAutoLogin:[CalsplatzSDK savedAutoLoginEnabled] loginVC:weakSelf.viewController failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }];
        }else{
            [weakSelf toLoginViewController];
        }
    });
    
    return YES;
}

- (void)fetchLoginPreferenctWithCompletionBlock:(void(^)(void))completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Helper showLoadingIndicator:nil];
    });
    [CalsplatzSDK loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Helper dismissLoadingIndicator];
            if (completionBlock) {
                completionBlock();
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Helper dismissLoadingIndicator];
            [weakSelf toLoginViewController];
        });
    }];
}

- (void)toLoginViewController{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    if (@available(iOS 13.0, *)) {
        return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    } else {
        // Fallback on earlier versions
    }
    return [UISceneConfiguration new];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
