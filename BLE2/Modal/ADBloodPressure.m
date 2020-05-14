//
//  ADBloodPressure.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADBloodPressure.h"
#import "WCSQLite.h"
#import "ANDBLEDefines.h"


@implementation ADBloodPressure
@synthesize measurementID = _measurementID;
@synthesize measurementTime = _measurementTime;
@synthesize measurementReceivedTime = _measurementReceivedTime;
@synthesize systolic = _systolic;
@synthesize diastolic = _diastolic;
@synthesize WCPulse = _WCPulse;
@synthesize map = _map;
@synthesize userID = _userID;
@synthesize isManualInput = _isManualInput;

- (id) initwithObject: (id) object
{
  _measurementTime = [object objectForKey:@"measurementTime"];
  
  return self;
}
//'MeasurementTime', 'MeasurementReceivedTime','Systolic', 'Diastolic', 'Pulse', 'UserID', 'isManualInput'
- (id) initWithMT: (NSString *) measurementTime MRT: (NSString *) measurementReceivedTime Sys:(NSString *)Systolic Dia:(NSString *)Diastolic Pul:(NSString *)Pulse UID: (NSString *) UserID isM: (NSString *)isManualInput
{
  _measurementTime = measurementTime;
  _measurementReceivedTime = measurementReceivedTime;
  _systolic = [NSNumber numberWithInt:[Systolic intValue]];
  _diastolic = [NSNumber numberWithInt:[Diastolic intValue]];
  _WCPulse = [NSNumber numberWithInt:[Pulse intValue]];
  _userID = [NSNumber numberWithInt:[UserID intValue]];
  _isManualInput = [NSNumber numberWithInt:[isManualInput intValue]];
  
  return self;
}
//  'BloodPressureMeasurements'
//  'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,     0
//  'MeasurementTime' TEXT,                                         1
//  'MeasurementReceivedTime' TEXT,                                 2
//  'Systolic' INTEGER,                                             3
//  'Diastolic' INTEGER,                                            4
//  'PULSE' INTEGER,                                                5
//  'MAP' INTEGER,                                                  6
//  'UserID' INTEGER,                                               7
//  'isManualInput' INTEGER                                         8
- (id) initWithLatestMeasurement
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM BloodPressureMeasurements order by measurementID DESC LIMIT 1;"];
  sqlite3_stmt *statement;
  
  if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil) == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
      int field1 = sqlite3_column_int(statement, 0);
      _measurementID = [NSNumber numberWithInt:field1];
      
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      _measurementTime = [[NSString alloc]initWithUTF8String:field2];
      
      char *field3 = (char *) sqlite3_column_text(statement, 2);
      _measurementReceivedTime= [[NSString alloc]initWithUTF8String:field3];
      
      int field4 = (float) sqlite3_column_double(statement, 3);
      _systolic = [NSNumber numberWithInt:field4];
      
      int field5 = sqlite3_column_int(statement, 4);
      _diastolic = [NSNumber numberWithInt:field5];
      
      int field6 = sqlite3_column_int(statement, 5);
      _WCPulse = [NSNumber numberWithInt:field6];
      
      int field7 = sqlite3_column_int(statement, 6);
      _map = [NSNumber numberWithInt:field7];
      
      int field8 = sqlite3_column_int(statement, 7);
      _userID = [NSNumber numberWithInt:field8];
      
      int field9 = sqlite3_column_int(statement, 8);
      _isManualInput = [NSNumber numberWithBool:field9];
    }
  }
  return self;
}

//descMeasurementsByDateFromSQLite
//  'BloodPressureMeasurements'
//  'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,     0
//  'MeasurementTime' TEXT,                                         1
//  'MeasurementReceivedTime' TEXT,                                 2
//  'Systolic' INTEGER,                                             3
//  'Diastolic' INTEGER,                                            4
//  'PULSE' INTEGER,                                                5
//  'MAP' INTEGER,                                                  6
//  'UserID' INTEGER,                                               7
//  'isManualInput' INTEGER                                         8
+ (NSArray *) listOfMeasurement:(ADBPOrder) order
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSMutableArray *listOfMeasurements = [[NSMutableArray alloc]initWithCapacity: [ADBloodPressure count]];
  
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM BloodPressureMeasurements order by MeasurementTime %@;" , (order == DESC) ? @"DESC" : @"ASC"];
  sqlite3_stmt *statement;
  if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil) == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
      int measurementID = sqlite3_column_int(statement, 0);
      char* time = (char *)sqlite3_column_text(statement, 1);
      char* time2 = (char *)sqlite3_column_text(statement, 2);
      int systolic = sqlite3_column_int(statement, 3);
      int diastolic = sqlite3_column_int(statement, 4);
      int pulse = sqlite3_column_int(statement, 5);
      //      int map = sqlite3_column_int(statement, 6);
      int isManualInput = sqlite3_column_int(statement, 7);
      
      NSString *displayTime = [[NSString alloc]initWithUTF8String:time];
      NSString *receivedTime = [[NSString alloc] initWithUTF8String:time2];
      ADBloodPressure *bp = [[ADBloodPressure alloc] init];
      bp.measurementID = [NSNumber numberWithInt:measurementID];
      bp.measurementReceivedTime = receivedTime;
      bp.measurementTime = displayTime;
      bp.systolic = [NSNumber numberWithInt:systolic];
      bp.diastolic = [NSNumber numberWithInt:diastolic];
      bp.WCPulse = [NSNumber numberWithInt:pulse];
      bp.isManualInput = [NSNumber numberWithInt:isManualInput];
      [listOfMeasurements addObject:bp];
    }
  }
  NSArray *result = [NSArray arrayWithArray:listOfMeasurements];
  return result;
}

