//
//  WCBPGraphView.m
//  WellnessConnected
//
//  Created by Chenchen Zheng on 8/13/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCBPSysDiaGraphView.h"
#import "ADBloodPressure.h"
#import <QuartzCore/QuartzCore.h>

@interface WCBPSysDiaGraphView ()

@property (nonatomic) UITouch *touch;
@property (nonatomic) CGFloat viewHorizontalLimit;
@property (nonatomic) CGFloat currentSystolic;
@property (nonatomic) CGFloat currentDiastolic;
@property (nonatomic) NSString *currentTime;

@end

@implementation WCBPSysDiaGraphView
{
//  CGGradientRef _backgroundGradient;
  CGPoint _initialDataPoint;
  CGPoint _touchPoint;
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect
{
  NSArray *dataArray = [self.dataSource BPGraphViewInfos:self];
//  if no data don't create a view for no data yet!
  if (!dataArray || !dataArray.count) {
    //create another view say no more!
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:self.bounds];
    noDataLabel.text = NSLocalizedString(@"TakeAMeasurement", nil);
    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:noDataLabel];
    return;
  } else {
    for (UIView *view in [self subviews]) {
      [view removeFromSuperview];
    }
  }
  CGRect graphRect = [self rectView];
  // clip to the rounded rect
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
  [path addClip];
//  [self drawBackgroundGradient];
  [self drawDataInRect:graphRect];
  
  if(self.touch){ 
    [self drawLineOnTouch:_touchPoint];
//ccz:    call FindY early
    [self findY:_touchPoint rect:graphRect];
//    [self drawDot:graphRect touchPoint:_touchPoint];
    [self drawBubble:graphRect touchPoint:_touchPoint];
  }
}

/*
 * Draws the path for the closing price data set.
 */
- (void)drawDataInRect:(CGRect)rect {
  [[UIColor whiteColor] setStroke];
  UIBezierPath *path = [self pathFromDataInRect:rect];
  [path stroke];
  [[UIColor greenColor] setStroke];
  path = [self pathFromDataInRectDia:rect];
  [path stroke];
}

#pragma mark -
#pragma mark Draw Data

/*
 * The path for the closing data, this is used to draw the graph, and as part of the top and bottom clip paths.
 */
- (UIBezierPath *)pathFromDataInRect:(CGRect)rect {
  NSUInteger dataPoints = [self.dataSource BPGraphViewInfoCount:self];
  CGFloat maxSys = [self.dataSource BPGraphViewMaxSystolic:self] + 10;
//  NSLog(@"maxSys is %f", maxSys);
  CGFloat minSys = [self.dataSource BPGraphViewMinSystolic:self] - 10;
//  NSLog(@"minSys = %f", minSys);
  NSArray *dataArray = [self.dataSource BPGraphViewInfos:self];
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
  CGFloat horizontalSpacing = CGRectGetWidth(rect) / (CGFloat)dataPoints;
  CGFloat verticalScale =  CGRectGetHeight(rect) / (maxSys - minSys);
  CGFloat dataPoint = [[[dataArray objectAtIndex:0] systolic] doubleValue];
  _initialDataPoint = CGPointMake(lineWidth/2.0, (maxSys - dataPoint) * verticalScale);
  [path moveToPoint:_initialDataPoint];
  
  for(NSUInteger i = 1; i < dataPoints - 1; i++) {
    dataPoint = [[[dataArray objectAtIndex:i] systolic] doubleValue];
    [path addLineToPoint:CGPointMake((i + 1) * horizontalSpacing, CGRectGetMinY(rect) + (maxSys - dataPoint) * verticalScale)];
  }
//  self.tradingDataLimit = (tradingDays + 1)* horizontalSpacing;
  
  dataPoint= [[[dataArray lastObject] systolic] doubleValue];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (maxSys - dataPoint) * verticalScale)];
  
  return path;
}

- (CGRect)rectView {
//  CGFloat top = 57.0; // => text height + button height
                      //    CGFloat textHeight = 25.0;
                      //    CGFloat bottom = [self bounds].size.height - (textHeight + [self volumeGraphHeight]);
  CGFloat top = 0.0;
  CGFloat bottom = self.bounds.size.height;
  CGFloat left = 0.0;
  //    CGFloat right = CGRectGetWidth(self.bounds) - [self priceLabelWidth];
  CGFloat right = CGRectGetWidth(self.bounds);
  return CGRectMake(left, top, right, bottom - top);
}


