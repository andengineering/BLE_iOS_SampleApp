//
//  ADWeightScale.h
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANDDevice.h"

typedef NS_ENUM(NSInteger, ARWeightScaleOrder) {
  WS_DESC,
  WS_ASC
};

@interface ADWeightScale : ANDDevice

@property (nonatomic, strong) NSNumber *measurementID;
@property (nonatomic, strong) NSString *measurementTime;
@property (nonatomic, strong) NSString *measurementReceivedTime;
/**
 * Weight in NSnumber
 */
@property (nonatomic, strong) NSNumber *WSWeight;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSNumber *bmi;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *isManualInput;

- (id) initWithMT: (NSString *) measurementTime
                           MRT: (NSString *) measurementReceivedTime
                        Weight: (NSString *) weight
                          Unit: (NSString *) unit
                           Bmi: (NSString *) bmi
                           UID: (NSString *) UserID
                           isM: (NSString *) isManualInput;

- (id) initWithLatestMeasurement;
//reversed is no longer needed, created a order to combine two method into one
//+ (NSArray *) listOfWSMeasurementReversed;
+ (NSArray *) listOfMeasurement: (ARWeightScaleOrder) order;
+ (NSInteger) count;
+ (NSString *)save: (ADWeightScale *)ws;
- (NSString *)save;
+ (NSInteger) maxValue: (NSString *)value;
+ (NSInteger) minValue: (NSString *)value;
+ (void) deleteMreasurementAt: (NSNumber *) measurementID;
//+ (CGFloat)calculateBMI:(NSNumber *)weight andUnit:(NSString *)unit andPI: (AMPatientInfo *) pi;
+ (void) createTable;
- (NSDictionary *) printProperWeight;
//- (void)putWeightInHealthVault;

- (id)initWithDevice:(ANDDevice *)device;
- (void)pair;
- (void)readMeasurement;
-(void) readMeasurementForSetup;

@end
