//
//  ANDBLEDefines.h
//  BLETester
//
//  Created by Chenchen Zheng on 12/10/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#ifndef BLETester_ANDBLEDefines_h
#define BLETester_ANDBLEDefines_h

#define HealthThermometer_Service                           @"1809"
#define TemperatureMeasurement_Char                         @"2A1C"
#define TemperatureType_Char                                @"2A1D"
#define DateTime_Char                                       @"2A08"

#define Pair_Service                                        @"1801"
#define Pair_Char                                           @"2902"

#define BloodPressure_Service                               @"1810"
#define BloodPressureMeasurement_Char                       @"2A35"
#define BloodPressureMeasurement_Length                     20
#define BloodPressureFeature_Char                           @"2A49"
#define BloodPressureDateTime_Char                          @"2A08"

//#define WeightScale_Service                                 @"18EF"
#define WeightScale_Service                                 @"23434100-1FE4-1EFF-80CB-00FF78297D8B"
//#define WeightScaleMeasurement_Char                         @"2ACF"
//#define WeightScaleFeature_Char                             @"2ACE"
#define WeightScaleMeasurement_Char                        @"23434101-1FE4-1EFF-80CB-00FF78297D8B"
#define WeightScaleFeature_Char                             @"4102"
#define BodyComposition_Service                             @"18EE"
#define BodyCompositionMeasurment_Char                      @"2ACD"
#define BodyCompositionFeature_Char                         @"2ACC"

#define DeviceInformation_Service                           @"180A"
#define ManufacturerNameString_Char                         @"2A29"
#define ModelNumberString_Char                              @"2A24"
#define FirmwareRevisionString_Char                         @"2A26"
#define SoftwareRevisionString_Char                         @"2A28"
#define SystemID_Char                                       @"2A23"

#define Battery_Service                                     @"180F"
#define BatteryLevel_Char                                   @"2A19"
#define BatteryLevel_Length                                 1

#define AND_Service                                         @"233BF000-5A34-1B6D-975C-000D5690ABE4" //service and characteristic is the same...
#define AND_Char                                            @"233BF001-5A34-1B6D-975C-000D5690ABE4"
#define AND_Length                                          20

#define ActivityMonitor_Serivce                             @"ffa0"
#define ActivityMonitorRead_Char                            @"ffa3"
#define ActivityMonitorWrite_Char                           @"ffa1"

#define CurrentTime_Service                                 @"1805"
#define CurrentTime_Char                                    @"2A2B"


#endif
