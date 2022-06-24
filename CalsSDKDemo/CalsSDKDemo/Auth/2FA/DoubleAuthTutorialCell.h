//
//  DoubleAuthTutorialCell.h
//  CALS
//
//  Created by Tiara Mahardika on 08/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoubleAuthTutorialCell : ASCellNode
- (instancetype)initWithImageName:(NSString *)title;
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
