//
//  OTPViewController.m
//  CALS
//
//  Created by Tiara Mahardika on 09/02/22.
//  Copyright © 2022 Quintet Systems. All rights reserved.
//

#import "OTPViewController.h"
#import "BasePopUpViewController.h"
#import "QaaS.h"
#import "QSManager.h"
#import "vQSText.h"
#import "QSDefine.h"

#import "CopiedCodeViewController.h"
#import "QSPopup.h"
#import "vQSText.h"

@class QSPINView;
@class PinCodeTextField;


@interface OTPViewController () <PinCodeTextFieldDelegate, NSObject, UIAdaptivePresentationControllerDelegate, BasePopUpDelegate>{
    ASDisplayNode *_lineView;
    ASButtonNode *_resetOTPButton;
    ASButtonNode *_confirmButton;
    ASTextNode *_descLabelNode;
    ASImageNode *_imageNode;
    
    ASDisplayNode *_pinCodeNode;
}
@property (nonatomic) NSString *otpText;
@property (nonatomic) OTPType *otpType;
@end

@implementation OTPViewController

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithType:(OTPType*)otpType{
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        self.otpType = otpType;
        [self commonInit];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pinCodeNode.view becomeFirstResponder];
    });
    if (self.delegate){
        self.presentationController.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupView];
    [self setupNavigationBar];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)setupNavigationBar{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor white]];
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
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                   [UIFont boldSystemFontOfSize:17.0], NSFontAttributeName,nil];
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
        
        NSArray *childrenResetButton = @[weakSelf.resetOTPButton];
        ASStackLayoutSpec *childrenResetButtonSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:childrenResetButton];
        ASInsetLayoutSpec *childrenResetButtonSpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 97, 0, 97) child:childrenResetButtonSpec];
        
        NSArray *children1 = @[weakSelf.imageNode, weakSelf.pinCodeNode ,weakSelf.descLabelNode, childrenResetButtonSpecInset];
        ASStackLayoutSpec *children1Spec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children1];
        
        ASInsetLayoutSpec *children1SpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:children1Spec];
        
        
        NSArray *children = @[weakSelf.lineView,
                              children1SpecInset];
        ASStackLayoutSpec *headerSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:80 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:children];
        
        ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.node.safeAreaInsets.top, self.node.safeAreaInsets.left + 20, self.node.safeAreaInsets.bottom + 20, self.node.safeAreaInsets.right + 20)  child:headerSpec];
        
        ASStackLayoutSpec *confirmSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[weakSelf.confirmButton]];
        ASInsetLayoutSpec *confirmSpecInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, self.node.safeAreaInsets.left + 20, self.node.safeAreaInsets.bottom + 20, self.node.safeAreaInsets.right + 20)  child:confirmSpec];
        
        return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:insetSpec overlay:confirmSpecInset];
    };
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
        _descLabelNode.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0064", @"Please input 6-digit code from Google Authenticator.") attributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSans-Regular" size:14],NSForegroundColorAttributeName:[UIColor black], NSParagraphStyleAttributeName : paragraphStyle}];
    }
    return _descLabelNode;
}

