//
//  ADHistoryViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/7/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADHistoryViewController.h"
#import "ADBloodPressure.h"

@interface ADHistoryViewController ()

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ADHistoryViewController

- (void)viewDidLoad
{
  self.navigationItem.title = @"History";
  self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];

    [super viewDidLoad];

  [self drawTableView];
  [self drawTableTitleBar];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.tableView reloadData];
}

#pragma mark - View tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  //  only one section, that is the full data list
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [ADBloodPressure count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"index is %d", indexPath.row);
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  NSArray *listOfMeasurements = [ADBloodPressure listOfMeasurement:DESC];
  [self drawOnCell:cell withMeasurement:[listOfMeasurements objectAtIndex:indexPath.row]];
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if(indexPath.row %2 == 0)
    {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-text-bg-white.png"]];
    }
  else
    {
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-text-bg.png"]];
    }
  
}
/*************************************************************
 ** Delete cell
 ************************************************************/
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return YES if you want the specified item to be editable.
  return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    //add code here for when you hit delete
    NSLog(@"indexPath.row is %ld", (long)indexPath.row);
    
    NSArray *listOfMeasurements = [ADBloodPressure listOfMeasurement:DESC];
    NSNumber *measurementID = [[listOfMeasurements objectAtIndex:indexPath.row] measurementID];
    [ADBloodPressure deleteMreasurementAt:measurementID];
    [self.tableView reloadData];
  }
}

#pragma mark - Draw Methods

- (void) drawOnCell:(UITableViewCell *) cell withTime:(NSString *) time
{
  NSLog(@"time is %@", time);
//  UILabel *measurementDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 600, 20)];
  UILabel *measurementTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 120, 20)];
  measurementTime.adjustsFontSizeToFitWidth = YES;
//  measurementTime.layer.borderColor = [UIColor blackColor].CGColor;
//  measurementTime.layer.borderWidth = 2.0f;
//  [measurementDate setText: [WCTime printDateWithLocaleFormat:time]];
//  [measurementTime setText:[WCTime printTimeWithLocaleFormat:time]];
//  [measurementDate setText: time];
  [measurementTime setText: time];
//  [measurementDate setFont:[UIFont fontWithName:HELVETICA size:20]];
  [measurementTime setFont:[UIFont fontWithName:HELVETICA size:10]];
//  [measurementDate setBackgroundColor:[UIColor clearColor]];
  [measurementTime setBackgroundColor:[UIColor clearColor]];
//  [cell.contentView addSubview: measurementDate];
  [cell.contentView addSubview: measurementTime];
}

- (void) drawOnCell:(UITableViewCell *)cell withSystolic:(int) systolic andDiastolic:(int)diastolic andPulse:(int)pulse
{
  UILabel *sysDiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 600, 40)];
  NSString *combineValue = [NSString stringWithFormat:@"%d / %d / %d ",systolic, diastolic, pulse];
  [sysDiaLabel setText:combineValue];
  [sysDiaLabel setFont:[UIFont fontWithName:HELVETICABOLD size:20]];
  [sysDiaLabel setBackgroundColor:[UIColor clearColor]];
  [cell.contentView addSubview:sysDiaLabel];
}

- (void) drawOnCell:(UITableViewCell *)cell isManualInput:(int)isManualInput
{
  if (isManualInput) {
    UIImageView *manualImageView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 10, 20, 20)];
    [manualImageView setImage:[UIImage imageNamed:@"list-upload"]];
    [cell.contentView addSubview:manualImageView];
  }
}

-(void) drawOnCell:(UITableViewCell *) cell withMeasurement: (ADBloodPressure *) measurement
{
  [self drawOnCell:cell withTime:[measurement measurementReceivedTime]];
  [self drawOnCell:cell withSystolic: [[measurement systolic] intValue]
      andDiastolic: [[measurement diastolic] intValue]
          andPulse: [[measurement WCPulse] intValue] ];
  [self drawOnCell:cell isManualInput: [[measurement isManualInput] intValue] ];
}

- (void)drawTableTitleBar
{
  int y = 0;
//  if (isIOS7) {
//    y = 0;
//  }
  UIImageView *tableBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selected"]];
  tableBar.frame = CGRectMake(0, y, self.view.bounds.size.width, 40);
  
  
  UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 600, 25)];
  [dateLabel setText: NSLocalizedString(@"DateTime",nil)];
  //      datelbl.text = NSLocalizedString(@"DATE", nil);
  [dateLabel setFont:[UIFont fontWithName:HELVETICABOLD size:16]];
  dateLabel.textColor = [UIColor whiteColor];
  dateLabel.backgroundColor = [UIColor clearColor];
  [dateLabel setAdjustsFontSizeToFitWidth:YES];
  
  UILabel *SysDiaPulLabal = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 250, 25)];
  [SysDiaPulLabal setText: NSLocalizedString(@"Systolic/Diastolic/Pulse",nil)];
  //  bcavalue.text = NSLocalizedString(@"BCADATA", nil);
  [SysDiaPulLabal setFont:[UIFont fontWithName:HELVETICABOLD size:16]];
  SysDiaPulLabal.textColor = [UIColor whiteColor];
  SysDiaPulLabal.backgroundColor = [UIColor clearColor];
  
  //  UILabel *pulseLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 200, 25)];
  //  [pulseLabel setText: NSLocalizedString(@"/Pulse/MAP", nil)];
  //    //  bcavalue.text = NSLocalizedString(@"BCADATA", nil);
  //  [pulseLabel setFont:[UIFont fontWithName:HELVETICABOLD size:12]];
  //  pulseLabel.textColor = [UIColor whiteColor];
  //  pulseLabel.backgroundColor = [UIColor clearColor];
  
  [self.view addSubview:tableBar];
  [self.view addSubview:dateLabel];
  [self.view addSubview:SysDiaPulLabal];
  //  [self.view addSubview:pulseLabel];
  
}

- (void)drawTableView
{
  self.tableView = [[UITableView alloc]init];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.frame = CGRectMake(0, 34, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
  self.tableView.backgroundColor = [UIColor clearColor];
  
  [self.view addSubview:self.tableView];
}

- (void)reloadTableView
{
  [self.tableView reloadData];
}

#pragma mark - Private Methods
@end
