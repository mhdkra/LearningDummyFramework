//
//  LoginNode.m
//  CALS
//
//  Created by Quintet on 16/07/2019.
//  Copyright © 2019 Quintet Systems. All rights reserved.
//

#import "LoginNode.h"
#import "QaaS.h"
#import "QSManager.h"
#import "vQSText.h"
#import "vQSPassword.h"
#import "QSDefine.h"
#import "ServerViewController.h"
#import "Welcome2FAViewController.h"
#import "BasePopUpViewController.h"

@interface LoginNode () <UITextFieldDelegate, BasePopUpDelegate>{
    ASDisplayNode *_logoBgNode;
    ASImageNode *_logoNode;
    ASImageNode *_headerNode;
    ASDisplayNode *_fieldBgNode;
    vQSText *_idTextField;
    vQSPassword *_passwordTextField;
    ASButtonNode *_loginButton;
    ASButtonNode *_autoLoginCheckButton;
    ASButtonNode *_findPasswordButton;
    ASTextNode *_copylightNode;
}
@property (nonatomic, copy) NSString *selectedServerPrefix;
@property (nonatomic) BOOL isFetching;
@end

@implementation LoginNode

- (instancetype)init {
    if (self = [super init]) {
        self.automaticallyManagesSubnodes = YES;
        self.automaticallyManagesContentSize = YES;
        self.automaticallyRelayoutOnSafeAreaChanges = YES;
        self.scrollableDirections = ASScrollDirectionVerticalDirections;
        self.backgroundColor = [UIColor white];
        self.defaultLayoutTransitionOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction;
        
        self.selectedServerPrefix = [QaaS savedServerPrefix];
        //자동로그인 설정 확인시
        //자동로그인 처리는 인트로 화면에서 처리
        [self fetchLoginPreferenctWithCompletionBlock:^{
//            if([QaaS savedAutoLoginEnabled]){
//                [self fetchLoginWithUserId:[QaaS savedUserId] withPassword:[QaaS savedPassword] withApplicationId:[QaaS savedApplicationId] withAutoLogin:[QaaS savedAutoLoginEnabled]];
//            }
        }];
    }
    return self;
}

- (ASDisplayNode *)logoBgNode {
    if (!_logoBgNode) {
        ASButtonNode *button = [ASButtonNode new];
        button.backgroundColor = [UIColor clearColor];
        button.style.width = ASDimensionMakeWithPoints(60);
        button.style.height = ASDimensionMakeWithPoints(60);
        [button setImage:[QSIcon iconWithName:@"fa-cog" style:FontAwesomeObjCStyleSolid color:[UIColor white] size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(serverSettingButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
        
        ASImageNode *bgImageNode = [ASImageNode new];
        bgImageNode.image = [UIImage imageNamed:@"graphic"];
        bgImageNode.style.width = ASDimensionMakeWithFraction(1.0);
        bgImageNode.style.flexGrow = 0.2;
        
        ASDisplayNode *bgBottomNode = [ASDisplayNode new];
        bgBottomNode.backgroundColor = [UIColor white];
        bgBottomNode.style.width = ASDimensionMakeWithFraction(1.0);
        bgBottomNode.style.flexGrow = 0.8;
        
        _logoBgNode = [ASDisplayNode new];
        _logoBgNode.automaticallyManagesSubnodes = YES;
        _logoBgNode.style.height = ASDimensionMakeWithFraction(1.0);
        __weak typeof(self) weakSelf = self;
        _logoBgNode.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASInsetLayoutSpec *buttonSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(weakSelf.safeAreaInsets.top, INFINITY, INFINITY, weakSelf.safeAreaInsets.right) child:button];
            ASOverlayLayoutSpec *overlaylayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[bgImageNode, bgBottomNode]] overlay:buttonSpec];
            return overlaylayoutSpec;
        };
    }
    return _logoBgNode;
}
- (ASDisplayNode *)fieldBgNode {
    if(!_fieldBgNode){
        _fieldBgNode = [ASDisplayNode new];
        _fieldBgNode.automaticallyManagesSubnodes = YES;
        _fieldBgNode.backgroundColor = [UIColor white];
//        _fieldBgNode.clipsToBounds = YES;
        _fieldBgNode.cornerRadius = 9;
        _fieldBgNode.shadowColor = [UIColor black].CGColor;
        _fieldBgNode.shadowRadius = 1;
        _fieldBgNode.shadowOffset = CGSizeMake(0, 1);
        _fieldBgNode.shadowOpacity = 0.2;
        _fieldBgNode.style.width = ASDimensionMakeWithFraction(1.0);
    }
    return _fieldBgNode;
}
- (ASImageNode *)logoNode {
    if (!_logoNode) {
        _logoNode = [ASImageNode new];
        _logoNode.image = [UIImage imageNamed:@"logoSales"];
        _logoNode.contentMode = UIViewContentModeCenter;
        _logoNode.style.spacingAfter = 30;
    }
    return _logoNode;
}

