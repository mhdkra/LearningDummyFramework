//
//  Welcome2FAViewController.m
//  CALS
//
//  Created by Tiara Mahardika on 31/01/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "Welcome2FAViewController.h"
#import "QaaS.h"
#import "QSManager.h"
#import "vQSText.h"
#import "QSDefine.h"
#import "SecretCodeViewController.h"

@interface Welcome2FAViewController (){
    ASButtonNode *_backButton;
    ASButtonNode *_confirmButton;
    ASTextNode *_welcomeLabelNode;
    ASTextNode *_descLabelNode1;
    ASTextNode *_descLabelNode2;
    ASTextNode *_descLabelNode3;
    ASTextNode *_nameLabelNode;
    ASDisplayNode *_lineView;
    ASImageNode *_imageNode;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *secretCode;
@end

@implementation Welcome2FAViewController

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCognitoUser:(NSString*)secretCode name:(NSString *)name  {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
        self.secretCode = secretCode;
        self.name = [name copy];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name  {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
        self.name = [name copy];
    }
    return self;
}

- (void)commonInit {
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = [weakSelf layoutBlock];
    
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupView];
    [self setupNavigationBar];
}

#pragma mark - UI Setup

- (ASLayoutSpecBlock)layoutBlock {
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexGrow = 1.0;
    spacer.style.flexShrink = 1.0;
    
    // overide here to add subviews...
    __weak typeof(self) weakSelf = self;
    return ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        
        NSArray *children1 = @[
                              weakSelf.descLabelNode1,weakSelf.descLabelNode2,weakSelf.descLabelNode3];
        ASStackLayoutSpec *children1Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:1 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children1];
        
        ASInsetLayoutSpec *children1SpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:children1Spec];
        
        NSArray *children2 = @[weakSelf.nameLabelNode,
                               weakSelf.welcomeLabelNode];
        
        ASStackLayoutSpec *children2Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children2];
        
        ASInsetLayoutSpec *children2SpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:children2Spec];
        
        ASStackLayoutSpec *childrenCompileSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[children2SpecInset,children1SpecInset]];
        
        NSArray *children = @[weakSelf.lineView,
                              weakSelf.imageNode,
                              childrenCompileSpec];
        ASStackLayoutSpec *headerSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:50 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:children];
        
        ASStackLayoutSpec *headerSpec2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:100 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[headerSpec,weakSelf.confirmButton]];
        
        ASInsetLayoutSpec *insetSpec2 = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.node.safeAreaInsets.top, self.node.safeAreaInsets.left + 20, self.node.safeAreaInsets.bottom + 20, self.node.safeAreaInsets.right + 20)  child:headerSpec2];
        
        
        return insetSpec2;
    };
}

