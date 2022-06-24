//
//  ServerViewController.h
//  CALS
//
//  Created by seoungchul bae on 2020/08/24.
//  Copyright © 2020 Quintet Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ServerViewController : ASViewController
@property (copy, nonatomic) void(^completionBlock)(void);
@end

@interface ServerCell : ASCellNode
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
