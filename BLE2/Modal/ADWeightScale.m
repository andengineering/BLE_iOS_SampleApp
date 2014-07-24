//
//  ADWeightScale.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADWeightScale.h"
#import "WCSQLite.h"
#import "ANDBLEDefines.h"

@implementation ADWeightScale

@synthesize measurementID = _measurementID;
@synthesize measurementTime = _measurementTime;
@synthesize measurementReceivedTime = _measurementReceivedTime;
@synthesize WSWeight = _WSWeight;
@synthesize units = _units;
@synthesize bmi = _bmi;

- (id)initWithMT:(NSString *)measurementTime MRT:(NSString *)measurementReceivedTime Weight:(NSString *)weight Unit:(NSString *)unit Bmi:(NSString *)bmi UID:(NSString *)UserID isM:(NSString *)isManualInput
{
  _measurementTime = measurementTime;
  _measurementReceivedTime = measurementReceivedTime;
  _WSWeight = [NSNumber numberWithFloat: [weight floatValue]];
  _units =  unit;
  _bmi = [NSNumber numberWithFloat:[bmi floatValue]];
  _userID = [NSNumber numberWithInt:[UserID intValue]];
  _isManualInput = [NSNumber numberWithInt:[isManualInput intValue]];
  
  return self;
}

- (id)initWithLatestMeasurement
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM WeightScaleMeasurements order by MeasurementID DESC LIMIT 1;"];
  sqlite3_stmt *statement;
  if(sqlite3_prepare_v2(db,[quary UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
    //  NSLog(@"i'm here! statement is %@", statement);
    while (sqlite3_step(statement)==SQLITE_ROW) {
      int field1 = sqlite3_column_int(statement, 0);
      self.measurementID = [NSNumber numberWithInt:field1];
      //    NSLog(@"meauremenID is %@", self.measurementID);
      
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      self.measurementTime = [[NSString alloc]initWithUTF8String:field2];
      
      char *field3 = (char *) sqlite3_column_text(statement, 2);
      self.measurementReceivedTime= [[NSString alloc]initWithUTF8String:field3];
      //      NSNumber *f = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, col)]
      float field4 = (float) sqlite3_column_double(statement, 3);
      self.WSWeight = [NSNumber numberWithFloat:field4];
      
      char *field5 = (char *) sqlite3_column_text(statement, 4);
      self.units = [[NSString alloc]initWithUTF8String:field5];
      
      float field6 = (float) sqlite3_column_double(statement, 5);
      self.bmi = [NSNumber numberWithFloat:field6];
      
      int field7 = sqlite3_column_int(statement, 6);
      self.userID = [NSNumber numberWithInt:field7];
      
      int field8 = sqlite3_column_int(statement, 7);
      self.isManualInput = [NSNumber numberWithBool:field8];
    }
    }
  return self;
}

//  select * from weightscalemeasurements ORDER BY measurementid DESC;
//  'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,   0
//  'MeasurementTime' TEXT,                                       1
//  'MeasurementReceivedTime' TEXT,                               2
//  'Weight' REAL,                                                3
//  'Units' Text,                                                 4
//  'BMI' REAL,                                                   5
//  'UserID' INTEGER,                                             6
//  'isManualInput' INTEGER                                       7

+ (NSArray *) listOfMeasurement:(ARWeightScaleOrder)order
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  NSMutableArray *listOfMeasurements = [[NSMutableArray alloc] initWithCapacity: [ADWeightScale count]];
  
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM WeightScaleMeasurements order by MeasurementTime %@;", (order == WS_DESC) ? @"DESC" : @"ASC"];
  sqlite3_stmt *statement;
  if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil) == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
      int measurementID = sqlite3_column_int(statement, 0);
      char *time = (char *)sqlite3_column_text(statement, 1);
      char *time2 = (char *)sqlite3_column_text(statement, 2);
      float weight = sqlite3_column_double(statement, 3);
      char *unit = (char *)sqlite3_column_text(statement, 4);
      float bmi = sqlite3_column_double(statement, 5);
      int uid = sqlite3_column_int(statement, 6);
      int isManualInput = sqlite3_column_int(statement, 7);
      
      NSString *displayTime = [[NSString alloc] initWithUTF8String:time];
      
      NSString *receivedTime = [[NSString alloc] initWithUTF8String:time2];
      ADWeightScale *ws = [[ADWeightScale alloc] init];
      ws.measurementID = [NSNumber numberWithInt:measurementID];
      ws.measurementReceivedTime = receivedTime;
      ws.measurementTime = displayTime;
      ws.WSWeight = [[NSNumber alloc] initWithFloat:weight];
      ws.units = [[NSString alloc] initWithUTF8String:unit];
      ws.bmi = [[NSNumber alloc] initWithFloat:bmi];
      ws.userID = [[NSNumber alloc] initWithInt:uid];
      ws.isManualInput = [[NSNumber alloc] initWithInt:isManualInput];
      [listOfMeasurements addObject:ws];
    }
  }
  return [NSArray arrayWithArray:listOfMeasurements];
}