- (vQSText *)idTextField {
    if (!_idTextField) {
        _idTextField = [[vQSText alloc] init];
        _idTextField.textField.clipsToBounds = YES;
        _idTextField.textField.layer.cornerRadius = 3;
        _idTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _idTextField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _idTextField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _idTextField.textField.returnKeyType = UIReturnKeyNext;
        _idTextField.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0001", @"ID") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName: [UIColor mediumGray]}];
        _idTextField.textField.delegate = self;
    }
    return _idTextField;
}

- (vQSPassword *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[vQSPassword alloc] init];
        _passwordTextField.textField.clipsToBounds = YES;
        _passwordTextField.textField.layer.cornerRadius = 3;
        _passwordTextField.textField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.textField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0002", @"Password") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName: [UIColor mediumGray]}];
        _passwordTextField.textField.delegate = self;
    }
    return _passwordTextField;
}

- (ASButtonNode *)loginButton {
    if (!_loginButton) {
        _loginButton = [[ASButtonNode alloc] init];
        _loginButton.style.height = ASDimensionMakeWithPoints(50);
        _loginButton.style.spacingBefore = 5.0;
        _loginButton.backgroundColor = [UIColor cerulean];
        _loginButton.clipsToBounds = YES;
        _loginButton.cornerRadius = 3;
        [_loginButton setTitle:NSLocalizedString(@"QSM_0003", @"Sign in") withFont:[UIFont mediumFontWithSize:18.0] withColor:[UIColor white] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _loginButton;
}
- (ASButtonNode *)autoLoginCheckButton {
    if(!_autoLoginCheckButton){
        _autoLoginCheckButton = [ASButtonNode new];
        CGSize iconSize = CGSizeMake(15, 15);
        UIImage *checkIcon = [QSIcon iconWithName:@"fa-check" style:FontAwesomeObjCStyleSolid color:[UIColor white] size:iconSize];
        UIImage *uncheckIcon = [QSIcon iconWithName:@"fa-check" style:FontAwesomeObjCStyleSolid color:[UIColor clearColor] size:iconSize];
        [_autoLoginCheckButton setImage:checkIcon forState:UIControlStateSelected];
        [_autoLoginCheckButton setImage:uncheckIcon forState:UIControlStateNormal];

        _autoLoginCheckButton.imageNode.backgroundColor = [UIColor white];
        _autoLoginCheckButton.imageNode.borderColor = [UIColor veryLightPinkTwo].CGColor;
        _autoLoginCheckButton.imageNode.borderWidth = 1;
        _autoLoginCheckButton.imageNode.cornerRadius = 3;
        _autoLoginCheckButton.imageNode.forcedSize = iconSize;
        _autoLoginCheckButton.imageNode.style.minSize = CGSizeMake(20, 20);
        _autoLoginCheckButton.imageNode.style.maxSize = CGSizeMake(20, 20);
        _autoLoginCheckButton.imageNode.contentMode = UIViewContentModeCenter;
        _autoLoginCheckButton.contentSpacing = 5;
        
        [_autoLoginCheckButton setTitle:NSLocalizedString(@"QSM_0004", @"Auto Login") withFont:FONT_REGULAR_SIZE(14.0) withColor:[UIColor black80] forState:UIControlStateNormal];
        [_autoLoginCheckButton addTarget:self action:@selector(autologinCheckButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
        _autoLoginCheckButton.selected = YES; //default selected
        _autoLoginCheckButton.imageNode.backgroundColor = _autoLoginCheckButton.selected ? [UIColor cerulean] : [UIColor white];
        _autoLoginCheckButton.imageNode.borderColor = _autoLoginCheckButton.selected ? [UIColor cerulean].CGColor : [UIColor veryLightPinkTwo].CGColor;
    }
    return _autoLoginCheckButton;
}
- (ASButtonNode *)findPasswordButton {
    if(!_findPasswordButton){
        _findPasswordButton = [[ASButtonNode alloc] init];
        _findPasswordButton.style.height = ASDimensionMakeWithPoints(40);
        _findPasswordButton.contentHorizontalAlignment = ASHorizontalAlignmentRight;
        _findPasswordButton.contentVerticalAlignment = ASVerticalAlignmentCenter;
        _findPasswordButton.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        _findPasswordButton.contentSpacing = 5;
//        [_autoLoginCheckButton setTitle:NSLocalizedString(@"QSM_0035", @"Forgot your password") withFont:[UIFont regularFontWithSize:14.0] withColor:[UIColor black80] forState:UIControlStateNormal];
        NSDictionary *attributes = @{NSFontAttributeName            : FONT_REGULAR_SIZE(14.0),
                                     NSForegroundColorAttributeName : [UIColor black80],
                                     NSUnderlineStyleAttributeName  : @(YES),
                                     };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"QSM_0035", @"Forgot your password") attributes:attributes];
        [_findPasswordButton setAttributedTitle:attributedString forState:UIControlStateNormal];
        [_findPasswordButton addTarget:self action:@selector(forgotPasswordButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _findPasswordButton;
}
- (ASTextNode *)copylightNode {
    if(!_copylightNode){
        _copylightNode = [ASTextNode new];
        _copylightNode.attributedText = [QSBaseStyle string:NSLocalizedString(@"QSM_0005", @"Copyright © 2020 Quintet Systems Inc. All rights reserved") font:[UIFont regularFontWithSize:11] color:[[UIColor black] colorWithAlphaComponent:0.4] alignment:NSTextAlignmentCenter];
        _copylightNode.style.spacingBefore = 30;
    }
    return _copylightNode;
}

- (void)didLoad {
    [super didLoad];
    
    if (@available(iOS 11.0, *)) {
        self.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    QSControl *idTextFieldControl = [QSControl new];
    idTextFieldControl.enabled = YES;
    idTextFieldControl.data = [QaaS savedUserId];
    idTextFieldControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    QSControl *passwordTextFieldControl = [QSControl new];
    passwordTextFieldControl.enabled = YES;
    passwordTextFieldControl.data = [QaaS savedPassword];
    passwordTextFieldControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    
    self.idTextField.qs_control = idTextFieldControl;
    self.passwordTextField.qs_control = passwordTextFieldControl;
}

- (void)layout {
    [self.logoBgNode setNeedsLayout];
    [self.logoBgNode layoutIfNeeded];
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexGrow = 1.0;
    spacer.style.flexShrink = 1.0;
    
    ASStackLayoutSpec *autologinAndFindPasswordSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:1 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[self.autoLoginCheckButton, spacer, self.findPasswordButton]];
    
//    NSArray *children = @[self.selectNodeApplication, self.idTextField, self.passwordTextField, self.autoLoginCheckButton, self.loginButton];
    NSArray *children = @[self.idTextField, self.passwordTextField, autologinAndFindPasswordSpec, self.loginButton];
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:16 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:children];
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20, 20, 20, 20) child:stackSpec];
    ASBackgroundLayoutSpec *backgroundSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:insetSpec background:self.fieldBgNode];
    
    ASStackLayoutSpec *stackLogoSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[self.logoNode, backgroundSpec, self.copylightNode]];
    ASInsetLayoutSpec *insetLogoSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, self.safeAreaInsets.left + 20, INFINITY, self.safeAreaInsets.right + 20) child:stackLogoSpec];
    
    self.logoBgNode.style.height = ASDimensionMakeWithPoints(MIN(constrainedSize.max.height, self.calculatedSize.height));
    
    ASOverlayLayoutSpec *overlaylayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.logoBgNode overlay:insetLogoSpec];

    return overlaylayoutSpec;
}

