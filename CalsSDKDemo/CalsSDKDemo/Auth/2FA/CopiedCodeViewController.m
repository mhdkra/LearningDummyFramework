//
//  CopiedCodeViewController.m
//  CALS
//
//  Created by Tiara Mahardika on 08/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "CopiedCodeViewController.h"
#import "vQSButton.h"
#import "QSPopup.h"
@interface CopiedCodeViewController (){
    vQSButton *_cancelButtonNode;
    ASTextNode *_descLabelNode;
    ASImageNode *_imageNode;
}
@end

@implementation CopiedCodeViewController

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    self.node.backgroundColor = [UIColor white];
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        
        NSArray *children = @[];
        children = @[weakSelf.imageNode, weakSelf.descLabelNode];
        ASStackLayoutSpec *children1Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children];

        ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.node.safeAreaInsets.top +30, self.node.safeAreaInsets.left + 20,INFINITY, self.node.safeAreaInsets.right + 20)  child:children1Spec];
        
        return insetSpec;;
    };
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [self closeBarButtonItem];
}

- (UIBarButtonItem *)closeBarButtonItem {
    UIImage *icon = [[QSIcon iconWithName:@"fa-times" style:FontAwesomeObjCStyleSolid color:[UIColor darkGray] size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(cancelButtonDidPress)];
    return barButtonItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [QSPopup relayout:self.node size:CGSizeMake(0, 200)];
}

- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [ASImageNode new];
        _imageNode.image = [UIImage imageNamed:@"ic-smile-face"];
        _imageNode.contentMode = UIViewContentModeCenter;
        _imageNode.style.spacingAfter = 30;
        _imageNode.style.height = ASDimensionMakeWithPoints(40);
        
    }
    return _imageNode;
}

- (ASTextNode *)descLabelNode {
    if (!_descLabelNode) {
        _descLabelNode = [ASTextNode new];
        _descLabelNode.style.flexGrow = 1.0;
        _descLabelNode.style.flexShrink = 1.0;
        _descLabelNode.style.width = ASDimensionMakeWithFraction(1.0);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _descLabelNode.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0062", @"The verification code is normally copied.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:15],NSForegroundColorAttributeName:[UIColor black], NSParagraphStyleAttributeName : paragraphStyle}];
        
        }
    return _descLabelNode;
}

- (void)cancelButtonDidPress {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
