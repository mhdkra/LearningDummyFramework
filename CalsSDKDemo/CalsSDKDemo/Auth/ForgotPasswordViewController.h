//
//  ForgotPasswordViewController.h
//  CALS
//
//  Created by seoungchul bae on 2020/10/12.
//  Copyright © 2020 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgotPasswordViewController : ASViewController
@property (copy, nonatomic) void(^completionBlock)(BOOL);

- (instancetype)initWithDisplayType:(NSString*)type;
@end

NS_ASSUME_NONNULL_END
