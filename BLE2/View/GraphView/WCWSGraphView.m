//
//  WCWSGraphView.m
//  Wellness
//
//  Created by Chenchen Zheng on 10/27/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCWSGraphView.h"
#import "ADWeightScale.h"

@implementation WCWSGraphView

- (void)drawRect:(CGRect)rect
{
  if ([[self.dataSource WSGraphViewData:self] count] == 0) {
    return;
  }
  [self pathFromDataInRect:self.bounds];
}

/*****************************************************************************************************
 *************************************line graph******************************************************
 ****************************************************************************************************/
- (UIBezierPath *)pathFromDataInRect:(CGRect)rect {
//  ccz: setup value
  CGFloat max = [self.dataSource WSGraphViewMaxWeight: self] + 10;
  CGFloat min = [self.dataSource WSGraphViewMinWeight: self] - 10;
  if (self.dataType == WSBMI) {
    max = [self.dataSource WSGraphViewMaxBMI:self] + 10;
    min = [self.dataSource WSGraphViewMinBMI:self] - 10;
  }
  
  NSArray *array = [self.dataSource WSGraphViewData:self];
  
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
  CGFloat dataPoint = [[[array objectAtIndex:0] WSWeight] doubleValue];
  if (self.dataType == WSBMI) {
    dataPoint = [[[array objectAtIndex:0] bmi] doubleValue];
  }
  CGPoint initialDataPoint = CGPointMake(lineWidth / 2.0, (max - dataPoint) * verticalScale);
  [path moveToPoint:initialDataPoint];
  
  for(NSUInteger i = 1; i < [array count] - 1; i++) {
    dataPoint = [[[array objectAtIndex:i] WSWeight] doubleValue];
    if (self.dataType == WSBMI) {
      dataPoint = [[[array objectAtIndex:i] bmi] doubleValue];
    }
    [path addLineToPoint:CGPointMake((i + 1) * horizontalSpacing, CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  }
  
  dataPoint = [[[array lastObject] WSWeight] doubleValue];
  if (self.dataType == WSBMI) {
    dataPoint = [[[array lastObject] bmi] doubleValue];
  }
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  [[UIColor whiteColor] setStroke];
  [path stroke];
  
  return path;
}
@end
