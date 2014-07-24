//
//  ADDetailViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//
#import "MHTabBarController.h"

#import "ADDetailViewController.h"
#import "ADDetailView.h"
#import "ADTopBarView.h"

@interface ADDetailViewController () <MHTabBarControllerDelegate>

@end

@implementation ADDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

      

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %lu", tabBarController, viewController, (unsigned long)index);
  
	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);
  
	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %lu", tabBarController, viewController, (unsigned long)index);
}

@end
