//
//  ServerViewController.m
//  CALS
//
//  Created by seoungchul bae on 2020/08/24.
//  Copyright © 2020 Quintet Systems. All rights reserved.
//

#import "ServerViewController.h"
#import "QaaS.h"
#import "QSDefine.h"
#import "CALSSDK.h"

@interface ServerViewController() <ASCollectionDataSource, ASCollectionDelegate>
@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) NSArray *data;
@end

@implementation ServerViewController

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:weakSelf.collectionNode];
    };
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"QSM_0007", @"Setting service");
    
    if (@available(iOS 10.0, *)) self.collectionNode.view.prefetchingEnabled = NO;
    self.collectionNode.view.alwaysBounceVertical = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.view.backgroundColor = [UIColor whiteTow];
    
    self.collectionNode.automaticallyManagesSubnodes = YES;
    self.collectionNode.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.collectionNode.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    UIImage *icon = [[QSIcon iconWithName:@"fa-chevron-left" style:FontAwesomeObjCStyleSolid color:[UIColor white] size:CGSizeMake(18, 18)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidPress:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor cerulean];
    self.navigationController.navigationBar.barTintColor = [UIColor cerulean];
    
    if (@available(iOS 15, *)){
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = self.navigationController.navigationBar.barTintColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
    [super viewWillAppear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionNode relayoutItems];
}
- (ASCollectionNode *)collectionNode {
    if (!_collectionNode) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 1.0;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.backgroundColor = [UIColor clearColor];
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
    }
    return _collectionNode;
}

- (NSArray *)data {
    if (!_data) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *serverList = CALS_SERVER_PREFIXS;
        for (NSDictionary *dic in serverList){
            NSDictionary *dataDic = @{
                                      @"title"  :   dic[@"label"],
                                      @"value"  :   dic[@"value"]
                                    };
            [dataArray addObject:dataDic];
        }
        _data = [NSArray arrayWithArray:dataArray];
    }
    return _data;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [self.data objectAtIndex:indexPath.row];
    return ^{
        ServerCell *cellNode = [[ServerCell alloc] initWithDictionary:dictionary];
        return cellNode;
    };
}
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    NSString *selectedServerPrefix = CALS_SERVER_PREFIXS[index][@"value"];
    [CALSSDK setServerPrefix:selectedServerPrefix];
    __weak typeof(self) weakSelf = self;
    [self fetchLoginPreferenctWithCompletionBlock:^{
        [weakSelf backButtonDidPress:nil];
        if(weakSelf.completionBlock)
            weakSelf.completionBlock();
    }];
}

- (void)backButtonDidPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchLoginPreferenctWithCompletionBlock:(void(^)(void))completionBlock {
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [QSLoadingIndicator showLoadingIndicator:nil];
    });
    [CALSSDK loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            if (completionBlock) {
                completionBlock();
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            [QSToast showErrorToastWithMessage:error.localizedDescription];
        });
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

@end


@interface ServerCell ()
{
    ASTextNode *_titleNode;
    ASImageNode *_selectedNode;
    ASImageNode *_iconNode;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end

@implementation ServerCell

- (instancetype)init {
    if (self = [self initWithDictionary:@{}]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = dictionary[@"title"] ?: @"";
        self.value = dictionary[@"value"] ?: @"";
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.automaticallyManagesSubnodes = YES;
    self.style.minHeight = ASDimensionMakeWithPoints(65);
    self.style.width = ASDimensionMakeWithFraction(1.0);
    self.backgroundColor = [UIColor white];
}

- (ASTextNode *)titleNode {
    if (!_titleNode) {
        _titleNode = [ASTextNode new];
    }
    return _titleNode;
}
- (ASImageNode *)selectedNode {
    if (!_selectedNode) {
        _selectedNode = [ASImageNode new];
    }
    return _selectedNode;
}
- (ASImageNode *)iconNode {
    if (!_iconNode) {
        _iconNode = [ASImageNode new];
    }
    return _iconNode;
}

- (void)didLoad {
    [super didLoad];
    
    self.titleNode.attributedText = [QSBaseStyle formText01:self.title];
    self.iconNode.image = [QSIcon iconWithName:@"fa-angle-right" style:FontAwesomeObjCStyleSolid color:[UIColor black80] size:CGSizeMake(20, 20)];
}

- (void)layout {
    [super layout];
    
    if([[CALSSDK getCurrentServerPrefix] isEqualToString:self.value]){
        self.selectedNode.image = [QSIcon iconWithName:@"fa-circle" style:FontAwesomeObjCStyleSolid color:[UIColor cerulean] size:CGSizeMake(10, 10)];
    }else{
        self.selectedNode.image = [QSIcon iconWithName:@"fa-circle" style:FontAwesomeObjCStyleSolid color:[UIColor clearColor] size:CGSizeMake(10, 10)];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexGrow = 1.0;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceAround alignItems:ASStackLayoutAlignItemsCenter children:@[self.titleNode, self.selectedNode, spacer, self.iconNode]];
    contentStack.style.flexGrow = 1.0;
    contentStack.style.minHeight = self.style.minHeight;
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 20, 0, 20) child:contentStack];
    return insetSpec;
}

@end
