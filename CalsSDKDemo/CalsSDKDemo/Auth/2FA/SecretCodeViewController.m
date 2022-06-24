//
//  SecretCodeViewController.m
//  CALS
//
//  Created by Tiara Mahardika on 07/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "SecretCodeViewController.h"
#import "QaaS.h"
#import "QSManager.h"
#import "vQSText.h"
#import "QSDefine.h"

#import "CopiedCodeViewController.h"
#import "QSPopup.h"
#import "OTPViewController.h"
#import "DoubleAuthTutorialCell.h"

@interface SecretCodeViewController ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource>{
    ASDisplayNode *_lineView;
    ASButtonNode *_copySecretButton;
    ASButtonNode *_confirmButton;
    ASButtonNode *_guideButton;
    ASTextNode *_titleLabelNode;
    ASTextNode *_descLabelNode;
    ASImageNode *_imageNode;
    ASDisplayNode *_collectionBGNode;
    ASDisplayNode *_fieldBgNode;
    ASDisplayNode *_pageControl;
    BOOL *show;
}
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *secretCode;
@property (nonatomic, assign) BOOL hideGuide;
@end

@implementation SecretCodeViewController

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSecretCode:(NSString*)secretCode{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        self.secretCode = secretCode;
        _hideGuide = YES;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSArray *dataImage = [NSArray arrayWithObjects:@"slide_guide_1.png",@"slide_guide_2.png",@"slide_guide_3.png",@"slide_guide_4.png",@"slide_guide_5.png", nil];
    self.data = [dataImage copy];
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = [weakSelf layoutBlock];
    
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupView];
    [self setupNavigationBar];
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setupNavigationBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor white];
    self.navigationController.navigationBar.barTintColor = [UIColor white];;
    
    if (@available(iOS 15, *)){
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = self.navigationController.navigationBar.barTintColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

#pragma mark - UI SETUP

- (void)setupView {
    //back button
    UIImage *icon = [[QSIcon iconWithName:@"fa-chevron-left" style:FontAwesomeObjCStyleSolid color:[UIColor darkGray] size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidPress:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //title
    self.title  = @"2nd Self Authentication";
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.view.backgroundColor = [UIColor white];
    
}

- (ASLayoutSpecBlock)layoutBlock {
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexGrow = 1.0;
    spacer.style.flexShrink = 1.0;
    
    // overide here to add subviews...
    __weak typeof(self) weakSelf = self;
    return ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        
        NSArray *childrenCopy = @[weakSelf.copySecretButton];
        ASStackLayoutSpec *childrenCopySpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:childrenCopy];
        ASInsetLayoutSpec *childrenCopySpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(25, 80, 0, 80) child:childrenCopySpec];
        
        NSArray *children1 = @[weakSelf.titleLabelNode,weakSelf.imageNode ,weakSelf.descLabelNode, childrenCopySpecInset];
        ASStackLayoutSpec *children1Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children1];
        
        ASInsetLayoutSpec *children1SpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:children1Spec];
        
        NSArray *guideChildren = weakSelf.hideGuide == YES ? @[weakSelf.guideButton] : @[(weakSelf.guideButton), weakSelf.collectionNode, weakSelf.pageControl];
        ASStackLayoutSpec *guideStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:guideChildren];
        ASInsetLayoutSpec *guideStack = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:guideStackSpec];
        ASBackgroundLayoutSpec *backgroundSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:guideStack background:weakSelf.collectionBGNode];
  
        
        NSArray *children2 = @[ backgroundSpec, weakSelf.confirmButton];
        ASStackLayoutSpec *headerSpec2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:children2];
        
        ASInsetLayoutSpec *headerSpec2Inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, self.node.safeAreaInsets.left + 20, self.node.safeAreaInsets.bottom + 20, self.node.safeAreaInsets.right + 20)  child:headerSpec2];
        
        NSArray *children = @[weakSelf.lineView, children1SpecInset];
        ASStackLayoutSpec *headerSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:80 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:children];
        
        ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.node.safeAreaInsets.top, self.node.safeAreaInsets.left + 20, self.node.safeAreaInsets.bottom + 20, self.node.safeAreaInsets.right + 20)  child:headerSpec];
        
        return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:insetSpec overlay:headerSpec2Inset];
    };
}

