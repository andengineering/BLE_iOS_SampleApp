//
//  ADDashBoardCell.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADDashBoardCell.h"
#import "ADActivityMonitor.h"
#import "ADBloodPressure.h"
#import "ADWeightScale.h"

@implementation ADDashBoardCell

#define IPHONE_WIDTH                  ((int) 312)
#define SECTION_CELL_X_LEFT_MARGIN    ((int) 6)
#define SECTION_CELL_WIDTH            ((int) 308)
#define SECTION_CELL_X_HEIGHT         ((int) 350/2)


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (id)initWithType:(ADDashBoardCellStyle)style withView:(UIView *)view
{
  self = [super init];
  if (self) {
    self.selectionStyle = UITableViewCellEditingStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.cellView = [[UIView alloc] initWithFrame:CGRectMake(SECTION_CELL_X_LEFT_MARGIN, 0, view.bounds.size.width - 12, view.bounds.size.height/3 - 7)];
    self.cellView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0];
    
    self.cellView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
    self.cellView.layer.borderWidth = 2.0f;
    self.info = [[UIView alloc] initWithFrame:CGRectMake(SECTION_CELL_X_LEFT_MARGIN-2, 35, view.bounds.size.width - 20, view.bounds.size.height/3 - 50)];
//    self.info.layer.borderColor = [UIColor blackColor].CGColor;
//    self.info.layer.borderWidth = 2.0f;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
      NSLog(@"i'm ipad");
      self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.info.bounds.size.width*2/3, self.info.bounds.size.height/5)];
      self.title.font = [UIFont fontWithName:@"Helvetica" size:30];
      self.title.adjustsFontSizeToFitWidth = YES;
      self.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(self.info.bounds.size.width - 150, 0, 150, 40)];
      self.timeStamp.font = [UIFont fontWithName:@"Helvetica" size:20];
    } else {
      self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
      self.title.font = [UIFont fontWithName:@"Helvetica" size:18];
      self.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(225, 0, 100, 40)];
      self.timeStamp.font = [UIFont fontWithName:@"Helvetica" size:10];
    }
//    self.title.layer.borderColor = [UIColor blackColor].CGColor;
//    self.title.layer.borderWidth = 2.0f;
    self.title.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
    self.timeStamp.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
    self.timeStamp.adjustsFontSizeToFitWidth = YES;
    switch (style) {
      case Activity:
      {
        self.title.text = @"Activity Monitor";
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steps_icon"]];
      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        NSLog(@"i'm ipad");
        self.logo.frame = CGRectMake(10, self.info.bounds.size.height/9, self.logo.bounds.size.width, self.logo.bounds.size.height);
      } else {
        self.logo.frame = CGRectMake(10, 10, self.logo.bounds.size.width, self.logo.bounds.size.height);
      }
        ADActivityMonitor *am = [[ADActivityMonitor alloc] initWithLatestMeasurement];
        [self.info addSubview:[self stepView:[am.steps intValue]]];
        NSMutableArray *misc = [[NSMutableArray alloc] init];
      if (am.distances != nil)
        [misc addObject:[am.distances stringValue]];
      if (am.calories != nil)
        [misc addObject:[am.calories stringValue]];
      if (am.sleep != nil) {
        [misc addObject:[am.sleep stringValue]];
      }
        [self.info addSubview:[self amMiscView: misc]];
//        self.timeStamp.text = [WCTime convertDateTimeToFixedFormat:am.measurementReceivedTime];
      self.timeStamp.text = am.measurementReceivedTime;
      
//        self.logo.layer.borderColor = [UIColor blueColor].CGColor;
//        self.logo.layer.borderWidth = 1.0f;
      }
        break;
      case BloodPressure:
      {
        self.title.text = @"Blood Pressure Monitor";
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sys_dias_icon"]];
        self.logo.frame = CGRectMake(10, 40, self.logo.bounds.size.width, self.logo.bounds.size.height);
      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        NSLog(@"i'm ipad");
        self.logo.frame = CGRectMake(10, self.info.bounds.size.height/3, self.logo.bounds.size.width, self.logo.bounds.size.height);
      }
