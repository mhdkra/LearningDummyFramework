//
//  OTPViewController.h
//  CALS
//
//  Created by Tiara Mahardika on 09/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef enum{
  Register = 1,
  Verify = 2
}OTPType;

@protocol OTPViewControllerDelegate

- (void)verifyOTP:(NSString *)otpStriing;
- (void)resetOTPWithCompletion:(void(^)(NSString *data))completionBlock
                  failureBlock:(void(^)(NSError *error))failureBlock;
- (void)cancel;

@end

@interface OTPViewController : ASViewController
@property (nonatomic, weak) id delegate;
- (instancetype)initWithType:(OTPType*)otpType;
@end

NS_ASSUME_NONNULL_END
