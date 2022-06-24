//
//  Helper.h
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 22/06/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

+ (void)showLoadingIndicator:(UIView *_Nullable)containerView;

+ (void)dismissLoadingIndicator;

+ (void)progressIndicator:(CGFloat)progress withMsg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
