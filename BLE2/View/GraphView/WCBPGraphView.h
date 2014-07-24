//
//  WCBPGraphView.h
//  Wellness
//
//  Created by Chenchen Zheng on 10/9/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCBPGraphView;

@protocol WCBPDataSource <NSObject>

- (NSInteger)BPGraphViewDataCount:(WCBPGraphView *)graphView;
- (NSArray *)BPGraphViewData:(WCBPGraphView *)graphView;
@optional
- (NSInteger)BPGraphViewMaxSystolic:(WCBPGraphView *)graphView;
- (NSInteger)BPGraphViewMinDiastolic:(WCBPGraphView *)graphView;
- (NSInteger)BPGraphViewMaxPulse:(WCBPGraphView *)graphView;
- (NSInteger)BPGraphViewMinPulse:(WCBPGraphView *)graphView;
@end

@interface WCBPGraphView : UIView

@property (nonatomic, weak) id<WCBPDataSource> dataSource;
@property dataType dataType;

@end