- (ASDisplayNode *)fieldBgNode {
    if(!_fieldBgNode){
        _fieldBgNode = [ASDisplayNode new];
        _fieldBgNode.automaticallyManagesSubnodes = YES;
        _fieldBgNode.backgroundColor = [UIColor white];
        _fieldBgNode.style.width = ASDimensionMakeWithFraction(1.0);
    }
    return _fieldBgNode;
}

- (ASDisplayNode *)lineView {
    if(!_lineView){
        _lineView = [ASDisplayNode new];
        _lineView.automaticallyManagesSubnodes = YES;
        _lineView.backgroundColor = [UIColor blurGray];
        _lineView.style.height = ASDimensionMakeWithPoints(2);
    }
    return _lineView;
}

- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [ASImageNode new];
        _imageNode.image = [UIImage imageNamed:@"ic-qr-phone"];
        _imageNode.contentMode = UIViewContentModeCenter;
        _imageNode.style.spacingAfter = 30;
        _imageNode.style.height = ASDimensionMakeWithPoints(120);
        
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
        _descLabelNode.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0061", @"It is a double security system. To login, You must additional verify.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:14],NSForegroundColorAttributeName:[UIColor black], NSParagraphStyleAttributeName : paragraphStyle}];
    }
    return _descLabelNode;
}

- (ASTextNode *)titleLabelNode {
    if (!_titleLabelNode) {
        _titleLabelNode = [ASTextNode new];
        _titleLabelNode.style.flexGrow = 1.0;
        _titleLabelNode.style.flexShrink = 1.0;
        _titleLabelNode.style.width = ASDimensionMakeWithFraction(1.0);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _titleLabelNode.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0060", @"What is Second Verification?") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Bold" size:18],NSForegroundColorAttributeName:[UIColor darkGray], NSParagraphStyleAttributeName : paragraphStyle}];
        
    }
    return _titleLabelNode;
}

