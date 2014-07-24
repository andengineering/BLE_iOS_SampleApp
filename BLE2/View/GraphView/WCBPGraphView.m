//
//  WCBPGraphView.m
//  Wellness
//
//  Created by Chenchen Zheng on 10/9/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCBPGraphView.h"
#import "ADBloodPressure.h"

@implementation WCBPGraphView

- (void)drawRect:(CGRect)rect
{
  if ([[self.dataSource BPGraphViewData:self] count] == 0) {
    return;
  }
  if (self.dataType == BPSysDia) {
    [self drawLimit:self.bounds];
    [self drawVolumeDataInRect:self.bounds];
  } else if (self.dataType == BPPulse) {
    [self pathFromDataInRect:self.bounds];
  }
}


- (void)drawLimit:(CGRect)volumeGraphRect
{
  CGFloat max = [self.dataSource BPGraphViewMaxSystolic:self];
  CGFloat min = [self.dataSource BPGraphViewMinDiastolic:self];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect rect = CGRectMake(0, 0, 0, 0);
  NSString *string = [NSString stringWithFormat:@"%f", max];
  UIFont *font = [UIFont fontWithName:@"Courier" size:10];
  
  /// Make a copy of the default paragraph style
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  /// Set line break mode
  paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
  /// Set text alignment
  paragraphStyle.alignment = NSTextAlignmentRight;
  
  NSDictionary *attributes = @{ NSFontAttributeName: font,
                                NSParagraphStyleAttributeName: paragraphStyle };
  
  [string drawInRect:rect withAttributes:attributes];
  
}

/*****************************************************************************************************
 *************************************volume graph****************************************************
 ****************************************************************************************************/
- (void)drawVolumeDataInRect:(CGRect)volumeGraphRect {

  CGFloat maxVolume = [self.dataSource BPGraphViewMaxSystolic:self] + 10;
  NSLog(@"maxVolume is %0.0f", maxVolume);
  
  
  CGFloat minVolume = [self.dataSource BPGraphViewMinDiastolic:self];
//  if (minVolume == 0) {
//    minVolume = 1;
//  }
  NSArray *array = [self.dataSource BPGraphViewData:self];
//  CGFloat verticalScale =  CGRectGetHeight(volumeGraphRect) / (maxVolume - minVolume);
  NSInteger count = [self.dataSource BPGraphViewDataCount:self];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  CGFloat lineSpacing = rint(CGRectGetWidth(volumeGraphRect) / (count + 1));
  [[UIColor whiteColor] setStroke];
  
  for (int i = 0; i < count; i++) {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (lineSpacing > 10.0) {
      [path setLineWidth:10.0];
    } else [path setLineWidth:lineSpacing];
    ADBloodPressure *bp = [array objectAtIndex:i];
    CGFloat sysValue = [bp.systolic floatValue];
    CGFloat diaValue = [bp.diastolic floatValue];
//    NSLog(@"first point is %0.1f", CGRectGetHeight(volumeGraphRect) -  15/minVolume * diaValue);
//    NSLog(@"second point is %0.1f", (CGRectGetHeight(volumeGraphRect)/maxVolume*(maxVolume - sysValue)));
//    [path moveToPoint:CGPointMake((i+1) * lineSpacing, 1/maxVolume * sysValue + 20) ];
//    [path addLineToPoint:CGPointMake((i+1) * lineSpacing, CGRectGetHeight(volumeGraphRect) - (CGRectGetHeight(volumeGraphRect)/minVolume*(minVolume - diaValue))- 20)];
    [path moveToPoint:CGPointMake((i+1) * lineSpacing, CGRectGetHeight(volumeGraphRect) -  15/minVolume * diaValue) ];
    [path addLineToPoint:CGPointMake((i+1) * lineSpacing, (CGRectGetHeight(volumeGraphRect)/maxVolume*(maxVolume - sysValue)))];

    [[self drawWHOBarSelectColorUsingSystolic:sysValue andDiastolic:diaValue] setStroke];
    [path stroke];
  }
  CGContextRestoreGState(ctx);
}

-(UIColor *)drawWHOBarSelectColorUsingSystolic:(CGFloat) systolic andDiastolic:(CGFloat) diastolic
{
  if (systolic >= 180 || diastolic >= 110 ){
    return [UIColor colorWithRed:236.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0];
  } else if ((160 <= systolic  && systolic < 180 ) ||
             (100 <= diastolic && diastolic < 110)){
    return [UIColor colorWithRed:241.0/255.0 green:101.0/255.0 blue:34.0/255.0 alpha:1.0];
  } else if ((140 <= systolic && systolic < 160 ) ||
             (90 <= diastolic && diastolic < 100 )){
    return [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:30.0/255.0 alpha:1.0];
  } else if((130 <= systolic && systolic < 140 ) ||
            ( 85 <= diastolic && diastolic < 90 )){
    return [UIColor colorWithRed:247.0/255.0 green:236.0/255.0 blue:50.0/255.0 alpha:1.0];
  } else if((120 <= systolic && systolic < 130 ) ||
            ( 80 <= diastolic && diastolic < 85 )){
    return [UIColor colorWithRed:139.0/255.0 green:197.0/255.0 blue:63.0/255.0 alpha:1.0];
  } else {
    return [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:75.0/255.0 alpha:1.0];
  }
}

/*****************************************************************************************************
 *************************************line graph******************************************************
 ****************************************************************************************************/
- (UIBezierPath *)pathFromDataInRect:(CGRect)rect {
  //  ccz: setup value
  CGFloat max = [self.dataSource BPGraphViewMaxPulse: self] + 10;
  CGFloat min = [self.dataSource BPGraphViewMinPulse: self] - 10;
  
  NSArray *array = [self.dataSource BPGraphViewData:self];
  
  UIBezierPath *path = [UIBezierPath bezierPath];
  /*
   Even though this lineWidth is odd, we don't do any offset because it will never line up with any pixels, just think geometrically.
   */
  
  CGFloat lineWidth = 3.0;
  [path setLineWidth:lineWidth];
  [path setLineJoinStyle:kCGLineJoinRound];
  [path setLineCapStyle:kCGLineCapRound];
  // Inset so the path does not ever go beyond the frame of the graph.
  rect = CGRectInset(rect, lineWidth / 2.0, lineWidth);
  CGFloat horizontalSpacing = (CGRectGetWidth(rect) / (CGFloat)[array count]);
  CGFloat verticalScale = CGRectGetHeight(rect) / (max - min);
  CGFloat dataPoint = [[[array objectAtIndex:0] WCPulse] doubleValue];
  CGPoint initialDataPoint = CGPointMake(lineWidth/2.0, (max - dataPoint) * verticalScale);
  [path moveToPoint:initialDataPoint];
  
  for(NSUInteger i = 1; i < [array count] - 1; i++) {
    dataPoint = [[[array objectAtIndex:i] WCPulse] doubleValue];
    [path addLineToPoint:CGPointMake((i + 1) * horizontalSpacing, CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  }
  
  dataPoint = [[[array lastObject] WCPulse] doubleValue];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  [[UIColor whiteColor] setStroke];
  [path stroke];
  
  return path;
}



@end
