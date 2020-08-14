//
//  BLECalls.m
//  BLETester
//
//  Created by Chenchen Zheng on 12/10/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "ANDDevice.h"
#import "ANDBLEDefines.h"

@interface ANDDevice ()

@property (strong) NSMutableData *activityData;
@property int dataLength;

@end

@implementation ANDDevice
@synthesize connectionStats;
@synthesize peripherials;
@synthesize activePeripheral;

- (ANDDevice *) init
{
  self.connectionStats = @"disconnected";
  
  return self;
}

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
  self.connectionStats = @"disconnected";
  self.activePeripheral = peripheral;
  return self;
}

- (void) setANDDeviceInformation
{
  NSLog(@"setDeviceInformation");
  char bytes[13];
  bytes[0] = 0x0A;
  bytes[1] = 0x01;
  bytes[2] = 0xA0;
  bytes[3] = 0x30;
  bytes[4] = 0x31;
  bytes[5] = 0x32;
  bytes[6] = 0x33;
  bytes[7] = 0x34;
  bytes[8] = 0x35;
  bytes[9] = 0x36;
  bytes[10] = 0x37;
  bytes[11] = 0x38;
  bytes[12] = 0x39;
  NSData *data = [[NSData alloc] initWithBytes:&bytes length:sizeof(bytes)];
  [self writeValue:[CBUUID UUIDWithString:AND_Service] characteristicUUID:[CBUUID UUIDWithString:AND_Char] p:self.activePeripheral data:data];
}

- (void) readANDDeviceInformation
{
  NSLog(@"read DeviceInformation");
  char bytes[3];
  bytes[0] = 0x02;
  bytes[1] = 0x00;
  bytes[2] = 0xD0
  ;
  NSData *data = [[NSData alloc] initWithBytes:&bytes length:sizeof(bytes)];
  [self writeValue:[CBUUID UUIDWithString:AND_Service]
characteristicUUID:[CBUUID UUIDWithString:AND_Char]
                 p:self.activePeripheral
              data:data];
  [self notification:[CBUUID UUIDWithString:AND_Service]
  characteristicUUID:[CBUUID UUIDWithString:AND_Char]
                   p:self.activePeripheral
                  on:YES];
}

//need set time during pairing
#pragma mark - Write Time Stamp For Blood Pressure
- (void) setTime
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    NSInteger year = components.year;
    NSMutableData *yearData = [[NSMutableData alloc] initWithBytes:&year length:sizeof(year)];
    int year1 = *(int *)[[yearData subdataWithRange:NSMakeRange(0, 1)] bytes];
    int year2 = *(int *)[[yearData subdataWithRange:NSMakeRange(1, 1)] bytes];
    
    //int year1 = 176;
    //int year2 = 8;
    
    int month = components.month;
    
    int day = components.day;
    
    int hour = components.hour;
    
    int min = components.minute;
    
    int second = components.second;
    
    char bytes[7];
    
    bytes[0] = year1;
    
    bytes[1] = year2;
    
    bytes[2] = month;
    
    bytes[3] = day;
    
    bytes[4] = hour;
    
    bytes[5] = min;
    
    bytes[6] = second;
    
    
    NSData *data = [[NSData alloc] initWithBytes:&bytes length:sizeof(bytes)];
    NSLog(@"data is %@", data);
    
    [self writeValue:[CBUUID UUIDWithString: BloodPressure_Service]
  characteristicUUID:[CBUUID UUIDWithString: DateTime_Char]
                   p:self.activePeripheral
                data:data];
    
}
/* ChenChen's old code
 
- (void) setTime
{
  NSLog(@"setTime");
// last year, first year, month, day, hour, mintues, seconds
//  int year1 = 221;
  int year = 13;
  int month = 12;
  int day = 16;
  int hour = 11;
  int min = 45;
  int second = 35;
  
  char bytes[9];
  bytes[0] = 0x08;
  bytes[1] = 0x01;
  bytes[2] = 0x01;
  bytes[3] = year;
  bytes[4] = month;
  bytes[5] = day;
  bytes[6] = hour;
  bytes[7] = min;
  bytes[8] = second;
  
  NSData *data = [[NSData alloc] initWithBytes:&bytes length:sizeof(bytes)];
  NSLog(@"data is %@", data);
  [self writeValue:[CBUUID UUIDWithString: AND_Service]
characteristicUUID:[CBUUID UUIDWithString: AND_Char]
                 p:self.activePeripheral
              data:data];
  
} */

