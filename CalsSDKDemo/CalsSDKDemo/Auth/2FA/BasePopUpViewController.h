//
//  BasePopUpViewController.h
//  CALS
//
//  Created by Tiara Mahardika on 20/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BasePopUpDelegate
- (void)confirm:(NSString*)type;
- (void)cancel:(NSString*)type;
@end

@interface BasePopUpViewController : ASViewController
@property (nonatomic, weak) id delegate;
@property (copy, nonatomic) void(^completionBlock)(BOOL);
- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc type:(NSString*)type;
@end


NS_ASSUME_NONNULL_END
