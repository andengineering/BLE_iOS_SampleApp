//
//  helper.m
//  Wellness
//
//  Created by Chenchen Zheng on 9/26/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "helper.h"

@implementation helper

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
  static NSUInteger _deviceSystemMajorVersion = -1;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
  });
  
  return _deviceSystemMajorVersion;
}

+ (NSString *)appNameAndVersionNumberDisplayString {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  //  NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
  NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
  
  return [NSString stringWithFormat:@"Version %@ (Build %@)",majorVersion, minorVersion];
}
@end