+ (void) deleteMreasurementAt: (NSNumber *) measurementID
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  
  NSString *quary = [NSString stringWithFormat:@"DELETE FROM BloodPressureMeasurements WHERE MeasurementID=%@;", measurementID];
  NSLog(@"quary is %@", quary);
  sqlite3_stmt *statement;
  if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil) == SQLITE_OK) {
    // Loop through the results and add them to the feeds array
    while(sqlite3_step(statement) == SQLITE_ROW) {
      // Read the data from the result row
      NSLog(@"result is here");
    }
    
  }
}
/*
 * Simple debugging info.
 */
- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ ADBP: %@ %@ %@", self.measurementTime, self.systolic, self.diastolic, self.WCPulse];
}

+ (NSInteger)count
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT count(*) FROM BloodPressureMeasurements"];
  sqlite3_stmt *statement;
  if(sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
    while (sqlite3_step(statement)==SQLITE_ROW) {
      result = sqlite3_column_int(statement, 0);
    }
    }
  //  NSLog(@"BP count is %d", result);
  return result;
}

+ (NSInteger)maxValue:(NSString *)value
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT MAX(%@) FROM BloodPressureMeasurements", value];
  sqlite3_stmt *statement;
  if(sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
    while (sqlite3_step(statement)==SQLITE_ROW) {
      result = sqlite3_column_int(statement, 0);
    }
    }
  //  NSLog(@"WCBP maxValue is %d", result);
  return result;
}

+ (NSInteger)minValue:(NSString *)value
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT MIN(%@) FROM BloodPressureMeasurements", value];
  sqlite3_stmt *statement;
  if(sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
    while (sqlite3_step(statement)==SQLITE_ROW) {
      result = sqlite3_column_int(statement, 0);
    }
    }
  //  NSLog(@"WCBP minValue is %d", result);
  return result;
}

+ (NSString *)save: (ADBloodPressure *)bp
{
  //  do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  //  'BloodPressureMeasurements'
  //  'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,     0
  //  'MeasurementTime' TEXT,                                         1
  //  'MeasurementReceivedTime' TEXT,                                 2
  //  'Systolic' INTEGER,                                             3
  //  'Diastolic' INTEGER,                                            4
  //  'PULSE' INTEGER,                                                5
  //  'MAP' INTEGER,                                                  6
  //  'UserID' INTEGER,                                               7
  //  'isManualInput' INTEGER                                         8
  NSString *sql = [NSString stringWithFormat:@" INSERT INTO BloodPressureMeasurements ('MeasurementTime', 'MeasurementReceivedTime','Systolic', 'Diastolic', 'Pulse', 'UserID', 'isManualInput') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@');", bp.measurementTime, bp.measurementReceivedTime, bp.systolic, bp.diastolic, bp.WCPulse, bp.userID, bp.isManualInput];
//  if ([[HVClient current] isAppCreated]) {
//    [bp putBPInHealthVault];
//  }
  char *err;
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
    sqlite3_close(db);
    NSAssert(0, @"Cloud not update table");
    return @"save: Cloud not update table";
  }else {
    return @"save: Table Updated";
  }
}

- (NSString *) save
{
  //  do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *sql = [NSString stringWithFormat:@" INSERT INTO BloodPressureMeasurements ('MeasurementTime', 'MeasurementReceivedTime','Systolic', 'Diastolic', 'Pulse', 'UserID', 'isManualInput') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@');", self.measurementTime, self.measurementReceivedTime, self.systolic, self.diastolic, self.WCPulse, self.userID, self.isManualInput];
//  if ([[HVClient current] isAppCreated]) {
//    [self putBPInHealthVault];
//  }
  char *err;
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
    sqlite3_close(db);
    NSAssert(0, @"Cloud not update table");
    return @"save: Cloud not update table";
  }else {
    return @"save: Table Updated";
  }
}


+ (void) createTable
{
  //  do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS 'BloodPressureMeasurements' ( 'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'MeasurementTime' TEXT, 'MeasurementReceivedTime' TEXT, 'Systolic' INTEGER, 'Diastolic' INTEGER, 'PULSE' INTEGER, 'MAP' INTEGER, 'UserID' INTEGER, 'isManualInput' INTEGER);"];
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
    sqlite3_close(db);
    NSAssert(0, @"Could not create BP table");
  } else {
    NSLog(@"BP table created");
  }
}