//        self.timeStamp.text = @"1/6/13 3.06PM";
        ADBloodPressure *bp = [[ADBloodPressure alloc] initWithLatestMeasurement];
        [self.info addSubview:[self bpView:bp]];
//        self.timeStamp.text = bp.measurementReceivedTime ;
//      self.timeStamp.text = [WCTime convertDateTimeToFixedFormat:bp.measurementReceivedTime];
      self.timeStamp.text = bp.measurementReceivedTime;

      }
        break;
      case WeightSacle:
      {
        self.title.text = @"Weight Scale";
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ws_icon"]];
        self.logo.frame = CGRectMake(10, 40, self.logo.bounds.size.width, self.logo.bounds.size.height);
      if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        NSLog(@"i'm ipad");
        self.logo.frame = CGRectMake(10, self.info.bounds.size.height/3, self.logo.bounds.size.width, self.logo.bounds.size.height);
      }
        ADWeightScale *ws = [[ADWeightScale alloc] initWithLatestMeasurement];
        [self.info addSubview:[self wsView:ws]];
//        self.timeStamp.text = [WCTime convertDateTimeToFixedFormat:ws.measurementReceivedTime];
      self.timeStamp.text = ws.measurementReceivedTime;

      }
        break;
      default:
        break;
    }
    [self.info addSubview:self.logo];
    [self.cellView addSubview:self.info];
    [self.cellView addSubview:self.title];
    [self.cellView addSubview:self.timeStamp];
    [self.contentView addSubview:self.cellView];
  }
  return self;
}

- (UIView *)stepView:(int) step
{

  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 150, 70)];
  UILabel *steps = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 45)];
  UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, 150, 25)];
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footprint_icon"]];
  image.frame = CGRectMake(0, 45, image.bounds.size.width, image.bounds.size.height);
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    NSLog(@"i'm ipad");
    view = [[UIView alloc] initWithFrame:CGRectMake(self.info.bounds.size.width/5, self.info.bounds.size.height/9, self.info.bounds.size.width*3/5, self.info.bounds.size.height/3)];
  }
  steps.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  steps.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:60];
  steps.adjustsFontSizeToFitWidth = YES;
  steps.text = [NSString stringWithFormat:@"%d", step];
  text.font = [UIFont fontWithName:@"Helvetica" size:22];
  text.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
  text.text = @"  Total Steps";
//  view.layer.borderColor = [UIColor blueColor].CGColor;
//  view.layer.borderWidth = 1.0f;
//  steps.layer.borderColor = [UIColor blackColor].CGColor;
//  steps.layer.borderWidth = 1.0f;
  [view addSubview:image];
  [view addSubview:steps];
  [view addSubview:text];
  return view;
}

- (UIView *)amMiscView:(NSArray *)data
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 75, 280, 45)];
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    NSLog(@"i'm ipad");
    view = [[UIView alloc] initWithFrame:CGRectMake(10, self.info.bounds.size.height*3/5, self.info.bounds.size.width - 20, self.info.bounds.size.height * 2/5 - 20)];
  }

  UIImageView *road = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miles_icon"]];
  road.frame = CGRectMake(5, 10, road.bounds.size.width, road.bounds.size.height);
  UIImageView *fire = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_icon"]];
  fire.frame = CGRectMake(100, 3, fire.bounds.size.width, fire.bounds.size.height);
  UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_icon"]];
  heart.frame = CGRectMake(200, 13, heart.bounds.size.width, heart.bounds.size.height);
  UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 45)];
  text.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
