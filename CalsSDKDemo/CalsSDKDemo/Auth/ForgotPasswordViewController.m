//
//  ForgotPasswordViewController.m
//  CALS
//
//  Created by seoungchul bae on 2020/10/12.
//  Copyright © 2020 Quintet Systems. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "QaaS.h"
#import "QSDefine.h"
#import "vQSText.h"
#import "vQSPassword.h"
#import "vQSButton.h"
#import "QSPopup.h"
#import "CALSSDK.h"
@interface ForgotPasswordViewController () <UITextFieldDelegate>
{
    vQSText *_emailTextNode;
    vQSPassword *_passwordTextNode;
    vQSPassword *_confirmPasswordTextNode;
    vQSButton *_cancelButtonNode;
    vQSButton *_confirmButtonNode;
    CGFloat _popupHeight;
}
@property (strong, nonatomic) NSString *displayType;
@end

@implementation ForgotPasswordViewController
- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit:nil];
    }
    return self;
}
- (instancetype)initWithDisplayType:(NSString*)type {
    if (self = [super initWithNode:[ASDisplayNode new]]) {
        [self commonInit:type];
    }
    return self;
}
- (void)commonInit:(NSString*)type {
    self.node.automaticallyManagesSubnodes = YES;
    self.node.automaticallyRelayoutOnSafeAreaChanges = YES;
    self.node.automaticallyRelayoutOnLayoutMarginsChanges = YES;
    
    _displayType = type;
    _popupHeight = [_displayType isEqualToString:@"init"]? 230:325;
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = ^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        if (!weakSelf) return [ASLayoutSpec new];
        
        NSArray *children = @[];
        if([weakSelf.displayType isEqualToString:@"init"]){
            children = @[weakSelf.emailTextNode];
        }else{
            children = @[weakSelf.passwordTextNode, weakSelf.confirmPasswordTextNode];
        }
        
        ASStackLayoutSpec *spac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:children];
        ASInsetLayoutSpec *insetSpac = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 25, 0, 25) child:spac];
        
        ASStackLayoutSpec *buttonSpac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[weakSelf.cancelButtonNode, weakSelf.confirmButtonNode]];
        
        ASStackLayoutSpec *addButtonsSpac = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[insetSpac, buttonSpac]];
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(25, 0, 0, 0) child:addButtonsSpac];
    };
}
- (void)dealloc {
    self.node.layoutSpecBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [_displayType isEqualToString:@"init"]? NSLocalizedString(@"QSM_0035", @"Forgot your password"):NSLocalizedString(@"QSM_0036", @"Change password");
        
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.view.backgroundColor = [UIColor white];
    
    QSControl *emailControl = [QSControl new];
    emailControl.title = NSLocalizedString(@"QSM_0039", @"E-mail address");
    emailControl.enabled = YES;
    emailControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    self.emailTextNode.qs_control = emailControl;
    
    QSControl *passwordControl = [QSControl new];
    passwordControl.title = NSLocalizedString(@"QSM_0037", @"Password");
    passwordControl.enabled = YES;
    passwordControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    self.passwordTextNode.qs_control = passwordControl;
    
    QSControl *confirmPasswordControl = [QSControl new];
    confirmPasswordControl.title = NSLocalizedString(@"QSM_0038", @"Confirm Password");
    confirmPasswordControl.enabled = YES;
    confirmPasswordControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    self.confirmPasswordTextNode.qs_control = confirmPasswordControl;
    
    QSControl *cancelButtonControl = [QSControl new];
    cancelButtonControl.title = NSLocalizedString(@"QSM_0040", @"Cancel");
    cancelButtonControl.enabled = YES;
    cancelButtonControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    self.cancelButtonNode.qs_control = cancelButtonControl;
    
    QSControl *confirmButtonControl = [QSControl new];
    confirmButtonControl.title = [_displayType isEqualToString:@"init"]?NSLocalizedString(@"QSM_0042", @"Confirm"):NSLocalizedString(@"QSM_0041", @"Confirm");
    confirmButtonControl.enabled = YES;
    confirmButtonControl.style = [[QSStyle alloc] initWithStyleDictionary:@{}];
    self.confirmButtonNode.qs_control = confirmButtonControl;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [QSPopup relayout:self.node size:CGSizeMake(0, 200)];
//    });
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [QSPopup relayout:self.node size:CGSizeMake(0, _popupHeight)];
}

- (vQSText *)emailTextNode {
    if (!_emailTextNode) {
        _emailTextNode = [[vQSText alloc] init];
        _emailTextNode.textField.clipsToBounds = YES;
        _emailTextNode.textField.layer.cornerRadius = 3;
        _emailTextNode.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextNode.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextNode.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextNode.textField.returnKeyType = UIReturnKeyNext;
        _emailTextNode.textField.delegate = self;
    }
    return _emailTextNode;
}

