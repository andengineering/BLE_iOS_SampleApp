//
//  ADLoginViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/23/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//
#import "ADDouble.h"
#import "ADLoginViewController.h"

@interface ADLoginViewController () <UITextFieldDelegate>

@end

@implementation ADLoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == 0) {
    return @"Email:";
  } else if (section == 1) {
    return @"Password:";
  } else return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  // Configure the cell...
  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  if (cell) {
    if (indexPath.section == 0) {
      self.email = [[UITextField alloc] initWithFrame: CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      [self.email setKeyboardType: UIKeyboardTypeEmailAddress];
//      tf.tag = 100;
      self.email.delegate = self;
      [cell addSubview:self.email];
    } else if (indexPath.section == 1) {
      self.password = [[UITextField alloc] initWithFrame: CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      [self.password setKeyboardType: UIKeyboardTypeAlphabet];
      self.password.secureTextEntry = YES;
      self.password.delegate =self;
//      tf.tag = 101;
      [cell addSubview:self.password];
    } else if (indexPath.section == 2) {
      cell.textLabel.text = @"Log In";
      cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else if (indexPath.section == 3) {
      cell.textLabel.text = @"Sign Up";
      cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
  }
  
  return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 2) {
    NSLog(@"logIn selected");
    NSLog(@"username is %@, password is %@", self.email.text, self.password.text);
    ADDouble *db2 = [ADDouble new];
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setValue:self.email.text forKey:@"email"];
    [userInfo setValue:self.password.text forKey:@"password"];
    [db2 login:userInfo];
    
  } else if (indexPath.section == 3) {
    NSLog(@"SignUp selected");
  }
}

@end
