//
//  DummyFramework.h
//  DummyFramework
//
//  Created by Tiara Mahardika on 07/06/22.
//

#import <Foundation/Foundation.h>

//! Project version number for DummyFramework.
FOUNDATION_EXPORT double DummyFrameworkVersionNumber;

//! Project version string for DummyFramework.
FOUNDATION_EXPORT const unsigned char DummyFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DummyFramework/PublicHeader.h>
@interface CalsSDK : NSObject
+ (NSString *) stringFromHex:(NSString *)str;
@end