- (ASButtonNode *)copySecretButton {
    if (!_copySecretButton) {
        _copySecretButton = [[ASButtonNode alloc] init];
        _copySecretButton.style.height = ASDimensionMakeWithPoints(34);
        _copySecretButton.cornerRadius = 4.0;
        _copySecretButton.style.spacingBefore = 5.0;
        _copySecretButton.backgroundColor = [UIColor mainOrange];
        _copySecretButton.clipsToBounds = YES;
        [_copySecretButton setTitle:NSLocalizedString(@"QSM_0059", @"Copy verification code") withFont:[UIFont fontWithName:@"NotoSans-Regular" size:15] withColor:[UIColor white] forState:UIControlStateNormal];
        [_copySecretButton addTarget:self action:@selector(secretButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _copySecretButton;
}

- (ASButtonNode *)guideButton {
    if (!_guideButton) {
        _guideButton = [[ASButtonNode alloc] init];
        _guideButton.style.height = ASDimensionMakeWithPoints(40);
        _guideButton.style.spacingBefore = 5.0;
        _guideButton.cornerRadius = 4.0;
        _guideButton.backgroundColor = [UIColor superLightGray];
        _guideButton.clipsToBounds = YES;
        [_guideButton setTitle:NSLocalizedString(@"QSM_0066", @"Google Authenticator install guide") withFont:[UIFont fontWithName:@"NotoSans-Regular" size:15] withColor:[UIColor darkGray] forState:UIControlStateNormal];
        _guideButton.imageAlignment = ASButtonNodeImageAlignmentEnd;
        [_guideButton addTarget:self action:@selector(guideButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
        [_guideButton setImage:[QSIcon iconWithName:@"fa-angle-down" style:FontAwesomeObjCStyleSolid color:[UIColor black80] size:CGSizeMake(20, 20)] forState: UIControlStateNormal];
        [_guideButton setImage:[QSIcon iconWithName:@"fa-angle-up" style:FontAwesomeObjCStyleSolid color:[UIColor black80] size:CGSizeMake(20, 20)] forState: UIControlStateSelected];
        
    }
    return _guideButton;
}

- (ASButtonNode *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[ASButtonNode alloc] init];
        _confirmButton.style.height = ASDimensionMakeWithPoints(50);
        _confirmButton.style.spacingBefore = 5.0;
        _confirmButton.cornerRadius = 4.0;
        _confirmButton.backgroundColor = [UIColor mainBlue];
        _confirmButton.clipsToBounds = YES;
        [_confirmButton setTitle:NSLocalizedString(@"QSM_0024", @"Confirm") withFont:[UIFont fontWithName:@"NotoSans-Medium" size:16] withColor:[UIColor white] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _confirmButton;
}

- (ASCollectionNode *)collectionNode {
    if (!_collectionNode) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.backgroundColor = [UIColor superLightGray];
        _collectionNode.hidden = NO;
        _collectionNode.view.allowsSelection = YES;
        _collectionNode.clipsToBounds = YES;
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
        UIImage *image = [UIImage imageNamed: @"slide_guide_1.png"];
        CGFloat ratio = image.size.width / image.size.height;
        CGFloat newHeight = (UIScreen.mainScreen.bounds.size.width - 40) / ratio;
        _collectionNode.style.height = ASDimensionMakeWithPoints(newHeight);
        _collectionNode.view.pagingEnabled = YES;
        
    }
    return _collectionNode;
}

- (ASDisplayNode *)collectionBGNode {
    if(!_collectionBGNode){
        _collectionBGNode = [ASDisplayNode new];
        _collectionBGNode.automaticallyManagesSubnodes = YES;
        _collectionBGNode.backgroundColor = [UIColor superLightGray];
        //        _fieldBgNode.clipsToBounds = YES;
        _collectionBGNode.cornerRadius = 9;
        _collectionBGNode.shadowColor = [UIColor black].CGColor;
        _collectionBGNode.shadowRadius = 1;
        _collectionBGNode.shadowOffset = CGSizeMake(0, 1);
        _collectionBGNode.shadowOpacity = 0.2;
        _collectionBGNode.style.width = ASDimensionMakeWithFraction(1.0);
        _collectionBGNode.clipsToBounds = YES;
        //_collectionBGNode.style.flexGrow = 1.0;
    }
    return _collectionBGNode;
}

- (ASDisplayNode *)pageControl {
    if(!_pageControl){
        _pageControl = [[ASDisplayNode alloc] initWithViewBlock:^{
            UIPageControl *view  = [[UIPageControl alloc] init] ;
            view.numberOfPages = 5;
            view.currentPage = 0;
            view.currentPageIndicatorTintColor = [UIColor mainBlue];
            view.backgroundColor = [UIColor superLightGray];
            return view;
        }];
        _pageControl.style.width = ASDimensionMakeWithFraction(1.0);
        _pageControl.style.height = ASDimensionMakeWithPoints(30);
        _pageControl.hidden = NO;
        //_pageControl.style.flexGrow = 1.0;
    }
    return _pageControl;
}

- (void)pushCopyNotify{
    [[QSManager shared].navigator pushCopiedSecretCodePopUp:YES completionBlock:^(BOOL finished) {
        
    }];
}

#pragma mark - BUTTON ACTION

- (void)backButtonDidPress:(ASButtonNode *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonDidPress:(ASButtonNode *)button {
    OTPViewController *vc = [[OTPViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)secretButtonDidPress:(ASButtonNode *)button {
    //secretcode 복사
    [UIPasteboard generalPasteboard].string = _secretCode;
    [self pushCopyNotify];
}

- (void)guideButtonDidPress:(ASButtonNode *)button {
    _guideButton.selected = !_guideButton.selected;
    _hideGuide = !_hideGuide;
    self.node.layoutSpecBlock = [self layoutBlock];
    __weak typeof(self) weakSelf = self;
    [weakSelf.node setNeedsLayout];
    [weakSelf.node layoutIfNeeded];
}


- (void)cancelButtonDidPress {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.data objectAtIndex:indexPath.row];
    return ^{
        DoubleAuthTutorialCell *cellNode = [[DoubleAuthTutorialCell alloc] initWithImageName:obj];
        cellNode.style.width = ASDimensionMakeWithPoints(collectionNode.calculatedSize.width);
        return cellNode;
    };
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willDisplayItemWithNode:(ASCellNode *)node{
    if ([self.pageControl.view isKindOfClass:[UIPageControl class]])
    {
        UIPageControl *item = (UIPageControl *)_pageControl.view;
        item.currentPage = node.indexPath.row;
    }
    
}

@end
