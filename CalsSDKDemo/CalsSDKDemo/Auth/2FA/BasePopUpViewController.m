//
//  BasePopUpViewController.m
//  CALS
//
//  Created by Tiara Mahardika on 20/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "BasePopUpViewController.h"
#import "QaaS.h"
#import "QSDefine.h"
#import "vQSText.h"
#import "vQSPassword.h"
#import "vQSButton.h"
#import "QSPopup.h"

@interface BasePopUpViewController ()
{
    ASButtonNode *_cancelButtonNode;
    ASButtonNode *_confirmButtonNode;
    ASTextNode *_descLabelNode;
    CGFloat _popupHeight;
}
@property (strong, nonatomic) NSString *titleNaV;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *type;
@end

@implementation BasePopUpViewController
- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit:nil];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc  type:(NSString*)type {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        self.titleNaV = title;
        self.desc = desc;
        self.type = type;
        [self commonInit:nil];
    }
    return self;
}

- (void)commonInit:(NSString*)type {
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    _popupHeight = 165;
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        
        NSArray *children = @[weakSelf.descLabelNode];
        
        ASStackLayoutSpec *spac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:children];
        ASInsetLayoutSpec *insetSpac = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 25, 0, 25) child:spac];
        
        ASStackLayoutSpec *buttonSpac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[ weakSelf.confirmButtonNode, weakSelf.cancelButtonNode]];
        
        ASStackLayoutSpec *addButtonsSpac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:18 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[insetSpac, buttonSpac]];
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(25, 20, 20, 20) child:addButtonsSpac];
    };
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _titleNaV;
        
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBar.tintColor = [UIColor black];
    self.view.backgroundColor = [UIColor white];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [QSPopup relayout:self.node size:CGSizeMake(0, _popupHeight)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [self closeBarButtonItem];
}

- (UIBarButtonItem *)closeBarButtonItem {
    UIImage *icon = [[QSIcon iconWithName:@"fa-times" style:FontAwesomeObjCStyleSolid color:[UIColor darkGray] size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(cancel)];
    return barButtonItem;
}

- (ASTextNode *)descLabelNode {
    if (!_descLabelNode) {
        _descLabelNode = [ASTextNode new];
        _descLabelNode.style.flexGrow = 1.0;
        _descLabelNode.style.flexShrink = 1.0;
        _descLabelNode.style.width = ASDimensionMakeWithFraction(1.0);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _descLabelNode.attributedText = [[NSAttributedString alloc] initWithString:self.desc attributes:@{NSFontAttributeName:[UIFont regularFontWithSize:15],NSForegroundColorAttributeName:[UIColor black], NSParagraphStyleAttributeName : paragraphStyle}];
        
        }
    return _descLabelNode;
}


- (ASButtonNode *)confirmButtonNode {
    if (!_confirmButtonNode) {
        _confirmButtonNode = [[ASButtonNode alloc] init];
        _confirmButtonNode.style.flexGrow = 1.0;
        _confirmButtonNode.style.height = ASDimensionMakeWithPoints(40);
        _confirmButtonNode.style.spacingBefore = 5.0;
        _confirmButtonNode.backgroundColor = [UIColor mainBlue];
        _confirmButtonNode.clipsToBounds = YES;
        _confirmButtonNode.cornerRadius = 4;
        [_confirmButtonNode setTitle:NSLocalizedString(@"QSM_0067", @"OK") withFont:[UIFont mediumFontWithSize:18.0] withColor:[UIColor white] forState:UIControlStateNormal];
        [_confirmButtonNode addTarget:self action:@selector(confirmButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _confirmButtonNode;
}

- (ASButtonNode *)cancelButtonNode {
    if (!_cancelButtonNode) {
        _cancelButtonNode = [[ASButtonNode alloc] init];
        _cancelButtonNode.style.flexGrow = 1.0;
        _cancelButtonNode.style.height = ASDimensionMakeWithPoints(40);
        _cancelButtonNode.style.spacingBefore = 5.0;
        _cancelButtonNode.backgroundColor = [UIColor white];
        _cancelButtonNode.clipsToBounds = YES;
        _cancelButtonNode.cornerRadius = 4;
        _cancelButtonNode.layer.borderColor = [UIColor blurGray].CGColor;
        _cancelButtonNode.layer.borderWidth = 1;
        
        [_cancelButtonNode setTitle:NSLocalizedString(@"QSM_0040", @"Cancel") withFont:[UIFont mediumFontWithSize:18.0] withColor:[UIColor darkGray] forState:UIControlStateNormal];
        [_cancelButtonNode addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _cancelButtonNode;
}

- (void)cancel{
    __weak typeof(self) weakSelf = self;
    weakSelf.completionBlock(NO);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)cancelButtonDidPress:(ASButtonNode *)button {
    [self cancel];
    [self.delegate cancel: _type];
}
- (void)confirmButtonDidPress:(ASButtonNode *)button {
    __weak typeof(self) weakSelf = self;
    weakSelf.completionBlock(YES);
    [self.delegate confirm:_type];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
