//
//  WCTouchView.h
//  Wellness
//
//  Created by Chenchen Zheng on 10/9/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WCGraphType) {
  WCLine,
  WCBar,
};

@class WCTouchView;

@protocol WCTouchSource <NSObject>
- (NSInteger)WCTouchViewDataCount:(WCTouchView *)graphView;
- (NSArray *)WCTouchViewData:(WCTouchView *)graphView;
@optional

- (void)gotDisplayReading:(id)reading;
- (NSInteger)WCTouchViewMaxSystolic:(WCTouchView *)graphView;
- (NSInteger)WCTouchViewMinDiastolic:(WCTouchView *)graphView;
- (NSInteger)WCTouchViewMaxPulse:(WCTouchView *) graphView;
- (NSInteger)WCTouchViewMinPulse:(WCTouchView *) graphView;
- (NSInteger)WCTouchViewMaxWeight:(WCTouchView *)graphView;
- (NSInteger)WCTouchViewMinWeight:(WCTouchView *)graphView;
- (NSInteger)WCTouchViewMaxBMI:(WCTouchView *)graphView;
- (NSInteger)WCTouchViewMinBMI:(WCTouchView *)graphView;

@end

@interface WCTouchView : UIView

@property (nonatomic, weak) id<WCTouchSource> dataSource;
@property (nonatomic) dataType dataType;



@end
