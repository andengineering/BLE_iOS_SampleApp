//
//  WCSQLite.h
//  WellnessConnected
//
//  Created by Chenchen Zheng on 8/14/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface WCSQLite : NSObject

@property (nonatomic) sqlite3* database;

+(WCSQLite *)initialize;
-(WCSQLite *)init;
//open the database
-(sqlite3 *)openDB;
-(void)insertQuary:(NSString*)quary;

//-(void) createBloodPressureTable;
//-(void) createWeightScaleTable;
//-(void) createBCATable;

@end