/*
 * The path for the closing data, this is used to draw the graph, and as part of the top and bottom clip paths.
 */
- (UIBezierPath *)pathFromDataInRectDia:(CGRect)rect {
  NSUInteger dataPoints = [self.dataSource BPGraphViewInfoCount:self];
  CGFloat max = [self.dataSource BPGraphViewMaxDiastolic:self] + 10;
  //  NSLog(@"maxSys is %f", maxSys);
  CGFloat min = [self.dataSource BPGraphViewMinDiastolic:self] - 10;
  //  NSLog(@"minSys = %f", minSys);
  NSArray *dataArray = [self.dataSource BPGraphViewInfos:self];
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
  CGFloat horizontalSpacing = CGRectGetWidth(rect) / (CGFloat)dataPoints;
  CGFloat verticalScale =  CGRectGetHeight(rect) / (max - min);
  CGFloat dataPoint = [[[dataArray objectAtIndex:0] diastolic] doubleValue];
  _initialDataPoint = CGPointMake(lineWidth/2.0, (max - dataPoint) * verticalScale);
  [path moveToPoint:_initialDataPoint];
  
  for(NSUInteger i = 1; i < dataPoints - 1; i++) {
    dataPoint = [[[dataArray objectAtIndex:i] diastolic] doubleValue];
    [path addLineToPoint:CGPointMake((i + 1) * horizontalSpacing, CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  }
  //  self.tradingDataLimit = (tradingDays + 1)* horizontalSpacing;
  
  dataPoint= [[[dataArray lastObject] diastolic] doubleValue];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (max - dataPoint) * verticalScale)];
  
  return path;
}

#pragma mark - Background Gradient

/*
 * Creates the blue background gradient
 */
//- (CGGradientRef)backgroundGradient {
//  
//  if (NULL == _backgroundGradient) {
//    // Lazily create the gradient, then reuse it.
//    CGFloat colors[8] = {0.0 / 255.0, 0/ 255.0, 0 / 255.0, 1.0,
//      //            33.0 / 255.0, 47.0 / 255.0, 113.0 / 255.0, 1.0,
//      //            20.0 / 255.0, 33.0 / 255.0, 104.0 / 255.0, 1.0,
//      20.0 / 255.0, 33.0 / 255.0, 104.0 / 255.0, 1.0 };
//    CGFloat colorStops[4] = {0.0,  1.0};
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    _backgroundGradient = CGGradientCreateWithColorComponents(colorSpace, colors, colorStops, 2);
//    CGColorSpaceRelease(colorSpace);
//  }
//  return _backgroundGradient;
//}

/*
 Draws the blue background gradient.
 */
//- (void)drawBackgroundGradient {
//  CGContextRef ctx = UIGraphicsGetCurrentContext();
//  CGPoint startPoint = {0.0, 0.0};
//  CGPoint endPoint = {0.0, self.bounds.size.height};
//  CGContextDrawLinearGradient(ctx, [self backgroundGradient], startPoint, endPoint,0);
//}


#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  self.touch = [touches anyObject];
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  _touchPoint = touchPoint;
  
  [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  self.touch = [touches anyObject];
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  _touchPoint = touchPoint;
  
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  self.touch =nil;
  [self setNeedsDisplay];
  [UIView transitionWithView:self duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [self.layer displayIfNeeded];
                  } completion:nil];
}


- (void)drawLineOnTouch:(CGPoint)touchPoint {
  UIBezierPath *path = [UIBezierPath bezierPath];
  CGFloat myTouchPointX = touchPoint.x;
//  if(touchPoint.x >= self.tradingDataLimit){
//    myTouchPointX = self.tradingDataLimit;
//  }
  CGPoint start = CGPointMake(myTouchPointX, 20);
  CGPoint end   = CGPointMake(myTouchPointX, 300);
  [[UIColor whiteColor] setStroke];
  [path setLineWidth:1.0];
  [path moveToPoint:start];
  [path addLineToPoint:end];
  [path stroke];
}