- (ASButtonNode *)resetOTPButton {
    if (!_resetOTPButton) {
        _resetOTPButton = [[ASButtonNode alloc] init];
        _resetOTPButton.style.height = ASDimensionMakeWithPoints(34);
        _resetOTPButton.cornerRadius = 4.0;
        _resetOTPButton.style.spacingBefore = 5.0;
        _resetOTPButton.backgroundColor = [UIColor mainOrange];
        _resetOTPButton.clipsToBounds = YES;
        [_resetOTPButton setTitle:NSLocalizedString(@"QSM_0063", @"Reset OTP") withFont:[UIFont fontWithName:@"NotoSans-Regular" size:15] withColor:[UIColor white] forState:UIControlStateNormal];
        [_resetOTPButton addTarget:self action:@selector(resetOTPDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _resetOTPButton;
}

- (ASButtonNode *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[ASButtonNode alloc] init];
        _confirmButton.style.height = ASDimensionMakeWithPoints(50);
        _confirmButton.style.spacingBefore = 5.0;
        _confirmButton.cornerRadius = 4.0;
        _confirmButton.backgroundColor = [UIColor mainBlue];
        _confirmButton.clipsToBounds = YES;
        [_confirmButton setTitle:NSLocalizedString(@"QSM_0065", @"Verify") withFont:[UIFont fontWithName:@"NotoSans-Medium" size:16] withColor:[UIColor white] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _confirmButton;
}

- (ASDisplayNode *)pinCodeNode {
    if(!_pinCodeNode){
        _pinCodeNode = [[ASDisplayNode alloc] initWithViewBlock:^{
            PinCodeTextField *view  = [[PinCodeTextField alloc] init] ;
            view.characterLimit = 6;
            view.keyboardType = UIKeyboardTypeNumberPad;
            view.underlineWidth = 30;
            view.fontSize = 30;
            view.textColor = [UIColor black];
            view.underlineColor = [UIColor black];
            view.updatedUnderlineColor = [UIColor black];
            view.delegate = self;
            [view becomeFirstResponder];
            return view;
        }];
        _pinCodeNode.automaticallyManagesSubnodes = YES;
        _pinCodeNode.backgroundColor = [UIColor white];
        _pinCodeNode.style.width = ASDimensionMakeWithFraction(1.0);
        _pinCodeNode.style.height = ASDimensionMakeWithPoints(70);
        
    }
    return _pinCodeNode;
}

#pragma mark - BUTTON ACTION

- (void)backButtonDidPress:(ASButtonNode *)button {
    if (self.delegate){
        [self.delegate cancel];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)confirmButtonDidPress:(ASButtonNode *)button {
    __weak typeof(self) weakSelf = self;
    [self.node.view endEditing:true];
    if (self.delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator showLoadingIndicator:nil];
        });
        [self.delegate verifyOTP:_otpText];
    }else{
        [[QSManager shared].auth verifyOTP:_otpText completionBlock:^(NSDictionary * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf fetchLoginWithUserId:[QaaS savedUserId] withPassword:[QaaS savedPassword] withApplicationId:[QaaS savedApplicationId] withAutoLogin:[QaaS savedAutoLoginEnabled]];
            });
            
        } failtureBlock:^(NSError * _Nonnull error) {
            [[QSManager shared].navigator pushBasePopUpWithTitle:NSLocalizedString(@"QSM_0069", @"Verify password") desc:NSLocalizedString(@"QSM_0070", @"Wrong password")
                fromVC: self
                type:@"verify"
                completionBlock:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)transitionToRootViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        animation.duration = 0.35f;
        
        UIViewController *prevViewController = [[UIViewController alloc] init];
        UIView *prevView = [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] snapshotViewAfterScreenUpdates:NO];
        prevViewController.view = prevView;
        UIWindow *transitionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        transitionWindow.rootViewController = prevViewController;
        [transitionWindow makeKeyAndVisible];
        
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        [keyWindow.layer addAnimation:animation forKey:@"windowTransition"];
        keyWindow.rootViewController = viewController;
        [keyWindow makeKeyAndVisible];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [transitionWindow removeFromSuperview];
        }];
        [CATransaction commit];
    } else {
        [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
    }
}

- (void)resetOTPDidPress:(ASButtonNode *)button {

    [[QSManager shared].navigator pushBasePopUpWithTitle:@""
                               desc:NSLocalizedString(@"QSM_0068", @"Would you like to reset your OTP?")
                               fromVC:self
                               type:@"resetMFA"
                               completionBlock:^(BOOL finished) {
        
    }];
}


- (void)fetchLoginWithUserId:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];
    __weak typeof(self) weakSelf = self;
    [QaaS loadApplicationById:applicationId completionBlock:^(UIViewController *rootViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf transitionToRootViewController:rootViewController animated:YES];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            if (error){
                [QSToast showErrorToastWithMessage:error.localizedDescription];
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}
#pragma mark - PinCodeTextFieldDelegate
- (void)textFieldDidBeginEditing:(PinCodeTextField *)textField {
    [textField.superview setNeedsLayout];
}

- (void)textFieldDidEndEditing:(PinCodeTextField *)textField {
    _otpText = textField.text;
    [textField.superview setNeedsLayout];
}

- (BOOL)textFieldShouldReturn:(PinCodeTextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(PinCodeTextField * _Nonnull)textField {
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(PinCodeTextField * _Nonnull)textField {
    return YES;
}


- (void)textFieldValueChanged:(PinCodeTextField * _Nonnull)textField {
    
}

- (BOOL) presentationControllerShouldDismiss:(UIPresentationController *)presentationController {
    return NO;
}

- (void) presentationControllerDidDismiss:(UIPresentationController *)presentationController{
    if (self.delegate){
        [self.delegate cancel];
    }
}

#pragma mark -  BasePopUpDelegate

- (void)confirm:(NSString*)type{
    if ([type isEqualToString:@"resetMFA"]){
        if (self.delegate){
            [self.delegate resetOTPWithCompletion:^(NSString * _Nonnull data) {
                @synchronized(self) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QSLoadingIndicator dismissLoadingIndicator];
                    [QSToast showErrorToastWithMessage:error.localizedDescription];
                });
            }];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
- (void)cancel:(NSString*)type{
    
}


@end

