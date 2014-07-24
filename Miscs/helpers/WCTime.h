//
//  WCTime.h
//  WellnessConnected
//
//  Created by Chenchen Zheng on 6/24/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, timeType) {
  displayType,
  savingType
};
@interface WCTime : NSObject


+ (NSString *)printDateTime: (NSString *)dateTime withFormat: (NSString *)format;
+ (NSString *)printDateTimeWithLocaleFormat: (NSString *)dateTime;
//+ (NSString *)printDateTimeWithDateNow;
+ (NSString *)convertDateTimeToFixedFormat: (NSString *)time;
+ (NSString *)printDateWithLocaleFormat: (NSString *)dateTime;
+ (NSString *)printTimeWithLocaleFormat: (NSString *)dateTime;
+ (NSString *)printDateTimeWithDateNow:(timeType) timeType;

@end
