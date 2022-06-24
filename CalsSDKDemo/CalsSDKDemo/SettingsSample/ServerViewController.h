//
//  ServerViewController.h
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 09/06/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerViewController : UIViewController
@property (copy, nonatomic) void(^completionBlock)(void);
@end

NS_ASSUME_NONNULL_END
