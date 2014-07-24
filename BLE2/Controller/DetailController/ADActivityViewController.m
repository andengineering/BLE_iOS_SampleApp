//
//  ADActivityViewController.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/7/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADActivityViewController.h"
#import "ADBloodPressure.h"

@interface ADActivityViewController ()

@property(nonatomic) int numberOfCells;
@property (strong, nonatomic) WCBPGraphView *pulseGraphView;
@property (strong, nonatomic) WCBPGraphView *graphView;
@property (strong, nonatomic) WCTouchView *sysDiaTouchView;
@property (strong, nonatomic) WCTouchView *pulseTouchView;
@property (strong, nonatomic) UILabel *systolic;
@property (strong, nonatomic) UILabel *diastolic;
@property (strong, nonatomic) UILabel *pulse;
@property (strong, nonatomic) UILabel *time;

@end

@implementation ADActivityViewController

@synthesize numberOfCells;

#pragma mark - WCBPDataSource methods
- (NSInteger)BPGraphViewDataCount:(WCBPGraphView *)graphView {
  return [ADBloodPressure count];
}
- (NSArray *)BPGraphViewData:(WCBPGraphView *)graphView {
  return [ADBloodPressure listOfMeasurement:ASC];
}
- (NSInteger)BPGraphViewMaxSystolic:(WCBPGraphView *)graphView {
  return [ADBloodPressure maxValue:@"Systolic"];
}
- (NSInteger)BPGraphViewMinDiastolic:(WCBPGraphView *)graphView {
  return [ADBloodPressure minValue:@"Diastolic"];
}
-(NSInteger)BPGraphViewMaxPulse:(WCBPGraphView *)graphView {
  return [ADBloodPressure maxValue:@"Pulse"];
}
-(NSInteger)BPGraphViewMinPulse:(WCBPGraphView *)graphView {
  return [ADBloodPressure minValue:@"Pulse"];
}

#pragma mark - WCBPSysDiaTouchSource method

- (void)gotDisplayReading:(ADBloodPressure *)reading
{
  NSLog(@"gotDisplay reading!");
  self.systolic.text = [NSString stringWithFormat:@"%d", [reading.systolic intValue]];
  self.diastolic.text = [NSString stringWithFormat:@"%d", [reading.diastolic intValue]];
  self.pulse.text = [NSString stringWithFormat:@"%d", [reading.WCPulse intValue]];
  self.time.text = [WCTime convertDateTimeToFixedFormat:reading.measurementReceivedTime];
  [self.view setNeedsDisplay];
}
- (NSInteger)WCTouchViewDataCount:(WCTouchView *)graphView {
  return [ADBloodPressure count];
}
- (NSArray *)WCTouchViewData:(WCTouchView *)graphView {
  return [ADBloodPressure listOfMeasurement:ASC];
}
- (NSInteger)WCTouchViewMaxSystolic:(WCTouchView *)graphView {
  return [ADBloodPressure maxValue:@"Systolic"];
}
- (NSInteger)WCTouchViewMinDiastolic:(WCTouchView *)graphView {
  return [ADBloodPressure minValue:@"Diastolic"];
}
- (NSInteger)WCTouchViewMaxPulse:(WCTouchView *)graphView {
  return [ADBloodPressure maxValue:@"Pulse"];
}
- (NSInteger)WCTouchViewMinPulse:(WCTouchView *)graphView {
  return [ADBloodPressure minValue:@"Pulse"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.navigationItem.title = @"Activity";
      self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//  UIImage *image = [UIImage imageNamed:@"white_box_bg"];
//  UIImageView *background = [[UIImageView alloc] initWithImage:image];
//  background.frame = CGRectMake(5, 5, background.bounds.size.width, background.bounds.size.height);
  UIView *background = [[UIView alloc] initWithFrame:CGRectMake(6, 6, self.view.bounds.size.width - 12, self.view.bounds.size.height - 120)];
  background.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0];
  background.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
  background.layer.borderWidth = 2.0f;
//  background.center = self.view.center;
  [self.view addSubview:background];
  [self drawGraph];
  
  [self drawDisplayView];
}

