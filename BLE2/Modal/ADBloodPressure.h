//
//  ADBloodPressure.h
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANDDevice.h"

typedef NS_ENUM(NSInteger, ADBPOrder) {
  DESC,
  ASC
};

@interface ADBloodPressure : ANDDevice

@property (nonatomic, strong) NSNumber *measurementID;
@property (nonatomic, strong) NSString *measurementTime;
@property (nonatomic, strong) NSString *measurementReceivedTime;
@property (nonatomic, strong) NSNumber *systolic;
@property (nonatomic, strong) NSNumber *diastolic;
@property (nonatomic, strong) NSNumber *WCPulse;
@property (nonatomic, strong) NSNumber *map;

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *isManualInput;

- (id) initWithMT: (NSString *) measurementTime
                             MRT: (NSString *) measurementReceivedTime
                             Sys: (NSString *) Systolic
                             Dia: (NSString *) Diastolic
                             Pul: (NSString *) Pulse
                             UID: (NSString *) UserID
                             isM: (NSString *) isManualInput;
- (NSString *)description;
- (id) initWithLatestMeasurement;
+ (NSArray *) listOfMeasurement:(ADBPOrder) order;
+ (NSInteger) count;
+ (NSString *) save: (ADBloodPressure *)bp;
- (NSString *) save;
+ (NSInteger) maxValue:(NSString *)value;
+ (NSInteger) minValue:(NSString *)value;
+ (void) deleteMreasurementAt: (NSNumber *) measurementID;
+ (void) createTable;
//- (void) putBPInHealthVault;

- (id)initWithDevice:(ANDDevice *)device;
- (void)pair;
- (void)readMeasurement;
- (void)readMeasurementForSetup;
- (void)setTimeOfCurrentTimeService;

@end
