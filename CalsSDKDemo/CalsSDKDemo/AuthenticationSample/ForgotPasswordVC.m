//
//  ForgotPasswordVC.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 20/06/22.
//
#import "Helper.h"
#import "ForgotPasswordVC.h"
#import <CalsplatzSDK/CalsplatzSDK.h>
//#import "CalsplatzSDK.h"
@interface ForgotPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIStackView *changePWSV;
@property (strong, nonatomic) NSString *displayType;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWTextField;

@end

@implementation ForgotPasswordVC

- (instancetype)initWithDisplayType:(NSString*)type {
    if (self = [super init]) {
        self.displayType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_displayType isEqualToString:@"init"]? @"Forgot Password" : @"Change Password";
    _changePWSV.hidden = [_displayType isEqualToString:@"init"]? YES: NO;
    _emailTF.hidden = [_displayType isEqualToString:@"init"]? NO: YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)showAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:141/255.0f green:0/255.0f blue:254/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (IBAction)submitForgotPasswordTapped:(id)sender {
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Helper showLoadingIndicator:nil];
    });
    if ([_displayType isEqualToString:@"init"]){
        [CalsplatzSDK forgotPasswordWithEmail:self.emailTF.text completionBlock:^(NSDictionary *dictionary) {
            [Helper dismissLoadingIndicator];
            self.view.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showAlert:@"success"];
            });
        } failureBlock:^(NSError *error) {
            [Helper dismissLoadingIndicator];
            self.view.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showAlert:error.localizedDescription];
            });
        }];
    }else{
        [CalsplatzSDK changePasswordWithOldPassword:[CalsplatzSDK getCurrentUserPassword] Password:_passwordTextField.text confirmPassword:_passwordTextField.text completionBlock:^(NSDictionary *dictionary) {
            [Helper dismissLoadingIndicator];
            self.view.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showAlert:@"success"];
            });
        } failureBlock:^(NSError *error) {
            [Helper dismissLoadingIndicator];
            self.view.userInteractionEnabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showAlert:error.localizedDescription];
            });
        }];
    }
    
}

@end
