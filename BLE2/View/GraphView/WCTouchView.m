//
//  WCTouchView.m
//  Wellness
//
//  Created by Chenchen Zheng on 10/9/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import "WCTouchView.h"
#import "ADBloodPressure.h"
#import "ADWeightScale.h"

@interface WCTouchView ()

@property (nonatomic) UITouch *touch;
@property (nonatomic) CGFloat viewHorizontalLimit;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation WCTouchView
{
  CGPoint   _touchPoint;
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect
{
  NSArray *dataArray = [self.dataSource WCTouchViewData:self];
  if (dataArray.count == 0) {
  //create another view say no more!
    self.noDataLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.noDataLabel.text = NSLocalizedString(@"TakeAMeasurement", nil);
    self.noDataLabel.textColor = [UIColor whiteColor];
    self.noDataLabel.backgroundColor = [UIColor clearColor];
    [self.noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.noDataLabel];
    return;
  } else {
    for (UIView *view in [self subviews]) {
      [view removeFromSuperview];
    }
  }
  if(self.touch){
    [self drawLineOnTouch:_touchPoint];
    [self drawBubble:self.bounds touchPoint:_touchPoint];
  }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  self.touch = [touches anyObject];
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  _touchPoint = touchPoint;
  [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  self.touch = [touches anyObject];
  CGPoint touchPoint = [[touches anyObject] locationInView:self];
  _touchPoint = touchPoint;
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  self.touch =nil;
//  [self setNeedsDisplay];
//  [UIView transitionWithView: self duration:0.5
//                     options: UIViewAnimationOptionTransitionCrossDissolve
//                  animations: ^{ [self.layer displayIfNeeded]; }
//                  completion: nil];
}


- (void)drawLineOnTouch:(CGPoint)touchPoint {
  UIBezierPath *path = [UIBezierPath bezierPath];
  CGFloat myTouchPointX = touchPoint.x;
  CGPoint start = CGPointMake(myTouchPointX, 0);
  CGPoint end   = CGPointMake(myTouchPointX, self.bounds.size.height);
  [[UIColor blackColor] setStroke];
  [path setLineWidth:2.0];
  [path moveToPoint:start];
  [path addLineToPoint:end];
  [path stroke];
}

- (void)drawBubble:(CGRect)dataRect touchPoint:(CGPoint)touchPoint {
//  NSLog(@"drawBubble?");
  [[UIColor whiteColor] setFill];
  UIFont *font = [UIFont systemFontOfSize:12.0];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  CGFloat myTouchPointX = touchPoint.x;
  CGContextTranslateCTM(ctx, CGRectGetMinX(dataRect), 30.0);
//  CGRect graphRect = [self rectView];
  WCGraphType graphType = WCLine;
  if (self.dataType == BPSysDia) {
    graphType = WCBar;
  }
  NSUInteger now = [self findCurrentDataPoint:touchPoint rect:self.bounds withGraphType:graphType];
  NSString *bubblelabel;
  //ccz: this if statement if for testing if we are out of bounds
  if (now <= [self.dataSource WCTouchViewDataCount:self]) {
    ADBloodPressure *bp = [[self.dataSource WCTouchViewData:self] objectAtIndex:now];
    ADWeightScale *ws = [[self.dataSource WCTouchViewData:self] objectAtIndex:now];
//    WCBCA *bca = [[self.dataSource WCTouchViewData:self] objectAtIndex:now];

    NSDictionary *weightUnit;
    if (self.dataType == WSWeight)
      weightUnit = [ws printProperWeight];
//    else if (self.dataType == BCAWeight)
//      weightUnit = [bca printProperWeight];
    switch (self.dataType) {
      case BPSysDia:
//        bubblelabel = [NSString stringWithFormat: @"%@ \n SYS./DIA.: %.0f/%.0f",  bp.measurementTime , [bp.systolic floatValue], [bp.diastolic floatValue]];
        [self.dataSource gotDisplayReading:bp];
        break;
      case BPPulse:
        bubblelabel = [NSString stringWithFormat: @"%@ \n Pulse: %.0f", bp.measurementTime, [bp.WCPulse floatValue]];
        break;
      case WSWeight:
        bubblelabel = [NSString stringWithFormat:@"%@ \n Weight: %@ %@", ws.measurementTime, [weightUnit objectForKey:@"weight"], [weightUnit objectForKey:@"unit"]];
        break;
      case WSBMI:
        bubblelabel = [NSString stringWithFormat:@"%@ \n BMI: %0.2f", ws.measurementTime, [ws.bmi floatValue]];
        break;
      default:
        break;
    }
  } else return;
  
//  CGSize bubblesize = [bubblelabel sizeWithFont:font];
//  CGSize bubblesize = CGSizeMake(40, 10);
//  CGFloat mybubbleWidth = self.bounds.size.width;
//  CGFloat mybubbleHeight = bubblesize.height*2;
//  CGFloat bubbleRectOrigX = 0;
  
//  if((myTouchPointX+mybubbleWidth)>= CGRectGetMaxX(dataRect)){
//    bubbleRectOrigX = CGRectGetMaxX(dataRect)-mybubbleWidth;//0.0-(myTouchPointX+0.5*mybubbleWitdth-CGRectGetMaxX(dataRect));
//  }else if ((myTouchPointX-0.5*mybubbleWidth) <= CGRectGetMinX(dataRect)){
//    bubbleRectOrigX = CGRectGetMinX(dataRect);
//  }else{
//    bubbleRectOrigX = myTouchPointX - 0.5*mybubbleWidth;
//  }
//  CGRect monthRect = CGRectMake(bubbleRectOrigX, 0.0-mybubbleHeight, mybubbleWidth, mybubbleHeight);
  
//  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:monthRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
//  [path addClip];
//  UIRectFill(monthRect);
//  [[UIColor blackColor] setFill];
  
//  [bubblelabel drawInRect:monthRect withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
//  CGContextRestoreGState(ctx);
}
/*
 * This function is used to find points on the graph, however, point location no longer needed imo since 
 * App don't draw point on graph anymore
 */
- (NSInteger) findCurrentDataPoint : (CGPoint)touch rect: (CGRect)rect withGraphType: (WCGraphType) graphType
{
  NSUInteger dataPoints = [self.dataSource WCTouchViewDataCount:self];
  CGFloat horizontalSpacing = rint((CGRectGetWidth(rect)) / ((CGFloat)dataPoints+1));
  CGFloat myTouchPointX = touch.x;
    CGFloat current = myTouchPointX / horizontalSpacing;
  if (graphType == WCLine) {
    current -= 1;
  } else if (graphType == WCBar) {
    current -= 0.5;
  }

  if(current >= dataPoints){
    current = dataPoints-1;
  }
  return current ;
}



@end
