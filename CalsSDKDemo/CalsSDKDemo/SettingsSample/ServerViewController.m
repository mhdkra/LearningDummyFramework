//
//  ServerViewController.m
//  CalsSDKDemo
//
//  Created by Tiara Mahardika on 09/06/22.
//
#import "Helper.h"
#import "ServerViewController.h"
//#import "CalsplatzSDK.h"
#import <CalsplatzSDK/CalsplatzSDK.h>
@interface ServerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSArray *data;
@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.title = @"Servers";
    // Do any additional setup after loading the view from its nib.
}

- (NSArray *)letters {
    if (!_letters) {
        _letters = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j"];
    }
    return _letters;
}

- (NSArray *)data {
    if (!_data) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSArray *serverList = [CalsplatzSDK getServerPrefixList];
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

- (void)fetchLoginPreference{
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Helper showLoadingIndicator:nil];
    });
   
    [CalsplatzSDK loadLoginPreferenceWithCompletionBlock:^(NSDictionary *preference) {
        [Helper dismissLoadingIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf showAlert:@"success"];
            [self.tableView reloadData];
        });
    } failureBlock:^(NSError *error) {
        [Helper dismissLoadingIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlert:error.localizedDescription];
            weakSelf.view.userInteractionEnabled = YES;
        });
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *selectedServerPrefix = [CalsplatzSDK getServerPrefixList][indexPath.row][@"value"];
    [cell textLabel].text = selectedServerPrefix;
    NSString *current =  [CalsplatzSDK getCurrentServerPrefix];
    
    if([selectedServerPrefix isEqualToString:current]){
        [cell textLabel].textColor = [UIColor blueColor];
    }else{
        [cell textLabel].textColor = [UIColor blackColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *selectedServerPrefix = [CalsplatzSDK getServerPrefixList][index][@"value"];
        [Helper showLoadingIndicator:nil];
        [CalsplatzSDK setServerPrefix:selectedServerPrefix];
        [self fetchLoginPreference];
    });
    
}


@end
