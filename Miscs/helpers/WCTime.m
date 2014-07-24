//
//  WCTime.m
//  WellnessConnected
//
//  Created by Chenchen Zheng on 6/24/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCTime.h"

@implementation WCTime

+ (NSString *)printDateTime: (NSString *)dateTime withFormat: (NSString *)format
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  NSDate *date = [dateFormatter dateFromString:dateTime];
  [dateFormatter setDateFormat:format];
  NSString *result = [dateFormatter stringFromDate:date];
  return result;
}

+ (NSString *)printDateTimeWithLocaleFormat: (NSString *)dateTime
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  NSDate *date = [dateFormatter dateFromString:dateTime];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", nil)];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:locale];
  NSString *result = [dateFormatter stringFromDate:date];
  return result;
}

// if i'm setting display i'll use NSDateFormatterShortStyle, if I'm saving data I'll use NSDateFormatterLongStyle
+ (NSString *)printDateTimeWithDateNow:(timeType) timeType
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSDate *date = [NSDate date];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", nil)];
  if (timeType == displayType) {
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  } else if (timeType == savingType) {
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
  }
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:locale];
  NSString *result = [dateFormatter stringFromDate:date];
  return result;
}

+ (NSString *)convertDateTimeToFixedFormat: (NSString *)time
{
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", nil)];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:locale];
  NSString *result;
  NSDate *date = [dateFormatter dateFromString:time];
  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  result = [dateFormatter stringFromDate:date];
  NSLog(@"convertTimeToFixedFormat result: %@", result);
  return result;
}

+ (NSString *)printDateWithLocaleFormat: (NSString *)dateTime
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  NSDate *date = [dateFormatter dateFromString:dateTime];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", nil)];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setLocale:locale];
  NSString *result = [dateFormatter stringFromDate:date];
  return result;
}

+ (NSString *)printTimeWithLocaleFormat: (NSString *)dateTime
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
  NSDate *date = [dateFormatter dateFromString:dateTime];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"locale", nil)];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  [dateFormatter setDateStyle:NSDateFormatterNoStyle];
  [dateFormatter setLocale:locale];
  NSString *result = [dateFormatter stringFromDate:date];
  return result;
}

@end
