//
//  ADAppDelegate.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADAppDelegate.h"
#import "JASidePanelController.h"

#import "ADDashBoardViewController.h"
#import "ADLeftBarViewController.h"

#import "ADTermConditionViewController.h"

#import "ADBloodPressure.h"
#import "ADWeightScale.h"
#import "ADActivityMonitor.h"


@implementation ADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self appTheme];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  ADDashBoardViewController *dash = [[ADDashBoardViewController alloc] initWithStyle:UITableViewStyleGrouped];
//  ADDashBoardViewController *dash = [ADDashBoardViewController new];
  JASidePanelController *side = [JASidePanelController new];
  side.leftFixedWidth = 280;
  side.leftPanel = [[ADLeftBarViewController alloc] initWithStyle:UITableViewStyleGrouped];
  self.homeNavigation = [[UINavigationController alloc] initWithRootViewController:dash];
  side.centerPanel = self.homeNavigation;
  self.homeNavigation.navigationBar.translucent = NO;

  [self.window setRootViewController:side];
  [self displayTerms];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) appTheme
{
  //set status bar with white color
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  //navi blue color
  UIColor *naviColor = [UIColor colorWithRed:32/255.0f green:144/255.0f blue:183/255.0f alpha:1.0f];
  //convert uicolor to uiimage
  UIImage *image = [self imageWithColor:naviColor];
  //set navi color
  [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  //set navigation button color
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  //create navi font
  NSDictionary *naviAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                            fontWithName:@"Helvetica" size:55/2.5], NSFontAttributeName,
                              [UIColor whiteColor], NSForegroundColorAttributeName, nil];
  //set navi font
  [[UINavigationBar appearance] setTitleTextAttributes:naviAttribute];
  
  //set font
//  [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
//  [[UILabel appearance] setTextColor:[UIColor blueColor]];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}


#pragma mark - Terms and Condition

- (void) displayTerms
{
  BOOL read = (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:@"doneReadingTC"];
  //  NSLog(@"read is %@", read?@"YES":@"NO");
  if (!read) {
    ADTermConditionViewController *terms = [[ADTermConditionViewController alloc] init];
    terms.fromSetting = NO;
    [self.homeNavigation pushViewController:terms animated:YES];
    //    WCSQLite *sql = [WCSQLite initialize];
    //    [sql createBloodPressureTable];
    //    [sql createWeightScaleTable];
    //    [sql createBCATable];
    //ccz: create tables;
    [ADBloodPressure createTable];
    [ADWeightScale createTable];
    [ADActivityMonitor createTable];
    //    set HV connection to NO
//    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isConnected"];
    
  }
}


@end
