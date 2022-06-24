//
//  DoubleAuthTutorialCell.m
//  CALS
//
//  Created by Tiara Mahardika on 08/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "DoubleAuthTutorialCell.h"
#import "QSDefine.h"
#import "QaaS.h"

@interface DoubleAuthTutorialCell ()
{
    ASImageNode *_iconNode;
}

@end

@implementation DoubleAuthTutorialCell

- (instancetype)initWithImageName:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        [self commonInit];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.automaticallyManagesSubnodes = YES;    
}
- (void)didLoad {
    [super didLoad];
}

- (void)layout {
    [super layout];
    self.iconNode.image = [UIImage imageNamed:self.title];
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:self.iconNode];
    return insetSpec;
}


- (ASImageNode *)iconNode {
    if (!_iconNode) {
        _iconNode = [ASImageNode new];
//        _iconNode.style.flexGrow = 1.0;
        _iconNode.clipsToBounds = YES;
        _iconNode.contentMode = UIViewContentModeScaleAspectFill;
        _iconNode.backgroundColor = [UIColor superLightGray];
    }
    return _iconNode;
}

@end
