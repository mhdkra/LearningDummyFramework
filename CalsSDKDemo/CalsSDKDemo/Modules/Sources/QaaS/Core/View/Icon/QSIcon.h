//
//  QSIcon.h
//  CALS
//
//  Created by Quintet on 26/07/2019.
//  Copyright © 2019 Quintet Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalsplatzSDK/CalsplatzSDK-Swift.h"
//#import "CalsSDKDemo-Swift.h"

NS_ASSUME_NONNULL_BEGIN

/**
 이미지 객체를 생성하는 클래스.
 */
@interface QSIcon : NSObject

#pragma mark - Generator
+ (void)iconInit;
/**
 FontAwesome 아이콘 이름으로, 이미지 객체를 생성하는 메소드.

 @param name FontAwesome 아이콘 이름 문자열. `fa-` prefix 생략 가능.
 @param style 아이콘 스타일. `FontAwesomeObjCStyleSolid` / `FontAwesomeObjCStyleRegular` / `FontAwesomeObjCStyleBrands`.
 @param color 아이콘 색상.
 @param size 아이콘 크지.
 @return 생성된 아이콘 이미지. `UIImage` 객체.
 */
+ (UIImage *)iconWithName:(NSString *)name
                    style:(FontAwesomeObjCStyle)style
                    color:(UIColor *)color
                     size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