- (void) readDeviceInformation
{
  [self readValue:[CBUUID UUIDWithString:DeviceInformation_Service]
characteristicUUID:[CBUUID UUIDWithString:ManufacturerNameString_Char]
                p:self.activePeripheral];
  [self readValue:[CBUUID UUIDWithString:DeviceInformation_Service]
characteristicUUID:[CBUUID UUIDWithString:ModelNumberString_Char]
                p:self.activePeripheral];
  [self readValue:[CBUUID UUIDWithString:DeviceInformation_Service]
characteristicUUID:[CBUUID UUIDWithString:FirmwareRevisionString_Char]
                p:self.activePeripheral];
  [self readValue:[CBUUID UUIDWithString:DeviceInformation_Service]
characteristicUUID:[CBUUID UUIDWithString:SoftwareRevisionString_Char]
                p:self.activePeripheral];
  [self readValue:[CBUUID UUIDWithString:DeviceInformation_Service]
characteristicUUID:[CBUUID UUIDWithString:SystemID_Char]
                p:self.activePeripheral];
}

- (void)readMeasurementForSetupBp
{

    
    [self notification:[CBUUID UUIDWithString:BloodPressure_Service]
    characteristicUUID:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]
                     p:self.activePeripheral
                    on:YES];
    
}

- (void)readMeasurementForSetupWs
{
    
    
    [self notification:[CBUUID UUIDWithString:WeightScale_Service]
    characteristicUUID:[CBUUID UUIDWithString:WeightScaleMeasurement_Char]
                     p:self.activePeripheral on:YES];

    
}


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
- (void) controlSetup{
  self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}


/*!
 *  @method readBattery:
 *
 *  @param p CBPeripheral to read from
 *
 *  @discussion Start a battery level read cycle from the battery level service
 *
 */
-(void) readBattery:(CBPeripheral *)p {
  //  NSLog(@"readBattery!");
  [self readValue:[CBUUID UUIDWithString: Battery_Service] characteristicUUID: [CBUUID UUIDWithString:BatteryLevel_Char] p:p];
}

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

