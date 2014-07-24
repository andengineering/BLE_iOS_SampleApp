//
//  ADTermConditionViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADTermConditionViewController.h"

@interface ADTermConditionViewController ()

@end

@implementation ADTermConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = NSLocalizedString(@"TERMANDCONDITION", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  UIWebView *termAndCondition = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [termAndCondition loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"termandcondition_html", nil) ofType:@"html"]]]];
  while ([termAndCondition isLoading]) {
    // wait...
    NSLog(@"waiting!");
  }
  [self.view addSubview:termAndCondition];
  //  NSLog(@"self.fromSetting is %@", self.fromSetting?@"yes":@"no");
  if (! self.fromSetting) {
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *agree = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"AGREE", nil) style:UIBarButtonItemStyleDone target:self action:@selector(agreeAction:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", nil)style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    if (!isIOS7) {
      [cancel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor blackColor],UITextAttributeTextColor,
                                      nil] forState:UIControlStateNormal];
    }
    NSArray *items = [[NSArray alloc] initWithObjects:agree, cancel, nil];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:items];
  }
}

- (void) agreeAction: (id) sender
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:@"doneReadingTC"];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) cancelAction: (id) sender
{
  //  terminate app
  exit(0);
}

- (void) viewWillDisappear:(BOOL)animated
{
  if (! self.fromSetting) {
    [self.navigationController setToolbarHidden:YES];
  }
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
