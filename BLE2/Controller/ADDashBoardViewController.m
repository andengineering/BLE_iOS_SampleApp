//
//  ADDashBoardViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADDashBoardViewController.h"
#import "ADDashBoardCell.h"

#import "ADBloodPressure.h"
#import "ADWeightScale.h"
#import "ADActivityMonitor.h"
#import "ANDBLEDefines.h"
#import "ANDDevice.h"

#import "ADActivityViewController.h"
#import "ADHistoryViewController.h"

#import "MHTabBarController.h"

@interface ADDashBoardViewController () <ANDDeviceDelegate, MHTabBarControllerDelegate>

@property ANDDevice *device;
@property NSString *type;
@property NSString *display;

@end

@implementation ADDashBoardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
      self.navigationItem.title = @"Dashboard";
      self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.separatorColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"viewWillAppear");
  self.device = [ANDDevice new];
  [self.device controlSetup];
  self.device.delegate = self;
  if (self.device.activePeripheral.state != CBPeripheralStateConnected) {
    if (self.device.activePeripheral) {
      self.device.peripherials = nil;
    }
    [self.device findBLEPeripherals];
  }
}

- (void) gotDevice:(CBPeripheral *)peripheral
{
//  NSArray *identifiers = [[NSArray alloc] initWithObjects:peripheral.identifier, nil];
//  if ([self.device.CM retrievePeripheralsWithIdentifiers:identifiers]) {
//    NSLog(@"%@ is a paired device", peripheral.name);
  if (peripheral.name != nil) {
    if ([peripheral.name rangeOfString:@"A&D_UC-352"].location != NSNotFound) {
      NSLog(@"ws");
      self.type = @"ws";
      [self.device connectPeripheral:peripheral];
    } else if ([peripheral.name rangeOfString:@"651"].location != NSNotFound ||
               [peripheral.name rangeOfString:@"BLP"].location != NSNotFound) {
      self.type = @"bp";
      [self.device connectPeripheral:peripheral];
    } else if ([peripheral.name rangeOfString:@"Life Trak Zone"].location != NSNotFound) {
      self.type = @"am";
      NSLog(@"list is %@", self.device.peripherials);
      [self.device connectPeripheral:peripheral];
    }
    //    weight is 352,  bp is 651
  }
}

- (void) deviceReady
{
  NSLog(@"deviceReady called ");

  if ([self.type isEqual:@"bp"]) {
    NSLog(@"BP Device");
    ADBloodPressure *bp = [[ADBloodPressure alloc] initWithDevice:self.device];
    [bp setTime];
    [bp readMeasurementForSetup];
  } else if ([self.type isEqual:@"ws"]) {
    ADWeightScale *ws = [[ADWeightScale alloc] initWithDevice:self.device];
    NSLog(@"WS Device in dashboard");
   // [ws setTime];
    [ws readMeasurementForSetup];
  } else if ([self.type isEqual:@"am"]) {
    ADActivityMonitor *am = [[ADActivityMonitor alloc] initWithDevice:self.device];
    [am readHeader];
  }
}

- (void) devicesetTime
{
    NSLog(@"Sim, called the device set time");
    if ([self.type isEqual:@"bp"])
    {
        NSLog(@"Enter bp device");
        ADBloodPressure *bp = [[ADBloodPressure alloc] initWithDevice:self.device];
        
    }else if ([self.type isEqual:@"ws"])
    {
        NSLog(@"Enter WS device");
        ADWeightScale *ws = [[ADWeightScale alloc]initWithDevice:self.device];
        [ws setTime];
        
    }
    
}

- (void)gotBloodPressure:(NSDictionary *)data
{
  NSLog(@"gotBP");
  [self.device.CM cancelPeripheralConnection:self.device.activePeripheral];
  [self.device findBLEPeripherals];
//  NSString *displayData = [NSString stringWithFormat:@"sys:%@ dia:%@ pulse:%@ mean:%@", [data valueForKey:@"systolic"], [data valueForKey:@"diastolic"], [data valueForKey:@"pulse"], [data valueForKey:@"mean"]];
  NSString *now = [WCTime printDateTimeWithDateNow:savingType];
  NSString *fixedTime = [WCTime convertDateTimeToFixedFormat:now];
  ADBloodPressure *bp = [[ADBloodPressure alloc] initWithMT:fixedTime
                                                        MRT:fixedTime
                                                        Sys:[NSString stringWithFormat:@"%@", [data valueForKey:@"systolic"]]
                                                        Dia:[NSString stringWithFormat:@"%@", [data valueForKey:@"diastolic"]]
                                                        Pul:[NSString stringWithFormat:@"%@", [data valueForKey:@"pulse"]]
                                                        UID:@"00"
                                                        isM:@"0"];
  [bp save];
//  NSLog(@"displayData is %@", displayData);
  //  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text = displayData;
//  self.display = displayData;
  [self.tableView reloadData];
}

- (void)gotWeight:(NSDictionary *)data
{
  NSLog(@"gotWeight in dashboard");
  [self.device.CM cancelPeripheralConnection:self.device.activePeripheral];
  [self.device findBLEPeripherals];
//  NSString *displayData = [NSString stringWithFormat:@"WS: %0.1f %@", [[data valueForKey:@"weight"] doubleValue] / 10, [data valueForKey:@"unit"]];
//  NSLog(@"displayData is %@", displayData);
  NSString *now = [WCTime printDateTimeWithDateNow:savingType];
  NSString *fixedTime = [WCTime convertDateTimeToFixedFormat:now];
  
  ADWeightScale *ws = [[ADWeightScale alloc] initWithMT:fixedTime
                                                    MRT:fixedTime
                                                 Weight:[NSString stringWithFormat:@"%0.1f", [[data valueForKey:@"weight"] doubleValue] / 10]
                                                   Unit:[data valueForKey:@"unit"]
                                                    Bmi:@"00"
                                                    UID:@"00"
                                                    isM:@"0"];
  [ws save];
  [self.tableView reloadData];
}