+ (void) deleteMreasurementAt: (NSNumber *) measurementID
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  
  NSString *quary = [NSString stringWithFormat:@"DELETE FROM WeightScaleMeasurements WHERE MeasurementID=%@;", measurementID];
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
-(NSString *) description
{
  return [NSString stringWithFormat:@"%@ WCWS: %@ %@ %@", self.measurementTime, self.WSWeight, self.units, self.bmi];
}

+ (NSInteger)count
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT count(*) FROM WeightScaleMeasurements"];
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
  NSString *quary = [NSString stringWithFormat:@"SELECT MAX(%@) FROM WeightScaleMeasurements", value];
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
  NSString *quary = [NSString stringWithFormat:@"SELECT MIN(%@) FROM WeightScaleMeasurements", value];
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

+ (NSString *) save: (ADWeightScale *)ws
{
//  if ([[HVClient current] isAppCreated]) {
//    [ws putWeightInHealthVault];
//  }
  // do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  //  i'll need to save in KG always
  NSString *sql = [NSString stringWithFormat:@"INSERT INTO WeightScaleMeasurements ('MeasurementTime', 'MeasurementReceivedTime', 'Weight', 'Units', 'BMI', 'UserID', 'isManualInput') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@');", ws.measurementTime, ws.measurementReceivedTime, [NSString stringWithFormat:@"%f", [[ws weightInKG] doubleValue]], @"kg", ws.bmi, ws.userID, ws.isManualInput];
  NSLog(@"sql is %@", sql);
  char *err;
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
    sqlite3_close(db);
    NSAssert(0, @"Cloud not update table");
    return @"save: Cloud not update table";
  }else {
    return @"save: Table Updated";
  }
}

- (NSString *)save
{
//  if ([[HVClient current] isAppCreated]) {
//    [self putWeightInHealthVault];
//  }
  // do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  //  i'll need to save in KG always
  NSString *sql = [NSString stringWithFormat:@"INSERT INTO WeightScaleMeasurements ('MeasurementTime', 'MeasurementReceivedTime', 'Weight', 'Units', 'BMI', 'UserID', 'isManualInput') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@');", self.measurementTime, self.measurementReceivedTime, [NSString stringWithFormat:@"%f", [[self weightInKG] floatValue]], @"kg", self.bmi, self.userID, self.isManualInput];
  NSLog(@"sql is %@", sql);
  char *err;
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
    sqlite3_close(db);
    NSAssert(0, @"Cloud not update table");
    return @"save: Cloud not update table";
  }else {
    return @"save: Table Updated";
  }
}

+ (void) createTable
{
  // do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  //  i'll need to save in KG always
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS 'WeightScaleMeasurements' ( 'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'MeasurementTime' TEXT, 'MeasurementReceivedTime' TEXT, 'Weight' REAL, 'Units' Text, 'BMI' REAL, 'UserID' INTEGER, 'isManualInput' INTEGER);"];
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
    sqlite3_close(db);
    NSAssert(0, @"Could not create WS table");
  } else {
    NSLog(@"WS table created");
  }
}

//+ (CGFloat)calculateBMI:(NSNumber *)weight andUnit:(NSString *)unit andPI: (AMPatientInfo *) pi
//{
//  NSLog(@"height is %0.2f, and unit is %@", [pi.height floatValue], pi.height_unit == mm ? @"mm" : @"inch");
//  NSLog(@"weight is %0.2f, and unit is %@", [weight floatValue], unit);
//  //say i got either inchs or mm and kg or lb
//  CGFloat height = [pi.height floatValue];
//  CGFloat weight2 = [weight floatValue];
//  if (pi.height_unit == inchs) {
//    height = height*25.4;
//  }
//  height = height * 0.001;
//  if ([unit isEqualToString:@"lb"]) {
//    weight2 = weight2 * 0.453592;
//  }
//  CGFloat result = weight2 / (height * height) ;
//  
//  return result;
//}

#pragma mark - private methods

- (NSNumber *)weightInKG
{
  NSNumber *result = self.WSWeight;
  if ([self.units isEqualToString: @"lb"]) {
    double tmp = [self.WSWeight doubleValue] / 2.20462262185;
    NSLog(@"weightInKG tmp is %f", tmp);
    result = [NSNumber numberWithDouble:tmp];
  }
  NSString *tmp2 = [NSString stringWithFormat:@"%.2f", [result doubleValue]];
  result =[NSNumber numberWithDouble:[tmp2 doubleValue]];
  
  NSLog(@"KG result is %f", [result doubleValue]);
  return result;
}