- (void)fetchLoginPreferenctWithCompletionBlock:(void(^)(void))completionBlock {
    if (self.isFetching) return ;
    self.isFetching = YES;
    
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [QSLoadingIndicator showLoadingIndicator:nil];
    });
    [QaaS loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        weakSelf.isFetching = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [QSLoadingIndicator dismissLoadingIndicator];
            if (completionBlock) {
                completionBlock();
            }
        });
    } failureBlock:^(NSError *error) {
        weakSelf.isFetching = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [QSLoadingIndicator dismissLoadingIndicator];
            [QSToast showErrorToastWithMessage:error.localizedDescription];
        });
    }];
}

- (void)fetchLoginWithUserId:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];
    [QaaS setAuthChallengeUserId:userId password:userPw autoLogin:autologin];
    
    __weak typeof(self) weakSelf = self;
    [QaaS loadApplicationById:applicationId completionBlock:^(UIViewController *rootViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            if(error.code == QSErrorCodeUserNewPassword){
                //비밀번호 변경
            }else{
                [QSToast showErrorToastWithMessage:error.localizedDescription];
            }
        });
    }];
}

- (void)fetchLoginWithUserIdNew:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];
    [QaaS setAuthChallengeUserId:userId password:userPw autoLogin:autologin];
    
    __weak typeof(self) weakSelf = self;
    [QaaS loadApplicationByIdNew:applicationId completionBlock:^(UIViewController *rootViewController, NSString *secretCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            
            if ([secretCode isEqualToString:@""] || !secretCode){
                [weakSelf transitionToRootViewController:rootViewController animated:YES];
            }else{
                Welcome2FAViewController *authVC = [[Welcome2FAViewController alloc] initWithCognitoUser:secretCode name:self.idTextField.textField.text];
                [[UIApplication topMostViewController].navigationController pushViewController:authVC animated:YES];
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            if(error.code == QSErrorCodeUserNewPassword){
                //비밀번호 변경
            }else{
                if (error){
                    [QSToast showErrorToastWithMessage:error.localizedDescription];
                }
            }
        });
    }];
}


