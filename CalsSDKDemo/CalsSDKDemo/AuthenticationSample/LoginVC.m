//
//  LoginVC.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 13/06/22.
//

#import "LoginVC.h"
#import "ServerViewController.h"
#import "ForgotPasswordVC.h"
#import "SettingsViewController.h"
#import <CalsplatzSDK/CalsplatzSDK.h>
//#import "CalsplatzSDK.h"
#import "Helper.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userIDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (nonatomic, copy) NSString *selectedServerPrefix;
@property (nonatomic) BOOL isFetching;
@property (nonatomic) BOOL isAutoLogin;

@end

@implementation LoginVC
- (instancetype)init {
    if (self = [super init]) {

        self.selectedServerPrefix = [CalsplatzSDK getCurrentServerPrefix];
        //자동로그인 설정 확인시
        //자동로그인 처리는 인트로 화면에서 처리
        [self fetchLoginPreferenctWithCompletionBlock:^{
        }];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *a = [CalsplatzSDK getCurrentApplicationId];
    _userIDTextfield.text = [CalsplatzSDK getCurrentUserID];
    _passwordTextfield.text = [CalsplatzSDK getCurrentUserPassword];
    [[self autoLoginSwitch] setOn:[CalsplatzSDK savedAutoLoginEnabled]];
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


- (void)fetchLoginPreferenctWithCompletionBlock:(void(^)(void))completionBlock {
    if (self.isFetching) return ;
    self.isFetching = YES;
    
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;

    [CalsplatzSDK loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        weakSelf.isFetching = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            if (completionBlock) {
                completionBlock();
            }
        });
    } failureBlock:^(NSError *error) {
        weakSelf.isFetching = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [self showAlert:error.localizedDescription];
        });
    }];
}

- (void)loginWithMFA:(NSString*)userId withPassword:(NSString*)userPw withApplicationId:(NSString*)applicationId withAutoLogin:(BOOL)autologin {
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Helper showLoadingIndicator:nil];
        [CalsplatzSDK loginWithUserID:userId withPassword:userPw withApplicationId:applicationId withAutoLogin:weakSelf.isAutoLogin loginVC:weakSelf failureBlock:^(NSError *error) {
            [Helper dismissLoadingIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.view.userInteractionEnabled = YES;
                if (error){
                    if([error.localizedDescription containsString:@""]){
                        [weakSelf.navigationController pushViewController:[[ForgotPasswordVC alloc] initWithDisplayType:@"change"] animated:YES];
                    }else{
                        [self showAlert:error.localizedDescription];
                    }
                }
            });
        }];
        weakSelf.view.userInteractionEnabled = YES;
        [Helper dismissLoadingIndicator];
    });

}
- (IBAction)switchTapped:(id)sender {
    _isAutoLogin = _autoLoginSwitch.isOn;
    [CalsplatzSDK setAutoLoginEnabled:_autoLoginSwitch.isOn];
}

- (IBAction)loginTapped:(id)sender {
    [self loginWithMFA:self.userIDTextfield.text withPassword:self.passwordTextfield.text  withApplicationId:[CalsplatzSDK getCurrentApplicationId] withAutoLogin:YES];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    [self.navigationController pushViewController:[[ForgotPasswordVC alloc] initWithDisplayType:@"init"] animated:YES];
}

- (IBAction)settingsTapped:(id)sender {
    UIViewController *vc = [SettingsViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)serverTapped:(id)sender {
    UIViewController *vc = [ServerViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

@end