- (void)drawGraph
{
//  int y = 20;
//  if (isIOS7) y += 175;
//  int y2 = y + 200;
//  if (!IS_IPHONE_5) y2 = y2 - 20;
  CGFloat x = 20;
  CGFloat height = self.view.bounds.size.height / 2.5;
  CGFloat width = self.view.bounds.size.width - 40;
  CGFloat y = self.view.bounds.size.height - height - 10 - 120;
//  UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"graph_bg-01"]];
  UIColor *background = [UIColor clearColor];
  self.graphView = [[WCBPGraphView alloc] initWithFrame:CGRectMake(x, y, width, height)];
  self.graphView.dataSource = self;
  self.graphView.dataType = BPSysDia;
  self.graphView.backgroundColor = background;
  
  self.sysDiaTouchView = [[WCTouchView alloc] initWithFrame:CGRectMake(x, y, width, height)];
  self.sysDiaTouchView.dataSource = self;
  self.sysDiaTouchView.dataType = BPSysDia;
  self.sysDiaTouchView.backgroundColor = [UIColor clearColor];
  
//  self.pulseGraphView = [[WCBPGraphView alloc] initWithFrame:CGRectMake(20, y2, 280, 160)];
//  self.pulseGraphView.dataSource = self;
//  self.pulseGraphView.dataType = BPPulse;
//  self.pulseGraphView.backgroundColor = background;
//  
//  self.pulseTouchView = [[WCTouchView alloc] initWithFrame:CGRectMake(20, y2, 280, 160)];
//  self.pulseTouchView.dataSource = self;
//  self.pulseTouchView.dataType = BPPulse;
//  self.pulseTouchView.backgroundColor = [UIColor clearColor];
  
  
  [self.view addSubview:self.graphView];
  [self.view addSubview:self.sysDiaTouchView];
//  [self.view addSubview:self.pulseGraphView];
//  [self.view addSubview:self.pulseTouchView];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.graphView setNeedsDisplay];
  [self.sysDiaTouchView setNeedsDisplay];
  [self.pulseGraphView setNeedsDisplay];
  [self.pulseTouchView setNeedsDisplay];
}

- (void)drawDisplayView
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 170)];
//  view.layer.borderColor = [UIColor blackColor].CGColor;
//  view.layer.borderWidth = 2.0f;
//  self.systolic = [self bpName:@"Systolic" andRect:CGRectMake(20, 20, 80, 60)];
  self.time = [[UILabel alloc] initWithFrame:CGRectMake(225, 0, 100, 40)];
  self.time.font = [UIFont fontWithName:@"Helvetica" size:10];
  self.time.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
  self.time.adjustsFontSizeToFitWidth = YES;
  [view addSubview:self.time];
  [view addSubview:[self bpName:@"Systolic" andRect:CGRectMake(20, 20, 80, 60)]];
  [view addSubview:[self bpName:@"Diastolic" andRect:CGRectMake(140, 20, 80, 60)]];
  [view addSubview:[self bpName:@"Pulse Rate" andRect:CGRectMake(20, 90, 240, 60)]];
  [self.view addSubview:view];
  
}

- (UIView *)bpName:(NSString *)name andRect: (CGRect) rect
{
  CGFloat diff = 20.0f;
  UIView *view = [[UIView alloc] initWithFrame:rect];
  UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - diff)];
  if ([name isEqualToString:@"Systolic"]) {
    self.systolic = num;
    num.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  } else if ([name isEqualToString:@"Diastolic"]) {
    self.diastolic = num;
    num.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  } else if ([name isEqualToString:@"Pulse Rate"]) {
    self.pulse = num;
    num.textColor = [UIColor colorWithRed:246/255.0 green:170/255.0 blue:92/255.0 alpha:1.0];
    num.frame = CGRectMake(170, 0, 80, 60);
  }
  num.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
  num.adjustsFontSizeToFitWidth = YES;
  num.textAlignment = NSTextAlignmentCenter;
  num.text = [NSString stringWithFormat:@"%d", 0];
  UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height-diff, rect.size.width, 20)];
  text.font = [UIFont fontWithName:@"Helvetica" size:20];
  if ([name isEqualToString:@"Pulse Rate"]) {
    text.frame = CGRectMake(0, 0, rect.size.width- 60, rect.size.height);
    text.font = [UIFont fontWithName:@"Helvetica" size:35];

  }
  text.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
  text.text = name;
  text.textAlignment = NSTextAlignmentCenter;
  text.adjustsFontSizeToFitWidth = YES;
  //  view.layer.borderColor = [UIColor blueColor].CGColor;
  //  view.layer.borderWidth = 1.0f;
  //  num.layer.borderColor = [UIColor blueColor].CGColor;
  //  num.layer.borderWidth = 1.0f;
  //  text.layer.borderColor = [UIColor blueColor].CGColor;
  //  text.layer.borderWidth = 1.0f;
  [view addSubview:num];
  [view addSubview:text];
  return view;
}
@end