- (void)failureBlockOnLoadApp:(NSError *)error {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [QSLoadingIndicator dismissLoadingIndicator];
        weakSelf.view.userInteractionEnabled = YES;
        if(error.code == QSErrorCodeUserNewPassword){
            //비밀번호 변경
            [self pushForgotPassword:@"change"];
        }else{
            [QSToast showErrorToastWithMessage:error.localizedDescription];
        }
    });
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

- (void)reloadApplicationList {
}

#pragma mark - button pressed
- (void)serverSettingButtonDidPress:(ASButtonNode *)button {
//    __weak typeof(self) weakSelf = self;
    ServerViewController *serverVC = [[ServerViewController alloc] init];
    serverVC.completionBlock = ^{
//        [weakSelf reloadApplicationList];
    };
    [[UIApplication topMostViewController].navigationController pushViewController:serverVC animated:YES];
}
- (void)loginButtonDidPress:(ASButtonNode *)button {
    if(!self.idTextField.textField.text.length){
        [self.idTextField.textField becomeFirstResponder];
        return;
    }
    if(!self.passwordTextField.textField.text.length){
        [self.passwordTextField.textField becomeFirstResponder];
        return;
    }
    
    [self fetchLoginWithUserIdNew:self.idTextField.textField.text withPassword:self.passwordTextField.textField.text withApplicationId:[QaaS savedApplicationId] withAutoLogin:self.autoLoginCheckButton.selected];
}

- (void)autologinCheckButtonDidPress:(ASButtonNode *)button {
    //자동로그인 체크 처리
    button.selected = !button.selected;
    self.autoLoginCheckButton.imageNode.backgroundColor = button.selected ? [UIColor cerulean] : [UIColor white];
    self.autoLoginCheckButton.imageNode.borderColor = button.selected ? [UIColor cerulean].CGColor : [UIColor veryLightPinkTwo].CGColor;
}
- (void)forgotPasswordButtonDidPress:(ASButtonNode *)button {
    //비밀번호 찾기(리셋)
    [self pushForgotPassword:@"init"];
}

- (void)pushForgotPassword:(NSString*)type {
    //type : e-mail, change
    [[QSManager shared].navigator pushForgatPasswordViewcontrollerWithType:type animated:YES completionBlock:^(BOOL finished) {
        if(finished){
            //성공
            if([type isEqualToString:@"init"]){
                self.passwordTextField.textField.text = nil;
                self.passwordTextField.qs_control.data = @"";
            }else{
                self.passwordTextField.textField.text = nil;
                self.passwordTextField.qs_control.data = @"";
            }
        }
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField.superview setNeedsLayout];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.qs_control.data = textField.text;
    [textField.superview setNeedsLayout];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.idTextField.textField) {
        return [self.passwordTextField.textField becomeFirstResponder];
    } else if (![self.idTextField.textField.text length]) {
        return [self.idTextField.textField becomeFirstResponder];
    } else if (![self.selectedServerPrefix length]) {
        [self.view endEditing:YES];
    }else if ([self.selectedServerPrefix length] && [self.idTextField.textField.text length] && [self.passwordTextField.textField.text length]) {
        [self.view endEditing:YES];
        [self loginButtonDidPress:self.loginButton];
    }
    return YES;
}

// BasePopUpDelegate
- (void)cancel:(nonnull NSString *)type {}

- (void)confirm:(nonnull NSString *)type {}

@end
