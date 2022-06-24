//
//  SettingsViewController.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 10/06/22.
//
#import "Helper.h"
#import "SettingsViewController.h"
//#import "CalsplatzSDK.h"
#import <CalsplatzSDK/CalsplatzSDK.h>
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Change Theme";
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)redTapped:(id)sender {
    [CalsplatzSDK setColorTheme:[UIColor redColor]];
}

- (IBAction)defaultTapped:(id)sender {
    [CalsplatzSDK setColorThemeToDefault];
}

@end

