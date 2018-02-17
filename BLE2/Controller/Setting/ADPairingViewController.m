//
//  ADPairingViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADPairingViewController.h"
#import "ANDBLEDefines.h"
#import "ANDDevice.h"
#import "ADBloodPressure.h"
#import "ADWeightScale.h"

@interface ADPairingViewController () <ANDDeviceDelegate>

@property (nonatomic, strong) ANDDevice *device;
@property (nonatomic, strong) NSMutableDictionary *devices;
@property NSString *type;

@end

@implementation ADPairingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    self.devices = [NSMutableDictionary new];
    self.navigationItem.title = @"Pairing";
  }
  return self;
}

- (void)viewDidLoad
{
  NSLog(@"viewDidLoad");
  [super viewDidLoad];
  self.device = [ANDDevice new];
  [self.device controlSetup];
  self.device.delegate = self;
  
  if (self.device.activePeripheral.state != CBPeripheralStateConnected) {
    if (self.device.activePeripheral) self.device.peripherials = nil;
    [self.device findBLEPeripherals];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  return [self.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [UITableViewCell new];
  }
  // Configure the cell...
  for (NSString* name in [self.devices allKeys]) {
    cell.textLabel.text = name;
  }
  //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  //  cell.textLabel.text = self.device.connectionStats;
  return cell;
}

- (void)gotDevice:(CBPeripheral *)peripheral
{
  NSLog(@"peripheral name is %@", peripheral.name);
  if ([peripheral.name rangeOfString:@"A&D"].location != NSNotFound ||
      [peripheral.name rangeOfString:@"Murata"].location != NSNotFound ||
      [peripheral.name rangeOfString:@"Life Trak Zone"].location != NSNotFound) {
    if (![self.devices objectForKey:peripheral.name]) {
      if (peripheral.name != nil) {
        [self.devices setValue:peripheral forKey:peripheral.name];
        [self.tableView reloadData];
      }
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CBPeripheral *device = [self.devices objectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
  
  //  ANDDevice *andDevice = [[ANDDevice alloc] init];
    //Setting the type of the device
    if (device.name != nil) {
        if ([device.name rangeOfString:@"A&D_UC-352"].location != NSNotFound)
        {
            
            NSLog(@"Device selected is weight scale");
            self.type = @"ws";
           
        } else if ([device.name rangeOfString:@"651"].location != NSNotFound || [device.name rangeOfString:@"BLP"].location != NSNotFound)
        {
            NSLog(@"Device selected is weight scale");
            self.type = @"bp";
            
        } else {
            self.type = @"unknowm";
        }

    }
  [self.device connectPeripheral:device];
}

- (void) deviceReady
{
  self.device.connectionStats = @"Connected";
    if ([self.type isEqual:@"bp"])
  {
      NSLog(@"Enter bp device");
      ADBloodPressure *bp = [[ADBloodPressure alloc] initWithDevice:self.device];
    //[bp setTime];
     [bp readMeasurementForSetup];
  }else if ([self.type isEqual:@"ws"])
  {
     NSLog(@"Enter WS device");
     ADWeightScale *ws = [[ADWeightScale alloc]initWithDevice:self.device];
    // [ws setTime];
    [ws readMeasurementForSetup];
     
      
  }
  //[self.device readDeviceInformation];
}

- (void) devicesetTime
{
    if ([self.type isEqual:@"bp"])
    {
        NSLog(@"Enter bp device");
        ADBloodPressure *bp = [[ADBloodPressure alloc] initWithDevice:self.device];
        [bp setTime];
       
    }else if ([self.type isEqual:@"ws"])
    {
        NSLog(@"Enter WS device to set time");
        ADWeightScale *ws = [[ADWeightScale alloc]initWithDevice:self.device];
        [ws setTime];
    
    }
    
}

-(void) devicesetBuffer
{
    if ([self.type isEqual:@"bp"])
    {
        NSLog(@"Enter bp device");
        ADBloodPressure *bp = [[ADBloodPressure alloc] initWithDevice:self.device];
        
    }else if ([self.type isEqual:@"ws"])
    {
        NSLog(@"Enter WS for set buffer device");
        ADWeightScale *ws = [[ADWeightScale alloc]initWithDevice:self.device];
        [ws setBuffer];
      
    }
    
}


@end