- (void)drawDot:(CGRect)dataRect touchPoint:(CGPoint)touchPoint{
  CGFloat myTouchPointX = touchPoint.x;
//  if(touchPoint.x >= self.tradingDataLimit){
//    myTouchPointX = self.tradingDataLimit;
//  }
  CGFloat pointY = [self findY:touchPoint rect:dataRect];
  CGPoint myPoint = CGPointMake(myTouchPointX, pointY);
  UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:myPoint
                                                       radius:10
                                                   startAngle:0
                                                     endAngle:360
                                                    clockwise:YES];
  UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:myPoint
                                                       radius:5
                                                   startAngle:0
                                                     endAngle:360
                                                    clockwise:YES];
  [[UIColor redColor] setFill];
  [aPath fill];
  [[UIColor whiteColor] setFill];
  [bPath fill];
  //  NSArray *dailyTradeInfos = [self.dataSource graphViewDailyTradeInfos:self];
  //  UIBezierPath *path = [UIBezierPath bezierPath];
  //  CGPoint dot = CGPointMake(touchPoint.x, 30);
  //  [[UIColor redColor] setStroke];
  //  [path setLineWidth:2.0];
  //  [path moveToPoint:dot];
  //  [path ];
  
  
}

- (void)drawBubble:(CGRect)dataRect touchPoint:(CGPoint)touchPoint {
  
  [[UIColor whiteColor] setFill];
  UIFont *font = [UIFont systemFontOfSize:12.0];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  CGFloat myTouchPointX = touchPoint.x;
//  if(touchPoint.x >= self.tradingDataLimit){
//    myTouchPointX = self.tradingDataLimit;
//  }
  //CGContextTranslateCTM(ctx, myTouchPointX, 30.0);
  CGContextTranslateCTM(ctx, CGRectGetMinX(dataRect), 30.0);
  
  NSString *bubblelabel = [NSString stringWithFormat: @"%@ \n SYS./DIA.: %.0f/%.0f", self.currentTime, self.currentSystolic, self.currentDiastolic];
  
  
  CGSize bubblesize = [bubblelabel sizeWithFont:font];
  CGFloat mybubbleWidth = self.bounds.size.width;
  CGFloat mybubbleHeight = bubblesize.height*2;
  
  CGFloat bubbleRectOrigX = 0;
//  if((myTouchPointX+0.5*mybubbleWidth)>= CGRectGetMaxX(dataRect)){
  if((myTouchPointX+mybubbleWidth)>= CGRectGetMaxX(dataRect)){
    bubbleRectOrigX = CGRectGetMaxX(dataRect)-mybubbleWidth;//0.0-(myTouchPointX+0.5*mybubbleWitdth-CGRectGetMaxX(dataRect));
  }else if ((myTouchPointX-0.5*mybubbleWidth) <= CGRectGetMinX(dataRect)){
    bubbleRectOrigX = CGRectGetMinX(dataRect);
  }else{
    bubbleRectOrigX = myTouchPointX - 0.5*mybubbleWidth;
  }
  CGRect monthRect = CGRectMake(bubbleRectOrigX, 0.0-mybubbleHeight, mybubbleWidth, mybubbleHeight);
  
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:monthRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
  [path addClip];
  UIRectFill(monthRect);
  [[UIColor blackColor] setFill];
  
  [bubblelabel drawInRect:monthRect withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
  CGContextRestoreGState(ctx);
}

- (CGFloat) findY :(CGPoint)touch rect:(CGRect)rect
{
  NSUInteger dataPoints = [self.dataSource BPGraphViewInfoCount:self];
  CGFloat maxSys = [self.dataSource BPGraphViewMaxSystolic:self] + 10;
  //  CGFloat minClose = 0;
  CGFloat minSys = [self.dataSource BPGraphViewMinSystolic:self] - 10;
  NSArray *dataArray = [self.dataSource BPGraphViewInfos:self];
  
  CGFloat horizontalSpacing = CGRectGetWidth(rect) / (CGFloat)dataPoints;
  CGFloat verticalScale = CGRectGetHeight(rect) / (maxSys - minSys);
  CGFloat myTouchPointX = touch.x;
//  if(touch.x >= self.tradingDataLimit){
//    myTouchPointX = self.tradingDataLimit;
//  }
  NSUInteger daily = myTouchPointX / horizontalSpacing;
  if(daily >= dataPoints){
    daily = dataPoints-1;
  }
  self.currentTime = [[dataArray objectAtIndex:daily] measurementTime];
  self.currentSystolic = [[[dataArray objectAtIndex:daily] systolic] doubleValue];
  self.currentDiastolic = [[[dataArray objectAtIndex:daily] diastolic] doubleValue];
  CGFloat myPoint = CGRectGetMinY(rect) + (maxSys - self.currentSystolic) * verticalScale;
  return myPoint;
}

@end
