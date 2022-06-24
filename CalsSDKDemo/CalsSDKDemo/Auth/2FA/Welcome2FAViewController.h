//
//  Welcome2FAViewController.h
//  CALS
//
//  Created by Tiara Mahardika on 31/01/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Welcome2FAViewController : ASViewController
- (instancetype)initWithCognitoUser:(NSString*)secretCode name:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