//  text.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
//  text.text = @"                     Miles                     Cal              BPM";
  UILabel *distant = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 50, 45)];
  distant.font =[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
  distant.textColor = [UIColor colorWithRed:101/255.0 green:181/255.0 blue:44/255.0 alpha:1.0];
  distant.adjustsFontSizeToFitWidth = YES;
  
  UILabel *cal = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 50, 45)];
  cal.font =[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];

  cal.textColor = [UIColor colorWithRed:255/255.0 green:191/255.0 blue:65/255.0 alpha:1.0];
  cal.adjustsFontSizeToFitWidth = YES;
  UILabel *pulse = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 50, 45)];
  pulse.font =[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
  pulse.textColor = [UIColor colorWithRed:248/255.0 green:79/255.0 blue:88/255.0 alpha:1.0];
  pulse.adjustsFontSizeToFitWidth = YES;
  if (data.count) {
    distant.text = [data objectAtIndex:0];
    cal.text = [data objectAtIndex:1];
    pulse.text = [data objectAtIndex:2];
  }
//  distant.layer.borderColor = [UIColor greenColor].CGColor;
//  distant.layer.borderWidth = 1.0f;
//  cal.layer.borderColor = [UIColor orangeColor].CGColor;
//  cal.layer.borderWidth = 1.0f;
//  pulse.layer.borderColor = [UIColor redColor].CGColor;
//  pulse.layer.borderWidth = 1.0f;
//  view.layer.borderColor = [UIColor blackColor].CGColor;
//  view.layer.borderWidth = 1.0f;
  [view addSubview:cal];
  [view addSubview:pulse];
  [view addSubview:distant];
  [view addSubview:text];
  [view addSubview:road];
  [view addSubview:fire];
  [view addSubview:heart];
  return view;
}

- (UIView *)bpView:(ADBloodPressure *)bp
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 40, 230, 60)];
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    NSLog(@"i'm ipad");
    view = [[UIView alloc] initWithFrame:CGRectMake(60, self.info.bounds.size.height/3, 230, 60)];
  }
  UILabel *sys = [[UILabel alloc] initWithFrame:view.bounds];
  sys.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30];
  sys.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  sys.adjustsFontSizeToFitWidth = YES;
  sys.text = [NSString stringWithFormat:@"SYS: %@ DIA: %@ PUL: %@", bp.systolic, bp.diastolic, bp.WCPulse];
//  view.layer.borderColor = [UIColor blackColor].CGColor;
//  view.layer.borderWidth = 1.0f;
//  [view addSubview:sys];
  [view addSubview:[self bpNumber:[bp.systolic intValue] name:@"Systolic" andRect:CGRectMake(0, 0, 80, 60)]];
  [view addSubview:[self bpNumber:[bp.diastolic intValue] name:@"Diastolic" andRect:CGRectMake(80, 0, 80, 60)]];
  [view addSubview:[self bpNumber:[bp.WCPulse intValue] name:@"Pulse" andRect:CGRectMake(160, 0, 80, 60)]];
  return view;
}

- (UIView *)bpNumber:(int)number name:(NSString *)name andRect: (CGRect) rect
{
  CGFloat diff = 20.0f;
  UIView *view = [[UIView alloc] initWithFrame:rect];
  UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - diff)];
  if ([name isEqualToString:@"Pulse"])
    num.textColor = [UIColor colorWithRed:246/255.0 green:170/255.0 blue:92/255.0 alpha:1.0];
  else
    num.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  num.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
  num.adjustsFontSizeToFitWidth = YES;
  num.textAlignment = NSTextAlignmentCenter;
  num.text = [NSString stringWithFormat:@"%d", number];
  UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height-diff, rect.size.width, 20)];
  text.font = [UIFont fontWithName:@"Helvetica" size:20];
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
- (UIView *)wsView:(ADWeightScale *)ws
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 40, 230, 60)];
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    NSLog(@"i'm ipad");
    view = [[UIView alloc] initWithFrame:CGRectMake(60, self.info.bounds.size.height/3, 230, 60)];
  }
  UILabel *weight = [[UILabel alloc] initWithFrame:view.bounds];
  weight.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
  weight.textColor = [UIColor colorWithRed:83/255.0 green:190/255.0 blue:232/255.0 alpha:1.0];
  weight.adjustsFontSizeToFitWidth = YES;
  if (ws.WSWeight == NULL) {
    weight.text = [NSString stringWithFormat:@"0kg"];
  } else
    weight.text = [NSString stringWithFormat:@"%@%@", ws.WSWeight,ws.units];
  weight.textAlignment = NSTextAlignmentCenter;
//  view.layer.borderColor = [UIColor blackColor].CGColor;
//  view.layer.borderWidth = 1.0f;
  [view addSubview:weight];
  return view;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
