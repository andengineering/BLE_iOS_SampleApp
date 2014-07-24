//
//  ADActivityMonitor.h
//  BLE2
//
//  Created by Chenchen Zheng on 1/8/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ANDDevice.h"
typedef NS_ENUM(NSInteger, ADAMOrder) {
  AM_DESC,
  AM_ASC
};

@interface ADActivityMonitor : ANDDevice

@property (nonatomic, strong) NSNumber *measurementID;
@property (nonatomic, strong) NSString *measurementReceivedTime;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSNumber *steps;
@property (nonatomic, strong) NSNumber *distances;
@property (nonatomic, strong) NSNumber *calories;
@property (nonatomic, strong) NSNumber *sleep;

- (id) initWithDate: (NSNumber *) date
          startTime: (NSString *) startTime
            endTime: (NSString *) endTime
              steps: (NSNumber *) steps
          distances: (NSNumber *) distances
           calories: (NSNumber *) calories
              sleep: (NSNumber *) sleep;
+ (void) createTable;
- (id) initWithLatestMeasurement;
+ (NSArray *) listOfMeasurement: (ADAMOrder) order;
+ (NSInteger) count;
+ (NSString *)save: (ADActivityMonitor *)am;
- (NSString *)save;
+ (NSInteger) maxValue: (NSString *)value;
+ (NSInteger) minValue: (NSString *)value;
+ (void) deleteMeasurementAt: (NSNumber *) measurementID;

- (id)initWithDevice:(ANDDevice *)device;
- (void)readHeader;
- (void)endConnection;
@end