- (NSNumber *)weightInLB
{
  NSNumber *result = self.WSWeight;
  if ([self.units isEqualToString: @"kg"]) {
    double tmp = [self.WSWeight doubleValue] * 2.20462262185;
    NSLog(@"weightInKG tmp is %f", tmp);
    result =[NSNumber numberWithDouble:tmp];
  }
  NSString *tmp2 = [NSString stringWithFormat:@"%.2f", [result doubleValue]];
  result =[NSNumber numberWithDouble:[tmp2 doubleValue]];
  
  NSLog(@"LB result is %f", [result doubleValue]);
  return result;
}

- (NSDictionary *) printProperWeight
{
  NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *unitDefault = [defaults objectForKey:@"Units"];
  if ([unitDefault isEqualToString:@"Metrics (Kilograms, Meters)"])
    unitDefault = @"kg";
  else unitDefault = @"lb";
  if (![unitDefault isEqualToString:self.units])
    {
    if ([self.units isEqualToString:@"kg"]) {
      //convert kg to pound
      double tmp = [self.WSWeight doubleValue] * 2.20462262185;
      NSLog(@"tmp is %.5f", [self.WSWeight doubleValue]);
      [result setObject:[NSString stringWithFormat:@"%0.1f", tmp] forKey:@"weight"];
      [result setObject:@"lb" forKey:@"unit"];
    } else {
      //convert pound to kg
      double tmp = [self.WSWeight doubleValue] * 1/2.20462262185;
      [result setObject:[NSString stringWithFormat:@"%0.1f", tmp] forKey:@"weight"];
      [result setObject:@"kg" forKey:@"unit"];
    }
    } else {
      double tmp = [self.WSWeight doubleValue];
      [result setObject:[NSString stringWithFormat:@"%0.1f", tmp] forKey:@"weight"];
      [result setObject:self.units forKey:@"unit"];
    }
  return result;
}

//
// Push a new weight into HealthVault
//
//-(void)putWeightInHealthVault
//{
//  HVItem* item = [HVWeight newItem];
//  if ([self.units isEqualToString:@"kg"]) {
//    item.weight.inKg = [[self weightInKG] doubleValue];
//  } else {
//    item.weight.inPounds = [[self weightInLB] doubleValue];
//  }
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//  NSDate * date = [dateFormatter dateFromString:self.measurementTime];
//  item.weight.when = [[HVDateTime alloc] initWithDate:date];
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

-(id)initWithDevice:(ANDDevice *)device
{
  self = [super init];
  if (self) {
    self.activePeripheral = device.activePeripheral;
    self.CM = device.CM;
    self.peripherials = device.peripherials;
    self.delegate = device.delegate;
  }
  return self;
}

- (void) setTime
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    NSInteger year = components.year;
    NSMutableData *yearData = [[NSMutableData alloc] initWithBytes:&year length:sizeof(year)];
    int year1 = *(int *)[[yearData subdataWithRange:NSMakeRange(0, 1)] bytes];
    int year2 = *(int *)[[yearData subdataWithRange:NSMakeRange(1, 1)] bytes];
    
    
    //int year1 = 222;
    //int year2 = 7;
    
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
    
    [self writeValue:[CBUUID UUIDWithString: WeightScale_Service]
  characteristicUUID:[CBUUID UUIDWithString: DateTime_Char]
                   p:self.activePeripheral
                data:data];
    
}


- (void)readMeasurement
{
    NSLog(@"ws readMeasurement");
    
    
    [self readValue:[CBUUID UUIDWithString:WeightScale_Service]
 characteristicUUID:[CBUUID UUIDWithString:DateTime_Char]
                  p:self.activePeripheral];
    
    [self notification:[CBUUID UUIDWithString:WeightScale_Service]
    characteristicUUID:[CBUUID UUIDWithString:DateTime_Char]
                     p:self.activePeripheral on:YES];
    
    
    [self readValue:[CBUUID UUIDWithString:WeightScale_Service]
 characteristicUUID:[CBUUID UUIDWithString:WeightScaleMeasurement_Char]
                  p:self.activePeripheral];
    
    [self notification:[CBUUID UUIDWithString:WeightScale_Service]
    characteristicUUID:[CBUUID UUIDWithString:WeightScaleMeasurement_Char]
                     p:self.activePeripheral on:YES];
    
    
    
}

/*
- (void)readMeasurement
{
  NSLog(@"ws readMeasurement");
  //  [self readValue:[CBUUID UUIDWithString:HealthThermometer_Service]
  //characteristicUUID:[CBUUID UUIDWithString:DateTime_Char]
  //                p:self.activePeripheral];
  
  [self notification:[CBUUID UUIDWithString:WeightScale_Service]
  characteristicUUID:[CBUUID UUIDWithString:WeightScaleMeasurement_Char]
                   p:self.activePeripheral
                  on:YES];
  
  //  [self readValue:[CBUUID UUIDWithString:HealthThermometer_Service]
  //characteristicUUID:[CBUUID UUIDWithString:TemperatureMeasurement_Char]
  //                p:self.activePeripheral];
  
} */

- (void) pair
{
  
}

@end
