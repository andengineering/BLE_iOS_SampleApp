//
//  WCSQLite.m
//  WellnessConnected
//
//  Created by Chenchen Zheng on 8/14/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCSQLite.h"

@implementation WCSQLite

@synthesize database;
static WCSQLite *sharedInstance;

#pragma mark - Sqlite3 Database Commands
//Singleton
+(WCSQLite *)initialize
{
  static BOOL initialized = NO;
  if(!initialized)
  {
    initialized = YES;
    sharedInstance = [[WCSQLite alloc] init];
  }
  return sharedInstance;
}

-(WCSQLite *)init
{
  self.database = [self openDB];
  return self;
}
//file path to database
-(NSString *) filePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ANDWellness.sql"];
}

//open the database
-(sqlite3 *)openDB
{
  if (sqlite3_open([[self filePath] UTF8String], &database) != SQLITE_OK) {
    sqlite3_close(self.database);
    NSLog( @"Database failed to open");
  } else {
    NSLog(@"database opened");
  }
  return self.database;
}

-(void)insertQuary:(NSString*)quary
{
  char *err;
  if (sqlite3_exec(self.database, [quary UTF8String], NULL, NULL, &err) != SQLITE_OK){
    sqlite3_close(self.database);
    NSAssert(0, @"Cloud not update table");
  }else {
    NSLog(@"table updated");
  }
}

//-(void) createBloodPressureTable
//{
//  char *err;
//  NSString *sql = [NSString stringWithFormat:
//                   @"CREATE TABLE IF NOT EXISTS 'BloodPressureMeasurements' ( 'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'MeasurementTime' TEXT, 'MeasurementReceivedTime' TEXT, 'Systolic' INTEGER, 'Diastolic' INTEGER, 'PULSE' INTEGER, 'MAP' INTEGER, 'UserID' INTEGER, 'isManualInput' INTEGER);"];
//  if (sqlite3_exec(self.database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//    sqlite3_close(self.database);
//    NSAssert(0, @"Could not create BP table");
//  } else {
//    NSLog(@"BP table created");
//  }
//}

//-(void) createWeightScaleTable
//{
//  char *err;
//  NSString *sql = [NSString stringWithFormat:
//                   @"CREATE TABLE IF NOT EXISTS 'WeightScaleMeasurements' ( 'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'MeasurementTime' TEXT, 'MeasurementReceivedTime' TEXT, 'Weight' REAL, 'Units' Text, 'BMI' REAL, 'UserID' INTEGER, 'isManualInput' INTEGER);"];
//  if (sqlite3_exec(self.database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//    sqlite3_close(self.database);
//    NSAssert(0, @"Could not create WS table");
//  } else {
//    NSLog(@"WS table created");
//  }
//}

//-(void) createBCATable
//{
//  char *err;
//  NSString *sql = [NSString stringWithFormat:
//                   @"CREATE TABLE IF NOT EXISTS 'BCAMeasurements' ( 'MeasurementID' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'MeasurementTime' TEXT, 'MeasurementReceivedTime' TEXT, 'Weight' REAL, 'Units' Text, 'fat' REAL, 'basal' REAL, 'musm' REAL, 'bwm' REAL, 'UserID' INTEGER, 'isManualInput' INTEGER);"];
//  if (sqlite3_exec(self.database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
//    sqlite3_close(self.database);
//    NSAssert(0, @"Could not create BCA table");
//  } else {
//    NSLog(@"BCA table created");
//  }
//}

@end