- (vQSPassword *)passwordTextNode {
    if (!_passwordTextNode) {
        _passwordTextNode = [[vQSPassword alloc] init];
        _passwordTextNode.textField.clipsToBounds = YES;
        _passwordTextNode.textField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextNode.textField.returnKeyType = UIReturnKeyGo;
        _passwordTextNode.textField.delegate = self;
    }
    return _passwordTextNode;
}

- (vQSPassword *)confirmPasswordTextNode {
    if (!_confirmPasswordTextNode) {
        _confirmPasswordTextNode = [[vQSPassword alloc] init];
        _confirmPasswordTextNode.textField.clipsToBounds = YES;
        _confirmPasswordTextNode.textField.keyboardType = UIKeyboardTypeDefault;
        _confirmPasswordTextNode.textField.returnKeyType = UIReturnKeyGo;
        _confirmPasswordTextNode.textField.delegate = self;
        _confirmPasswordTextNode.style.spacingBefore = 15;
    }
    return _confirmPasswordTextNode;
}

- (vQSButton *)cancelButtonNode {
    if(!_cancelButtonNode){
        _cancelButtonNode = [[vQSButton alloc] init];
        [_cancelButtonNode.buttonNode addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
        _cancelButtonNode.style.flexGrow = 1.0;
    }
    return _cancelButtonNode;
}
- (vQSButton *)confirmButtonNode {
    if(!_confirmButtonNode){
        _confirmButtonNode = [[vQSButton alloc] init];
        [_confirmButtonNode.buttonNode addTarget:self action:@selector(confirmButtonDidPress:) forControlEvents:ASControlNodeEventTouchUpInside];
        _confirmButtonNode.style.flexGrow = 1.0;
    }
    return _confirmButtonNode;
}

- (void)cancelButtonDidPress:(ASButtonNode *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)confirmButtonDidPress:(ASButtonNode *)button {
    if ([_displayType isEqualToString:@"init"]) {
        if (![self.emailTextNode.textField.text length]) {
            [self.emailTextNode.textField becomeFirstResponder];
            return;
        }
        [self fatchLoginPasswordInit:self.emailTextNode.textField.text];
    }else{
        if (![self.passwordTextNode.textField.text length]) {
            [self.passwordTextNode.textField becomeFirstResponder];
            return;
        }
        if (![self.confirmPasswordTextNode.textField.text length]) {
            [self.confirmPasswordTextNode.textField becomeFirstResponder];
            return;
        }
        if (![self.confirmPasswordTextNode.textField.text isEqualToString:self.passwordTextNode.textField.text]){
            [self.confirmPasswordTextNode.textField becomeFirstResponder];
            dispatch_async(dispatch_get_main_queue(), ^{
                [QSToast showErrorToastWithMessage:NSLocalizedString(@"QSM_0043", @"Please check the new password confirmation.")];
            });
            return;
        }

        [self fetchLoginPasswordChangePassword:self.passwordTextNode.textField.text confirmPassword:self.passwordTextNode.textField.text];
    }
}

- (void)fatchLoginPasswordInit:(NSString*)email {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];
    __weak typeof(self) weakSelf = self;
    [CALSSDK forgotPasswordWithEmail:email completionBlock:^(NSDictionary *dictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            if(weakSelf.completionBlock){
                weakSelf.completionBlock(YES);
            }
            [QSToast showSuccessToastWithMessage:dictionary[@"message"]?:@"OK"];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            [QSToast showErrorToastWithMessage:error.localizedDescription];
        });
    }];
}
- (void)fetchLoginPasswordChangePassword:(NSString *)password confirmPassword:(NSString *)confirmPassword {
    self.view.userInteractionEnabled = NO;
    [QSLoadingIndicator showLoadingIndicator:nil];
    __weak typeof(self) weakSelf = self;
    [CALSSDK changePasswordWithOldPassword:[CALSSDK getCurrentUserPassword] Password:password confirmPassword:confirmPassword completionBlock:^(NSDictionary *dictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            if(weakSelf.completionBlock){
                weakSelf.completionBlock(YES);
            }
            [QSToast showSuccessToastWithMessage:dictionary[@"message"]?:@"OK"];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QSLoadingIndicator dismissLoadingIndicator];
            weakSelf.view.userInteractionEnabled = YES;
            [QSToast showErrorToastWithMessage:error.localizedDescription];
        });
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
    [self.view endEditing:YES];
    return YES;
}
@end
