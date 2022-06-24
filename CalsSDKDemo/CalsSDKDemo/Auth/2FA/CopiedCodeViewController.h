//
//  CopiedCodeViewController.h
//  CALS
//
//  Created by Tiara Mahardika on 08/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CopiedCodeViewController : ASViewController
@property (copy, nonatomic) void(^completionBlock)(BOOL);
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