- (void) gotActivity:(NSData *)data
{
  NSLog(@"gotActivity");
  [self.device.CM cancelPeripheralConnection:self.device.activePeripheral];
  [self.device findBLEPeripherals];
  //need to parse this group of data...
  [self parseActivity:data];
  
}

- (void) parseActivity:(NSData *)data
{
//  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  NSMutableData *myData = [[NSMutableData alloc] initWithData:data];
  //remove first 2 bytes of datalength
  NSLog(@"myData is %@", myData);
  [myData replaceBytesInRange:NSMakeRange(0, 2) withBytes:NULL length:0];
  NSLog(@"myData without dataLength %@", myData);
  //goes into a while that delete everyday data
  //each day has 24 bytes
  while (myData.length > 24) {
    NSData *day = [myData subdataWithRange:NSMakeRange(0, 24)];
    NSLog(@"day is %@", day);
    [self parseDay:day];
    [myData replaceBytesInRange:NSMakeRange(0, 24) withBytes:NULL length:0];
  }
  ADActivityMonitor *am = [[ADActivityMonitor alloc] initWithDevice:self.device];
  [am endConnection];
  [self.tableView reloadData];
}

- (void) parseDay: (NSData *)today
{
  //  da mo ye se mn hr se mn hr bi steps    dist     calorie  sleep
  //  06 01 72 00 00 00 3b 3b 17 02 9d100000 19010000 e9530000 aa01
  //  1  1  1  1  1  1  1  1  1  1  4        4        4        2      = 24
  //get all data then save to database...
//  int year = *(int *)[[date subdataWithRange:NSMakeRange(0, 2)] bytes];
  int day = *(int *)[[today subdataWithRange:NSMakeRange(0, 1)] bytes];
  int month = *(int *)[[today subdataWithRange:NSMakeRange(1, 1)] bytes];
  int year = *(int *)[[today subdataWithRange:NSMakeRange(2, 1)] bytes];
  int startSecond = *(int *)[[today subdataWithRange:NSMakeRange(3, 1)] bytes];
  int startMinute = *(int *)[[today subdataWithRange:NSMakeRange(4, 1)] bytes];
  int startHour = *(int *)[[today subdataWithRange:NSMakeRange(5, 1)] bytes];
  int endSecond = *(int *)[[today subdataWithRange:NSMakeRange(6, 1)] bytes];
  int endMinutes = *(int *)[[today subdataWithRange:NSMakeRange(7, 1)] bytes];
  int endHour = *(int *)[[today subdataWithRange:NSMakeRange(8, 1)] bytes];
  int blockIndex = *(int *)[[today subdataWithRange:NSMakeRange(9, 1)] bytes];
  int steps = *(int *)[[today subdataWithRange:NSMakeRange(10, 4)] bytes];
  int distances = *(int *)[[today subdataWithRange:NSMakeRange(14, 4)] bytes];
  int calories = *(int *)[[today subdataWithRange:NSMakeRange(18, 4)] bytes];
  int sleep = *(int *)[[today subdataWithRange:NSMakeRange(22, 2)] bytes];
  NSLog(@"%d/%d/%d %d:%d:%d %d:%d:%d %d %d %d %d %d", day, month, year, startSecond, startMinute, startHour, endSecond, endMinutes, endHour, blockIndex, steps, distances, calories, sleep);
  NSString *date = [NSString stringWithFormat:@"%d%d%d", year, month, day];
  NSString *startTime = [NSString stringWithFormat:@"%d:%d:%d", startHour, startMinute, startSecond];
  NSString *endTime = [NSString stringWithFormat:@"%d:%d:%d", endHour, endMinutes, endSecond];
  
  ADActivityMonitor *am = [[ADActivityMonitor alloc] initWithDate:[NSNumber numberWithInt:[date intValue]] startTime:startTime endTime:endTime steps:[[NSNumber alloc]initWithInt:steps]  distances:[[NSNumber alloc] initWithInt:distances] calories:[[NSNumber alloc] initWithDouble:calories/10] sleep:[[NSNumber alloc] initWithInt:sleep]];
  [am save];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return self.view.bounds.size.height/3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 30.0f/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    if (indexPath.row == 0) {
      cell = [[ADDashBoardCell alloc] initWithType:Activity withView:self.view];
    } else if (indexPath.row == 1) {
      cell = [[ADDashBoardCell alloc] initWithType:BloodPressure withView:self.view];
    } else if (indexPath.row == 2) {
      cell = [[ADDashBoardCell alloc] initWithType:WeightSacle withView:self.view];
    }
  }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) { //AM
//    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ADDashBoardViewController alloc] initWithStyle:UITableViewStyleGrouped]];
  } else if (indexPath.row == 1) {  //BP
//    self.navigationItem.title = @"Detail View";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    ADActivityViewController *activity = [ADActivityViewController new];
    ADHistoryViewController *history = [ADHistoryViewController new];
    activity.title = @"Activity";
    history.title = @"History";
    NSArray *viewControllers = @[activity, history];
    MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
    tabBarController.navigationItem.title = @"BP Detail";
    tabBarController.delegate = self;
    tabBarController.viewControllers = viewControllers;
    [self.navigationController pushViewController:tabBarController animated:YES];
  } else if (indexPath.row == 2) {
    
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.device.CM stopScan];
  self.device = nil;
}

//- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
//{
//	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);
//  
//	// Uncomment this to prevent "Tab 3" from being selected.
//	//return (index != 2);
//  
//	return YES;
//}
//
//- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
//{
//	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
//}


@end