//- (void) putBPInHealthVault
//{
//  HVItem *item = [HVBloodPressure newItem];
//  HVNonNegativeInt *sys = [[HVNonNegativeInt alloc] initWith:[self.systolic intValue]];
//  HVNonNegativeInt *dia = [[HVNonNegativeInt alloc] initWith:[self.diastolic intValue]];
//  HVNonNegativeInt *pul = [[HVNonNegativeInt alloc] initWith:[self.WCPulse intValue]];
//  item.bloodPressure.systolic = sys;
//  item.bloodPressure.diastolic = dia;
//  item.bloodPressure.pulse = pul;
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//  NSDate * date = [dateFormatter dateFromString:self.measurementTime];
//  item.bloodPressure.when = [[HVDateTime alloc] initWithDate:date];
//  
//  [[HVClient current].currentRecord putItem:item callback:^(HVTask *task)
//   {
//   @try {
//     //
//     // Throws if there was a failure. Look at HVServerException for details
//     //
//     [task checkSuccess];
//     //
//     // Refresh with the latest list of weights from HealthVault
//     //
//     //     [self getWeightsFromHealthVault];
//   }
//   @catch (NSException *exception) {
//     [HVUIAlert showInformationalMessage:exception.description];
//   }
//   } ];
//}

#pragma mark - BLE
-(id)initWithDevice:(ANDDevice *)device
{
  self = [super init];
  if (self) {
    self.activePeripheral = device.activePeripheral;
    self.CM = device.CM;
  }
  return self;
}

- (void)pair
{
  
  const unsigned char bytes[] = {0x02, 0x00};
  NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
  [self writeValue: data
       serviceUUID: [CBUUID UUIDWithString:BloodPressure_Service]
characteristicUUID: [CBUUID UUIDWithString:BloodPressureMeasurement_Char]
    descriptorUUID: [CBUUID UUIDWithString:Pair_Char]
                 p: self.activePeripheral];
  //  [self writeValue:[CBUUID UUIDWithString:AND_Service]
  //characteristicUUID:[CBUUID UUIDWithString:AND_Char]
  //                 p:self.activePeripheral
  //              data:data];
  
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


//need set time during pairing

- (void)readMeasurement
{
  //
  NSLog(@"bp readMeasurment");
        [self readValue:[CBUUID UUIDWithString:BloodPressure_Service]
 characteristicUUID:[CBUUID UUIDWithString:DateTime_Char]
                  p:self.activePeripheral];
    
    [self notification:[CBUUID UUIDWithString:BloodPressure_Service]
    characteristicUUID:[CBUUID UUIDWithString:DateTime_Char]
                     p:self.activePeripheral
                    on:YES];
    
    [self readValue:[CBUUID UUIDWithString:BloodPressure_Service]
 characteristicUUID:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]
                  p:self.activePeripheral];
    
    [self notification:[CBUUID UUIDWithString:BloodPressure_Service]
    characteristicUUID:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]
                     p:self.activePeripheral
                    on:YES];
 
  
}

- (void)readMeasurementForSetup
{
    NSLog(@"Enter readMeasurementForSetup to enable notification");
    [self notification:[CBUUID UUIDWithString:BloodPressure_Service]
    characteristicUUID:[CBUUID UUIDWithString:BloodPressureMeasurement_Char]
                     p:self.activePeripheral
                    on:YES];
    
}
- (void)setTimeOfCurrentTimeService {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [calendar components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    UInt8 value[10] = {0x00};
    NSInteger index = 0;
    value[index++] = [comp year];
    value[index++] = ([comp year] >> 8);
    value[index++] = [comp month];
    value[index++] = [comp day];
    value[index++] = [comp hour];
    value[index++] = [comp minute];
    value[index++] = [comp second];
    // OS Format
    // 1=sun ..... 7=sat  0=unknown
    NSInteger weekDay = comp.weekday;
    // DayOfWeek Format
    // 1=mon ..... 7=sun  0=unknown
    if (weekDay == 0) {
        value[index++] = weekDay;
    }
    else if (weekDay == 1) {
        value[index++] = 7;
    }
    else {
        weekDay -= 1;
        value[index++] = weekDay;
    }
    
    NSData *data = [[NSData alloc] initWithBytes:&value length:sizeof(value)];
    NSLog(@"data is %@", data);
    
    [self writeValue:[CBUUID UUIDWithString: CurrentTime_Service]
  characteristicUUID:[CBUUID UUIDWithString: CurrentTime_Char]
                   p:self.activePeripheral
                data:data];
}

//- (void)readMeasurement
//{
//  [self notification:[CBUUID UUIDWithString:HealthThermometer_Service]
//  characteristicUUID:[CBUUID UUIDWithString:TemperatureMeasurement_Char] p:self.activePeripheral on:YES];
//
//  [self readValue:[CBUUID UUIDWithString:HealthThermometer_Service]
//characteristicUUID:[CBUUID UUIDWithString:TemperatureMeasurement_Char]
//                p:self.activePeripheral];
//}
@end
