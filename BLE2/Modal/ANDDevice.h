//
//  BLECalls.h
//  BLETester
//
//  Created by Chenchen Zheng on 12/10/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol  ANDDeviceDelegate <NSObject>
@optional
- (void) deviceReady;
- (void) gotWeight:(NSDictionary *) data;
- (void) gotBloodPressure:(NSDictionary *)data;
- (void) gotDevice:(CBPeripheral *)peripheral;
- (void) gotActivity:(NSData *)data;


@end
@interface ANDDevice : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) float batteryLevel;

@property (nonatomic, weak) id <ANDDeviceDelegate> delegate;
@property (nonatomic) NSMutableArray *peripherials;
@property (nonatomic) CBCentralManager *CM;
@property (nonatomic) CBPeripheral *activePeripheral;
@property (nonatomic) NSData *data;
@property (nonatomic) NSDate *time;

@property (nonatomic) NSString *connectionStats;

- (id) initWithPeripheral:(CBPeripheral *)peripheral;

- (void) readDeviceInformation;
- (void) readANDDeviceInformation;
- (void) writeANDDeviceInformation;
- (void) setTime;
- (void)readMeasurementForSetupBp;
- (void)readMeasurementForSetupWs;
/*!
 *  @method controlSetup:
 *
 *  @param s Not used
 *
 *  @return Allways 0 (Success)
 *
 *  @discussion controlSetup enables CoreBluetooths Central Manager and sets delegate to TIBLECBKeyfob class
 *
 */
- (void) controlSetup;


-(void) readBattery:(CBPeripheral *)p;


/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, value is written. If not nothing is done.
 *
 */
-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;

/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */
-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p;

/*!
 *  @method notification:
 *
 *  @param serviceUUID S
 ervice UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the notfication is set.
 *
 */
-(void) notification:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;

//-(void) turnOffNotifyWithService: (NSString *) serviceUUID andCharacteristic: (NSString *) characteristicUUID toPeripheral: (CBPeripheral *)p;

/*!
 *  @method findBLEPeripherals:
 *
 *  @param timeout timeout in seconds to search for BLE peripherals
 *
 *  @return 0 (Success), -1 (Fault)
 *
 *  @discussion findBLEPeripherals searches for BLE peripherals and sets a timeout when scanning is stopped
 *
 */
- (int) findBLEPeripherals;


- (void) writeValue:(NSData *) data serviceUUID:(CBUUID *) serviceUUID characteristicUUID: (CBUUID *) characteristicUUID descriptorUUID: (CBUUID *)descriptorUUID p: (CBPeripheral *) p;


- (void) connectPeripheral:(CBPeripheral *)peripheral;

@end
