//
//  QSIcon.m
//  CALS
//
//  Created by Quintet on 26/07/2019.
//  Copyright © 2019 Quintet Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSIcon.h"
//#import "CalsplatzSDK/CalsplatzSDK-Swift.h"
#import "CalsplatzSDK/CalsplatzSDK-Swift.h"

@implementation QSIcon
+ (void)iconInit {
    //fontawesome bug --
    UIImage *tempIcon = [QSIcon iconWithName:@"fa-play" style:FontAwesomeObjCStyleSolid color:[UIColor clearColor] size:CGSizeMake(0, 0)];
    tempIcon = nil;
}
+ (UIImage *)iconWithName:(NSString *)name style:(FontAwesomeObjCStyle)style color:(UIColor *)color size:(CGSize)size {
    // should be called in main thread.
    UIImage *icon = [FontAwesomeLoader iconWithName:name style:style textColor:color size:size];
    return icon;
    
//    UIImage*(^completionBlock)(void) = ^{
//        __block UIImage *icon;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            icon = [FontAwesomeLoader iconWithName:name style:style textColor:color size:size];
//        });
//        //UIImage *icon = [FontAwesomeLoader iconWithName:name style:style textColor:color size:size];
//        return icon;
//    };
//    return completionBlock();
    
    
}
+ (void)iconLoadCompletionBlock:(void(^)(void))completionBlock {
    //버그 수정중....
//    dispatch_group_t dispatchGroup = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    void(^finishedBlock)(void) = ^{
//        dispatch_group_leave(dispatchGroup);
//        dispatch_semaphore_signal(semaphore);
//    };
//    
//    dispatch_group_enter(dispatchGroup);
//    __block UIImage *tempIcon;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        tempIcon = [QSIcon iconWithName:@"fa-play" style:FontAwesomeObjCStyleSolid color:[UIColor clearColor] size:CGSizeMake(0, 0)];
//    });
//    while (tempIcon == nil) {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    }
//    
//    completionBlock();
}
@end
