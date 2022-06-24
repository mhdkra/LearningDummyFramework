//
//  CalsplatzSDK.h
//  CalsplatzSDK
//
//  Created by Tiara Mahardika on 03/06/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <AsyncDisplayKit/AsyncDisplayKit.h>

//! Project version number for CalsplatzSDK.
FOUNDATION_EXPORT double CalsplatzSDKVersionNumber;

//! Project version string for CalsplatzSDK.
FOUNDATION_EXPORT const unsigned char CalsplatzSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CalsSDK/PublicHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalsplatzSDK : NSObject
+ (NSString *)getCurrentServerPrefix;

+ (NSArray *)getServerPrefixList;

+ (void)setServerPrefix:(NSString*)serverPrefix;

+ (NSString *)getCurrentApplicationId;

+ (void)setApplicationId:(NSString *)applicationId;

+ (void)setAutoLoginEnabled:(BOOL)autoLogin;


#pragma mark - Auth

+ (NSString *)getCurrentUserID;

+ (NSString *)getCurrentUserPassword;

+ (BOOL)savedAutoLoginEnabled;

+ (void)loadLoginPreferenceWithCompletionBlock:(void(^)(NSDictionary *preference))completionBlock failureBlock:(void(^)(NSError *error))failureBlock;

+ (void)forgotPasswordWithEmail:(NSString *)email completionBlock:(void(^)(NSDictionary *dictionary))completionBlock failureBlock:(void(^)(NSError *error))failureBlock;

+ (void)changePasswordWithOldPassword:(NSString *)oldPassword Password:(NSString *)password confirmPassword:(NSString *)confirmPassword completionBlock:(void(^)(NSDictionary *dictionary))completionBlock failureBlock:(void(^)(NSError *error))failureBlock;

+ (void)loginWithUserID:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin loginVC:(UIViewController *)loginVC failureBlock:(void(^)(NSError *error))failureBlock;
+ (void)logout;

+ (void)setColorTheme:(UIColor *)theme;

+ (void)setColorThemeToDefault;


@end

NS_ASSUME_NONNULL_END
