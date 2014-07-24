//
//  ADActivityMonitor.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/8/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADActivityMonitor.h"
#import "ANDBLEDefines.h"
#import "WCSQLite.h"

@implementation ADActivityMonitor
@synthesize measurementID = _measurementID;
@synthesize measurementReceivedTime = _measurementReceivedTime;
@synthesize date = _date;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize steps = _steps;
@synthesize distances = _distances;
@synthesize calories = _calories;


-(id)init
{
  self = [super init];
  return self;
}

- (id) initWithDate: (NSNumber *) date
          startTime: (NSString *) startTime
            endTime: (NSString *) endTime
              steps: (NSNumber *) steps
          distances: (NSNumber *) distances
           calories: (NSNumber *) calories
              sleep:(NSNumber *)sleep
{
  _measurementReceivedTime = [WCTime printDateTimeWithDateNow:displayType];
  _date = date;
  _startTime = startTime;
  _endTime = endTime;
  _steps = steps;
  _distances = distances;
  _calories = calories;
  _sleep = sleep;
  return self;
}

+ (void) createTable
{
  // do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  //  i'll need to save in KG always
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS 'ActivityMonitorMeasurements' ( 'Date' INTEGER NOT NULL PRIMARY KEY , 'MeasurementReceivedTime' TEXT,'StartTime' TEXT, 'EndTime' TEXT, 'Steps' INTEGER, 'Distances' REAL, 'Calories' REAL, 'Sleep' INTEGER);"];
  if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
    sqlite3_close(db);
    NSAssert(0, @"Could not create AM table");
  } else {
    NSLog(@"AM table created");
  }
}

- (id) initWithLatestMeasurement
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM ActivityMonitorMeasurements order by Date DESC LIMIT 1;"];
  sqlite3_stmt *statement;
  if(sqlite3_prepare_v2(db,[quary UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
    //  NSLog(@"i'm here! statement is %@", statement);
    while (sqlite3_step(statement)==SQLITE_ROW) {
//      int field1 = sqlite3_column_int(statement, 0);
//      self.measurementID = [NSNumber numberWithInt:field1];
      //    NSLog(@"meauremenID is %@", self.measurementID);
//      'MeasurementID', 'MeasurementReceivedTime' TEXT, 'Date' TEXT, 'StartTime' TEXT, 'EndTime' TEXT, 'Steps' INTEGER, 'Distances' REAL, 'Calories' REAL
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      self.measurementReceivedTime = [[NSString alloc]initWithUTF8String:field2];
      
      int field3 = sqlite3_column_int(statement, 0);
      self.date= [NSNumber numberWithInt:field3];
      //      NSNumber *f = [NSNumber numberWithFloat:(float)sqlite3_column_double(stmt, col)]
      char *field4 = (char *) sqlite3_column_text(statement, 2);
      self.startTime = [[NSString alloc]initWithUTF8String:field4];
      
      char *field5 = (char *) sqlite3_column_text(statement, 3);
      self.endTime = [[NSString alloc]initWithUTF8String:field5];
      
      int field6 = sqlite3_column_int(statement, 4);
      self.steps = [NSNumber numberWithInt:field6];
      
      double field7 = sqlite3_column_double(statement, 5);
      self.distances = [NSNumber numberWithDouble:field7];
      
      double field8 = sqlite3_column_double(statement, 6);
      self.calories = [NSNumber numberWithDouble:field8];
      
      int field9 = sqlite3_column_int(statement, 7);
      self.sleep = [NSNumber numberWithInt:field9];
    }
  }
  return self;
}

+ (NSArray *) listOfMeasurement: (ADAMOrder) order
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  NSMutableArray *listOfMeasurements = [[NSMutableArray alloc] initWithCapacity: [ADActivityMonitor count]];
  
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM ActivityMonitorMeasurements order by Date %@;", (order == AM_DESC) ? @"DESC" : @"ASC"];
  sqlite3_stmt *statement;
  if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil) == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
//      int measurementID = sqlite3_column_int(statement, 0);
      char *time = (char *)sqlite3_column_text(statement, 1);
      int date = sqlite3_column_int(statement, 0);
      char *startTime = (char *)sqlite3_column_text(statement, 2);
      char *endTime = (char *)sqlite3_column_text(statement, 3);
      int steps = sqlite3_column_int(statement, 4);
      double distances = sqlite3_column_double(statement, 5);
      double calories = sqlite3_column_double(statement, 6);
      int sleep = sqlite3_column_int(statement, 7);
      
//      NSString *displayTime = [[NSString alloc] initWithUTF8String:date];
      
      NSString *receivedTime = [[NSString alloc] initWithUTF8String:time];