-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data2 {
  CBService *service = [self findServiceFromUUID:serviceUUID p:p];
  if (!service) {
    NSLog(@"writeValue Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
  if (!characteristic) {
    NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristicUUID],[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  [p writeValue:data2 forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void) writeValue:(NSData *) data serviceUUID:(CBUUID *) serviceUUID characteristicUUID: (CBUUID *) characteristicUUID descriptorUUID: (CBUUID *)descriptorUUID p: (CBPeripheral *) p
{
  CBService *service = [self findServiceFromUUID:serviceUUID p:p];
  if (!service) {
    NSLog(@"writeValue descriptor Could not find service with UUID %s on peripheral with UUID %@\r\n", [self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
  if (!characteristic) {
    NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n", [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID], [p.identifier UUIDString]);
    return;
  }
  CBDescriptor *descriptor = [self findDescriptorFromUUID:descriptorUUID characteristic:characteristic];
  if (! descriptor) {
    NSLog(@"Could not find descriptor with UUID %s on characteristic with UUID %s on service with UUID %s\r\n", [self CBUUIDToString:descriptorUUID], [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID]);
    return;
  }
  NSLog(@"descriptor.uuid %@", descriptor.UUID);
  [p writeValue:data forDescriptor:descriptor];
}


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

-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p {
  CBService *service = [self findServiceFromUUID:serviceUUID p:p];
  if (!service) {
    NSLog(@"readValue Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
  if (!characteristic) {
    NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristicUUID],[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  [p readValueForCharacteristic:characteristic];
}


/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the notfication is set.
 *
 */
-(void) notification:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
  CBService *service = [self findServiceFromUUID:serviceUUID p:p];
  if (!service) {
    NSLog(@"notification Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
  if (!characteristic) {
    NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristicUUID],[self CBUUIDToString:serviceUUID],[p.identifier UUIDString]);
    return;
  }
  [p setNotifyValue:on forCharacteristic:characteristic];
}

/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16
 *
 *  @return Byteswapped UInt16
 */

-(UInt16) swap:(UInt16)s {
  UInt16 temp = s << 8;
  temp |= (s >> 8);
  return temp;
}

/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
  for(int i = 0; i < p.services.count; i++) {
       CBService *s = [p.services objectAtIndex:i];
      if ([p.name rangeOfString:@"A&D_UC-352"].location != NSNotFound)
      {
          if ([self compareCBUUID:s.UUID UUID2:UUID])
          return s;//AJAY
      }
      else
      {
          if ([self compareCBUUID:s.UUID UUID2:UUID])
              return s;
      }

  }
  return nil; //Service not found on this peripheral
}

/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
  char b1[16];
  char b2[16];
  [UUID1.data getBytes:b1];
  [UUID2.data getBytes:b2];
  if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
  else return 0;
}

/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */
-(const char *) CBUUIDToString:(CBUUID *) UUID {
  return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method compareCBUUIDToInt
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UInt16 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUIDToInt compares a CBUUID to a UInt16 representation of a UUID and returns 1
 *  if they are equal and 0 if they are not
 *
 */
-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
  char b1[16];
  [UUID1.data getBytes:b1];
  UInt16 b2 = [self swap:UUID2];
  if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
  else return 0;
}
/*
 *  @method CBUUIDToInt
 *
 *  @param UUID1 UUID 1 to convert
 *
 *  @returns UInt16 representation of the CBUUID
 *
 *  @discussion CBUUIDToInt converts a CBUUID to a Uint16 representation of the UUID
 *
 */
-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
  char b1[16];
  [UUID.data getBytes:b1];
  return ((b1[0] << 8) | b1[1]);
}

/*
 *  @method IntToCBUUID
 *
 *  @param UInt16 representation of a UUID
 *
 *  @return The converted CBUUID
 *
 *  @discussion IntToCBUUID converts a UInt16 UUID to a CBUUID
 *
 */
-(CBUUID *) IntToCBUUID:(UInt16)UUID {
  char t[16];
  t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
  NSData *data2 = [[NSData alloc] initWithBytes:t length:16];
  return [CBUUID UUIDWithData:data2];
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
     NSLog(@"the base characteristics to be compared is  %s \n",[self CBUUIDToString:UUID]);
  for(int i=0; i < service.characteristics.count; i++) {
    CBCharacteristic *c = [service.characteristics objectAtIndex:i];
      
if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
  }
  return nil; //Characteristic not found on this service
}

- (CBDescriptor *) findDescriptorFromUUID:(CBUUID *)UUID characteristic:(CBCharacteristic *) characteristic
{
  for (int i = 0 ; i < characteristic.descriptors.count; i++) {
    CBDescriptor *d = [characteristic.descriptors objectAtIndex:i];
    if ([self compareCBUUID:d.UUID UUID2:UUID]) {
      return d;
    }
  }
  return  nil;
}




//----------------------------------------------------------------------------------------------------
//
//
//
//
//CBCentralManagerDelegate protocol methods beneeth here
// Documented in CoreBluetooth documentation
//
//
//
//
//----------------------------------------------------------------------------------------------------
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  NSLog(@"Status of CoreBluetooth central manager changed %ld (%s)\r\n",central.state,[self centralManagerStateToString:central.state]);
    if (_shouldScan)
        [self performSelector:@selector(findBLEPeripherals) withObject:nil];
}

/*!
 *  @method centralManagerStateToString:
 *
 *  @param state State to print info of
 *
 *  @discussion centralManagerStateToString prints information text about a given CBCentralManager state
 *
 */
- (const char *) centralManagerStateToString: (int)state{
  switch(state) {
    case CBCentralManagerStateUnknown:
      return "State unknown (CBCentralManagerStateUnknown)";
    case CBCentralManagerStateResetting:
      return "State resetting (CBCentralManagerStateUnknown)";
    case CBCentralManagerStateUnsupported:
      return "State BLE unsupported (CBCentralManagerStateResetting)";
    case CBCentralManagerStateUnauthorized:
      return "State unauthorized (CBCentralManagerStateUnauthorized)";
    case CBCentralManagerStatePoweredOff:
      return "State BLE powered off (CBCentralManagerStatePoweredOff)";
    case CBCentralManagerStatePoweredOn:
      return "State powered up and ready (CBCentralManagerStatePoweredOn)";
    default:
      return "State unknown";
  }
  return "Unknown state";
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"didDiscoverPeripheral: %@\r\n", peripheral.name);
    NSLog(@"the advertisement data is: %@\r\n", advertisementData);
    
   
    
//  NSString *deviceName = @"A&D BLE Pedometer";
//  NSString *deviceName2 = @"A&D Pedometer";
//  NSString *deviceName3 = @"A&D BLP";
//  NSString *deviceName4 = @"MurataHTP";
//  NSString *deviceName5 = @"A&D_UC-352BLE_1DF7F";
//  NSLog(@"I got peripheral name! %@", peripheral.name);
//  if ([peripheral.name rangeOfString:deviceName].location != NSNotFound ||
//      [peripheral.name rangeOfString:deviceName2].location != NSNotFound ||
//      [peripheral.name rangeOfString:deviceName3].location != NSNotFound ||
//      [peripheral.name rangeOfString:deviceName4].location != NSNotFound ||
//      [peripheral.name rangeOfString:deviceName5].location != NSNotFound) {
//    [self connectPeripheral:peripheral];
//    NSLog(@"Found %@, connecting..\n",deviceName);
//  } else {
//    NSLog(@"Peripheral not a keyfob or callback was not because of a ScanResponse\n");
//  }
    [self.delegate gotDevice:peripheral withAdvertisementData:advertisementData];
  
  
}

/*!
 *  @method connectPeripheral:
 *
 *  @param p Peripheral to connect to
 *
 *  @discussion connectPeripheral connects to a given peripheral and sets the activePeripheral property of TIBLECBKeyfob.
 *
 */

- (void) connectPeripheral:(CBPeripheral *)peripheral {
  NSLog(@"Connecting to peripheral with UUID : %@\r\n",[peripheral.identifier UUIDString]);
  self.activePeripheral = peripheral;
  self.activePeripheral.delegate = self;
  [self.CM connectPeripheral:self.activePeripheral options:nil];
  self.connectionStats = @"Connecting..";
  _shouldScan = YES;
  [self.CM stopScan];
}

//+ (void) connectPeripheral:(CBPeripheral *)peripheral {
//  NSLog(@"Connecting to peripheral with UUID : %@\r\n",[peripheral.identifier UUIDString]);
//  ANDDevice *device = [[ANDDevice alloc] initWithPeripheral:peripheral];
//  device.activePeripheral.delegate = self;
////  self.activePeripheral = peripheral;
////  self.activePeripheral.delegate = self;
//  [self.CM connectPeripheral:self.activePeripheral options:nil];
//  self.connectionStats = @"Connecting..";
//}



- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  NSLog(@"Connection to peripheral with UUID : %@ successful\r\n",[peripheral.identifier UUIDString]);
  self.activePeripheral = peripheral;
  [self.activePeripheral discoverServices:nil];
  self.connectionStats = @"Connected";
  _shouldScan = YES;
  [central stopScan];
}

//----------------------------------------------------------------------------------------------------
//
//
//
//
//
//CBPeripheralDelegate protocol methods beneeth here
//
//
//
//
//
//----------------------------------------------------------------------------------------------------


/*
 *  @method didDiscoverCharacteristicsForService
 *
 *  @param peripheral Pheripheral that got updated
 *  @param service Service that characteristics where found on
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverCharacteristicsForService is called when CoreBluetooth has discovered
 *  characteristics on a service, on a peripheral after the discoverCharacteristics routine has been called on the service
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  if (!error) {
    NSLog(@"Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
    for(int i=0; i < service.characteristics.count; i++) {
      CBCharacteristic *c = [service.characteristics objectAtIndex:i];
      NSLog(@"Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
      [peripheral discoverDescriptorsForCharacteristic:c];
    }
  }
  else {
    NSLog(@"Characteristic discorvery unsuccessful !\r\n");
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (!error) {
    NSLog(@"Descriptors of Characteristic withUUID : %s found\r\n", [self CBUUIDToString:characteristic.UUID]);
    for (int i = 0; i < [characteristic.descriptors count]; i++) {
      CBDescriptor *d = [characteristic.descriptors objectAtIndex:i];
      NSLog(@"Found descriptor %s\r\n", [self CBUUIDToString:d.UUID]);
    }
    CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
    CBCharacteristic *c = [s.characteristics objectAtIndex:(s.characteristics.count - 1)];

      if([peripheral.name hasPrefix:@"UA-1101BLE"] || [peripheral.name hasPrefix:@"UB-1101BLE"] ||
         [peripheral.name hasPrefix:@"UA-1200BLE"] || [peripheral.name hasPrefix:@"UB-1100BLE"]) {
          NSLog(@"Sim, enter case of UB-1100 device");
          [self.delegate deviceReady];
          
      } else {
          if([self compareCBUUID:characteristic.UUID UUID2:c.UUID]) {
            NSLog(@"Finished discovering characteristics now set time");
          //  [self.delegate deviceReady];
              [self.delegate devicesetTime];
          }
      }


  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
  
}

/*
 *  @method didDiscoverServices
 *
 *  @param peripheral Pheripheral that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverServices is called when CoreBluetooth has discovered services on a
 *  peripheral after the discoverServices routine has been called on the peripheral
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  if (!error) {
    NSLog(@"Services of peripheral with UUID : %@ found\r\n",[peripheral.identifier UUIDString]);
    [self getAllCharacteristicsFromDevice:peripheral];
  }
  else {
    NSLog(@"Service discovery was unsuccessful ! %@\r\n", error);
  }
}

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
- (int) findBLEPeripherals {
  NSLog(@"findBLEPeripherals %ld", self.CM.state);
  _shouldScan = YES;
    if (self.CM.state  == CBCentralManagerStatePoweredOn) {
        [self.CM scanForPeripheralsWithServices:nil options:nil];
    }
  self.connectionStats = @"Scanning";

  return 0; // Started scanning OK !

//  if (self.CM.state  != CBCentralManagerStatePoweredOn) {
//    NSLog(@"CoreBluetooth not correctly initialized !\r\n");
//    NSLog(@"State = %d (%s)\r\n",self.CM.state,[self centralManagerStateToString:self.CM.state]);
//    return -1;
//
}

/*
 *  @method getAllServicesFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllServicesFromKeyfob starts a service discovery on a peripheral pointed to by p.
 *  When services are found the didDiscoverServices method is called
 *
 */
-(void) getAllServicesFromDevice:(CBPeripheral *)p{
  self.connectionStats = @"Discovering services..";
  [p discoverServices:nil]; // Discover all services without filter
}

/*
 *  @method getAllCharacteristicsFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *
 *  @discussion getAllCharacteristicsFromKeyfob starts a characteristics discovery on a peripheral
 *  pointed to by p
 *
 */
-(void) getAllCharacteristicsFromDevice:(CBPeripheral *)p{
  self.connectionStats = @"Discovering characteristics..";
  for (int i=0; i < p.services.count; i++) {
    CBService *s = [p.services objectAtIndex:i];
    NSLog(@"Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
    [p discoverCharacteristics:nil forService:s];
  }
}

/*
 *  @method didUpdateNotificationStateForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateNotificationStateForCharacteristic is called when CoreBluetooth has updated a
 *  notification state for a characteristic
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (!error) {
    NSLog(@"Sim trial Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[peripheral.identifier UUIDString]);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]]) {
      self.data = [[NSData alloc] initWithData:characteristic.value];
       NSLog(@"data is %@", self.data);
        if ([self.delegate respondsToSelector:@selector(disconnectPeripheral:)])
        {
            NSLog(@"Test, entering the disconnect Peripheral");
             [self.delegate disconnectPeripheral:peripheral];
        }
     
    
     }
  }
  else {
    NSLog(@"Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[peripheral.identifier UUIDString]);
    NSLog(@"Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
  }
  
}

/*
 *  @method didUpdateValueForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateValueForCharacteristic is called when CoreBluetooth has updated a
 *  characteristic for a peripheral. All reads and notifications come here to be processed.
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  //  UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
  CBUUID *charUUID = characteristic.UUID;
    NSLog(@"entered didUpdateValueForChar");
    NSLog(@"charUUID is %@", charUUID);
    NSLog(@"charValue is %@", characteristic.value);
    NSLog(@"error is %@", error);
  if (!error) {
    if ([charUUID isEqual:[CBUUID UUIDWithString:ManufacturerNameString_Char]]) {
      NSString* manufacturer = [NSString stringWithUTF8String:[characteristic.value bytes]];
      NSLog(@"Manufacturer: %@", manufacturer);
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:ModelNumberString_Char]]) {
      NSString *modelNumber = [NSString stringWithUTF8String:[characteristic.value bytes]];
      NSLog(@"Model Number: %@", modelNumber);
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:FirmwareRevisionString_Char]]) {
      NSString *firmware = [NSString stringWithUTF8String:[characteristic.value bytes]];
      NSLog(@"Firmware: %@", firmware);
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:SoftwareRevisionString_Char]]) {
      NSString *software = [NSString stringWithUTF8String:[characteristic.value bytes]];
      NSLog(@"Software: %@", software);
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:SystemID_Char]]) {
      NSString *systemID = [NSString stringWithUTF8String:[characteristic.value bytes]];
      NSLog(@"System ID: %@", systemID);
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:BatteryLevel_Char]]) {
      char batlevel;
      [characteristic.value getBytes:&batlevel length:BatteryLevel_Length];
      self.batteryLevel = (float)batlevel;
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]]) {
      NSLog(@"got Blood Pressure Measurement char");
      NSData *bpmData = [[NSData alloc] initWithData:characteristic.value];
      self.data = [[NSData alloc] initWithData:characteristic.value];
      
        if (bpmData.length >= 12) { //If time has been set during pairing
            NSLog(@"Enter case of length of data greater than 12");
            int flag = *(int *)[[self.data subdataWithRange:NSMakeRange(0, 1)] bytes];
            
            int sys = *(int *)[[self.data subdataWithRange:NSMakeRange(1, 2)] bytes];
            
            int dia = *(int *)[[self.data subdataWithRange:NSMakeRange(3, 2)] bytes];
            
            int mean = *(int *)[[self.data subdataWithRange:NSMakeRange(5, 2)] bytes];
            
            int year = *(int *)[[self.data subdataWithRange:NSMakeRange(7, 2)] bytes];
            
            int month = *(int *)[[self.data subdataWithRange:NSMakeRange(9, 1)] bytes];
            
            int day = *(int *)[[self.data subdataWithRange:NSMakeRange(10, 1)] bytes];
            
            int hour = *(int *)[[self.data subdataWithRange:NSMakeRange(11, 1)] bytes];
            
            int minutes = *(int *)[[self.data subdataWithRange:NSMakeRange(12, 1)] bytes];
            
            int seconds = *(int *)[[self.data subdataWithRange:NSMakeRange(13, 1)] bytes];
            
            int pul = *(int *)[[self.data subdataWithRange:NSMakeRange(14, 2)] bytes];
            NSMutableDictionary *bp_data = [NSMutableDictionary new];
            [bp_data setValue:[NSNumber numberWithInteger:sys] forKey:@"systolic"];
            [bp_data setValue:[NSNumber numberWithInteger:dia] forKey:@"diastolic"];
            [bp_data setValue:[NSNumber numberWithInteger:pul] forKey:@"pulse"];
            [bp_data setValue:[NSNumber numberWithInteger:mean] forKey:@"mean"];
         //   [self.delegate gotBloodPressure:bp_data];
            NSLog(@"sys %d dia %d pul %d mean %d", sys, dia, pul, mean);
            
            
        } else { //If time has not been set then do the below
            NSLog(@"Enter case of data less than length");
            int sys = *(int *)[[self.data subdataWithRange:NSMakeRange(1, 1)] bytes];
            int dia = *(int *)[[self.data subdataWithRange:NSMakeRange(3, 1)] bytes];
            int pul = *(int *)[[self.data subdataWithRange:NSMakeRange(7, 1)] bytes];
            int mean = *(int *)[[self.data subdataWithRange:NSMakeRange(5, 1)] bytes];
            NSMutableDictionary *data = [NSMutableDictionary new];
            [data setValue:[NSNumber numberWithInteger:sys] forKey:@"systolic"];
            [data setValue:[NSNumber numberWithInteger:dia] forKey:@"diastolic"];
            [data setValue:[NSNumber numberWithInteger:pul] forKey:@"pulse"];
            [data setValue:[NSNumber numberWithInteger:mean] forKey:@"mean"];
         //   [self.delegate gotBloodPressure:data];
            NSLog(@"sys %d dia %d pul %d mean %d", sys, dia, pul, mean);
        }
    
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:WeightScaleMeasurement_Char]]) {
      NSLog(@"Weight is %@", characteristic.value);
      NSMutableDictionary *data = [NSMutableDictionary new];
      NSData *weightData = [[NSData alloc] initWithData:characteristic.value];
        if (weightData.length > 3) {
            int unit = *(int *)[[weightData subdataWithRange:NSMakeRange(0, 1)] bytes];
            int value = *(int *)[[weightData subdataWithRange: NSMakeRange(1, 2)] bytes];
            
            int year = *(int *)[[weightData subdataWithRange:NSMakeRange(3, 2)] bytes];
            int month = *(int *)[[weightData subdataWithRange:NSMakeRange(5, 1)] bytes];
            int day = *(int *)[[weightData subdataWithRange:NSMakeRange(6, 1)] bytes];
            int hour = *(int *)[[weightData subdataWithRange:NSMakeRange(7, 1)] bytes];
            int minutes = *(int *)[[weightData subdataWithRange:NSMakeRange(8, 1)] bytes];
            int seconds = *(int *)[[weightData subdataWithRange:NSMakeRange(9, 1)] bytes];
            if (unit == 0 || unit == 2) {
                NSLog(@"unit is kg");
                [data setValue:@"kg" forKey:@"unit"];
            } else if (unit == 1 || unit == 3) {
                NSLog(@"unit is lb");
                [data setValue:@"lb" forKey:@"unit"];
            }
            NSNumber* weightValue= [NSNumber numberWithInteger:value];
            NSLog(@"Sim, the weight Value is %@", weightValue);
            [data setValue:weightValue forKey:@"weight"];
            [data setValue:[NSDate new] forKey:@"time"];
            [self.delegate gotWeight:data];
        } else {
            NSLog(@"Sim, unit coming in without a date and time stamp");
            int unit = *(int *)[[weightData subdataWithRange:NSMakeRange(0, 1)] bytes];
            if (unit == 0) {
                NSLog(@"unit is kg");
                [data setValue:@"kg" forKey:@"unit"];
            } else if (unit == 1) {
                NSLog(@"unit is lb");
                [data setValue:@"lb" forKey:@"unit"];
            }
            int value = *(int *)[[weightData subdataWithRange: NSMakeRange(1,2)] bytes];
            NSNumber* weightValue= [NSNumber numberWithInteger:value];
            NSLog(@"Sim, the weight Value without time stamp is %@", weightValue);
            [data setValue:weightValue forKey:@"weight"];
            [data setValue:[NSDate new] forKey:@"time"];
            [self.delegate gotWeight:data];
        }
      
    }else if ([charUUID isEqual:[CBUUID UUIDWithString:DateTime_Char]]) {
      NSData *date = [[NSData alloc] initWithData:characteristic.value];
      int year = *(int *)[[date subdataWithRange:NSMakeRange(0, 2)] bytes];
      int month = *(int *)[[date subdataWithRange:NSMakeRange(2, 1)] bytes];
      int day = *(int *)[[date subdataWithRange:NSMakeRange(3, 1)] bytes];
      int hour = *(int *)[[date subdataWithRange:NSMakeRange(4, 1)] bytes];
      int minutes = *(int *)[[date subdataWithRange:NSMakeRange(5, 1)] bytes];
      int seconds = *(int *)[[date subdataWithRange:NSMakeRange(6, 1)] bytes];
      NSLog(@"year %d month %d day %d hour %d minutes %d second %d", year, month, day, hour, minutes, seconds);
      NSDateComponents *components = [[NSDateComponents alloc] init];
      [components setYear:year];
      [components setMonth:month];
      [components setDay:day];
      [components setHour:hour];
      [components setMinute:minutes];
      [components setSecond:seconds];
      NSCalendar *calendar = [NSCalendar currentCalendar];
      self.time = [calendar dateFromComponents:components];
    } else if ([charUUID isEqual:[CBUUID UUIDWithString:ActivityMonitorRead_Char]]) {
      NSLog(@"got Activity Data");
      if (self.activityData == nil) {
        self.activityData = [[NSMutableData alloc] initWithData:characteristic.value];
        NSData *data = [[NSData alloc] initWithData:characteristic.value];
        self.dataLength = *(int *)[[data subdataWithRange:NSMakeRange(0, 2)] bytes];
        NSLog(@"data length is %d", self.dataLength);
        //get the checksum and start grabing data...
      } else {
        NSLog(@"activityData.length is %lu", (unsigned long)self.activityData.length);
        [self.activityData appendData:characteristic.value];
        if (self.dataLength <= self.activityData.length) {
          NSLog(@"got full packet because datalength = %d and activityData.length = %lu", self.dataLength, (unsigned long)self.activityData.length);
          NSData *final = [[NSData alloc] initWithData:self.activityData];
          self.activityData = nil;
          self.dataLength = 0;
          [self.delegate gotActivity:final];
        }
      }
    }
  } else {
    NSLog(@"updateValueForCharacteristic failed !");
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
  NSLog(@"didUpdateValueForDescriptor called!");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  NSLog(@"didWriteValueForCharacteristic called!");
    if ([peripheral.name rangeOfString:@"A&D"].location != NSNotFound) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DateTime_Char]])  {
            NSLog(@"Case of set time while taking measurement ") ;
            [self.delegate deviceReady];
          /*  if ([self.delegate respondsToSelector:@selector(devicesetBuffer)]) {
                NSLog(@"Sim, calling the set buffer command during pairing");
                [self.delegate devicesetBuffer];
            }  else {
                NSLog(@"Sim, case of set time while taking measurement ") ;
                [self.delegate deviceReady];
                      
            }*/
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:AND_Char ]]) {
            NSLog(@"Successfully wrote the buffer for the custom char now enable notification");
            [self.delegate deviceReady];
        }
    }
    
    //Check for time
    //Check for buffer
    //Last call the deviceReady with only notification
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
  NSLog(@"didWriteValueFOrDescriptor called!");
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
  NSLog(@"peripheralDidupdateRSSI called!");
}

- (void) disconnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"Called the disconnect peripheral device in device");
    //Reset the connection device type
    [self.CM cancelPeripheralConnection:peripheral];
    _shouldScan = NO;
    [self.CM stopScan];
}




@end