- (void)setupNavigationBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor mainBlue];
    self.navigationController.navigationBar.barTintColor = [UIColor mainBlue];;
    
    if (@available(iOS 15, *)){
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = self.navigationController.navigationBar.barTintColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

- (void)setupView {
    //back button
    UIImage *icon = [[QSIcon iconWithName:@"fa-chevron-left" style:FontAwesomeObjCStyleSolid color:[UIColor white] size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidPress:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //title
    self.title  = @"2nd Self Authentication";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.view.backgroundColor = [UIColor mainBlue];
}

- (ASDisplayNode *)lineView {
    if(!_lineView){
        _lineView = [ASDisplayNode new];
        _lineView.automaticallyManagesSubnodes = YES;
        _lineView.backgroundColor = [UIColor white];
        _lineView.style.height = ASDimensionMakeWithPoints(2);
    }
    return _lineView;
}

- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [ASImageNode new];
        _imageNode.image = [UIImage imageNamed:@"ic-check"];
        _imageNode.contentMode = UIViewContentModeCenter;
        _imageNode.style.spacingAfter = 30;
        _imageNode.style.height = ASDimensionMakeWithPoints(50);
        _imageNode.style.width = ASDimensionMakeWithPoints(50);
        
    }
    return _imageNode;
}

- (ASTextNode *)nameLabelNode {
    if (!_nameLabelNode) {
        _nameLabelNode = [ASTextNode new];
        _nameLabelNode.style.flexGrow = 1.0;
        _nameLabelNode.style.flexShrink = 1.0;
        _nameLabelNode.style.width = ASDimensionMakeWithFraction(1.0);
        _nameLabelNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,", self.name] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:25],NSForegroundColorAttributeName:[UIColor white]}];
        
    }
    return _nameLabelNode;
}

- (ASTextNode *)welcomeLabelNode {
    if (!_welcomeLabelNode) {
        _welcomeLabelNode = [ASTextNode new];
        _welcomeLabelNode.style.flexGrow = 1.0;
        _welcomeLabelNode.style.flexShrink = 1.0;
        _welcomeLabelNode.style.width = ASDimensionMakeWithFraction(1.0);
        _welcomeLabelNode.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0055",@"WELCOME!") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:25],NSForegroundColorAttributeName:[UIColor white]}];
    }
    return _welcomeLabelNode;
}

- (ASTextNode *)descLabelNode1 {
    if (!_descLabelNode1) {
        _descLabelNode1 = [ASTextNode new];
        _descLabelNode1.style.flexGrow = 1.0;
        _descLabelNode1.style.flexShrink = 1.0;
        _descLabelNode1.style.width = ASDimensionMakeWithFraction(1.0);
        _descLabelNode1.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0056",@"Your login was successful.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:14],NSForegroundColorAttributeName:[UIColor white]}];
    }
    return _descLabelNode1;
}

- (ASTextNode *)descLabelNode2 {
    if (!_descLabelNode2) {
        _descLabelNode2 = [ASTextNode new];
        _descLabelNode2.style.flexGrow = 1.0;
        _descLabelNode2.style.flexShrink = 1.0;
        _descLabelNode2.style.width = ASDimensionMakeWithFraction(1.0);
        _descLabelNode2.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0057",@"A second verification with Google Authenticator is required.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:14],NSForegroundColorAttributeName:[UIColor white]}];
    }
    return _descLabelNode2;
}

- (ASTextNode *)descLabelNode3 {
    if (!_descLabelNode3) {
        _descLabelNode3 = [ASTextNode new];
        _descLabelNode3.style.flexGrow = 1.0;
        _descLabelNode3.style.flexShrink = 1.0;
        _descLabelNode3.style.width = ASDimensionMakeWithFraction(1.0);
        _descLabelNode3.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0058", @"Press confirm to move the second verification screen.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:14],NSForegroundColorAttributeName:[UIColor white]}];
    }
    return _descLabelNode3;
}

- (ASButtonNode *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[ASButtonNode alloc] init];
        _confirmButton.style.height = ASDimensionMakeWithPoints(50);
        _confirmButton.style.spacingBefore = 5.0;
        _confirmButton.layer.cornerRadius = 4.0;
        _confirmButton.backgroundColor = [UIColor white];
        _confirmButton.clipsToBounds = YES;
        [_confirmButton setTitle:NSLocalizedString(@"QSM_0024", @"Confirm") withFont:[UIFont fontWithName:@"NotoSans-Medium.ttf" size:16] withColor:[UIColor mainBlue] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _confirmButton;
}

- (ASButtonNode *)backButton {
    if (!_backButton) {
        _backButton = [[ASButtonNode alloc] init];
        _backButton.style.height = ASDimensionMakeWithPoints(50);
        _backButton.style.spacingBefore = 5.0;
        _backButton.backgroundColor = [UIColor mainBlue];
        _backButton.clipsToBounds = YES;
        [_backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _backButton;
}

- (void)backButtonDidPress:(ASButtonNode *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonDidPress:(ASButtonNode *)button {
    SecretCodeViewController *serverVC = [[SecretCodeViewController alloc] initWithSecretCode:_secretCode];
    [self.navigationController pushViewController:serverVC animated:YES];
}

- (void)cognitoGetSecretCode {
   
}
@end