//      NSNumber *dateTime = [[NSString alloc] initWithUTF8String:date];
      NSString *st = [[NSString alloc] initWithUTF8String:startTime];
      NSString *et = [[NSString alloc] initWithUTF8String:endTime];
      
      ADActivityMonitor *am = [[ADActivityMonitor alloc] init];
//      am.measurementID = [NSNumber numberWithInt:measurementID];
      am.measurementReceivedTime = receivedTime;
      am.date = [NSNumber numberWithInt:date];
      am.startTime = st;
      am.endTime = et;
      am.steps = [[NSNumber alloc] initWithInt:steps];
      am.distances = [[NSNumber alloc] initWithDouble:distances];
      am.calories = [[NSNumber alloc] initWithDouble:calories];
      am.sleep = [[NSNumber alloc] initWithInt:sleep];
      [listOfMeasurements addObject:am];
    }
  }
  return [NSArray arrayWithArray:listOfMeasurements];
}

+ (NSInteger) count
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT count(*) FROM ActivityMonitorMeasurements"];
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

+ (NSString *)save: (ADActivityMonitor *)am
{
  // do stuff save to sql
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3 *db = sharedSql.database;
  //  i'll need to save in KG always
  NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO ActivityMonitorMeasurements ('MeasurementReceivedTime', 'Date', 'StartTime', 'EndTime', 'Steps', 'Distances', 'Calories', 'Sleep') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", am.measurementReceivedTime, am.date, am.startTime, am.endTime, am.steps , am.distances, am.calories, am.sleep];
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
  NSString *sql = [NSString stringWithFormat:@"INSERT INTO ActivityMonitorMeasurements ('MeasurementReceivedTime', 'Date', 'Starttime', 'Endtime', 'Steps', 'Distances', 'Calories', 'Sleep') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", self.measurementReceivedTime, self.date, self.startTime, self.endTime, self.steps , self.distances, self.calories, self.sleep];

  if ([self exist]) {
    sql = [NSString stringWithFormat:@"REPLACE INTO ActivityMonitorMeasurements ('MeasurementReceivedTime', 'Starttime', 'Endtime', 'Steps', 'Distances', 'Calories', 'Sleep', 'Date') VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", self.measurementReceivedTime, self.startTime, self.endTime, self.steps, self.distances, self.calories, self.sleep, self.date];
  }
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

- (BOOL) exist
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT * FROM ActivityMonitorMeasurements WHERE Date = '%@'",self.date];
  sqlite3_stmt *statement;
  char *date = NULL;
  BOOL result = NO;
  if(sqlite3_prepare_v2(db, [quary UTF8String], -1, &statement, nil)==SQLITE_OK) {
    while (sqlite3_step(statement)==SQLITE_ROW) {
      date = (char *)sqlite3_column_text(statement, 0);
      NSLog(@"exist is %@", [NSString stringWithFormat:@"%s", date]);
    }
  }
  if (date) {
    result = YES;
  }
  //  NSLog(@"BP count is %d", result);
  return result;
}

+ (NSInteger) maxValue: (NSString *)value
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT MAX(%@) FROM ActivityMonitorMeasurements", value];
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

+ (NSInteger) minValue: (NSString *)value
{
  NSInteger result = 0;
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  NSString *quary = [NSString stringWithFormat:@"SELECT MIN(%@) FROM ActivityMonitorMeasurements", value];
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

+ (void) deleteMeasurementAt: (NSNumber *) measurementID
{
  WCSQLite *sharedSql = [WCSQLite initialize];
  sqlite3* db = sharedSql.database;
  
  NSString *quary = [NSString stringWithFormat:@"DELETE FROM ActivityMonitorMeasurements WHERE MeasurementID=%@;", measurementID];
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

- (void)readHeader
{
  NSLog(@"AM readHeader");
  
  [self notification:[CBUUID UUIDWithString:ActivityMonitor_Serivce]
  characteristicUUID:[CBUUID UUIDWithString:ActivityMonitorRead_Char]
                   p:self.activePeripheral
                  on:YES];
  
  UInt8 ip[] = {0x01,0xa0};
  NSData *data = [[NSData alloc] initWithBytes:ip length:sizeof(ip)];
  NSLog(@"data is %@", data);
  [self writeValue:[CBUUID UUIDWithString:ActivityMonitor_Serivce] characteristicUUID:[CBUUID UUIDWithString:ActivityMonitorWrite_Char] p:self.activePeripheral data:data];
  
}

- (void)endConnection
{
  UInt8 ip[] = {0x01,0x46};
  NSData *data = [[NSData alloc] initWithBytes:ip length:sizeof(ip)];
  NSLog(@"data is %@", data);
  [self writeValue:[CBUUID UUIDWithString:ActivityMonitor_Serivce] characteristicUUID:[CBUUID UUIDWithString:ActivityMonitorWrite_Char] p:self.activePeripheral data:data];
  
}
@end
