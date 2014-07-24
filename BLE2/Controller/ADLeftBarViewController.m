//
//  ADLeftBarViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADLeftBarViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"


#import "ADDashBoardViewController.h"
#import "ADPairingViewController.h"
#import "ADSettingViewController.h"

//for temp testing put replace setting as Log in
//#import "ADLoginViewController.h"

@interface ADLeftBarViewController ()
@property (strong) NSArray *sectionHeaders;
@end

@implementation ADLeftBarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
      self.sectionHeaders = [[NSArray alloc] initWithObjects:@"Account", nil];
      [self.view setBackgroundColor:[UIColor colorWithRed:21/255.0 green:111/255.0 blue:142/255.0 alpha:1.0]];
      [self.view setBounds:CGRectMake(0, 0, 200, 500)];

    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self topLogo];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)topLogo
{
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 280, 100)];
  UIImageView *top = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
  top.center = headerView.center;
  [headerView addSubview:top];
  //  UIImageView *top = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
//  top.frame = CGRectMake(0, 0, 100, 100);
  self.tableView.tableHeaderView = headerView;
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

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//  NSLog(@"called");
//  view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//  /* Create custom view to display section header... */
//  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
////  [label setFont:[UIFont boldSystemFontOfSize:12]];
////  NSString *string =[self.sectionHeaders objectAtIndex:section];
//  /* Section header is in 0th index... */
//  [label setText:@"Account"];
//  [view addSubview:label];
////  [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
////  return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 25.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  NSLog(@"called!");
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 25)];
  label.textColor = [UIColor whiteColor];
  [label setText:@"  ACCOUNT"];
//  view.center = label.center;
  label.center = view.center;
  [view addSubview:label];
  [view setBackgroundColor:[UIColor colorWithRed:45/255.0 green:126/255.0 blue:154/255.0 alpha:1.0]]; //your background color...

  return view;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//  return @"Account";
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  [cell setBackgroundColor:[UIColor colorWithRed:21/255.0 green:111/255.0 blue:142/255.0 alpha:1.0]];
  cell.textLabel.textColor = [UIColor whiteColor];
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  if (indexPath.row == 0) {
    cell.imageView.image = [UIImage imageNamed:@"goal_icon"];
    cell.textLabel.text = @"Dashboard";
  } else if (indexPath.row == 1) {
    cell.imageView.image = [UIImage imageNamed:@"add_rem_icon"];
    cell.textLabel.text = @"Pairing";
  } else if (indexPath.row == 2) {
    cell.imageView.image = [UIImage imageNamed:@"per_set_icon"];
    cell.textLabel.text = @"Log In";
  }
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0) { //Dashboard
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[ADDashBoardViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    navi.navigationBar.translucent = NO;
    self.sidePanelController.centerPanel = navi;
  } else if (indexPath.row == 1) {  //Add/Remove Device
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[ADPairingViewController new]];
  } /*else if (indexPath.row == 2) { //Log in
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ADLoginViewController alloc] initWithStyle:UITableViewStyleGrouped]];
  } */
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  if (section == 0) {
    return [helper appNameAndVersionNumberDisplayString];
  }
  return @"";
}

@end
