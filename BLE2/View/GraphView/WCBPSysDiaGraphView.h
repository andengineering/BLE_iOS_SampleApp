//
//  WCBPGraphView.h
//  WellnessConnected
//
//  Created by Chenchen Zheng on 8/13/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class WCBPSysDiaGraphView;

@protocol WCBPSysDiaViewDataSource <NSObject>

- (NSInteger)BPGraphViewInfoCount:(WCBPSysDiaGraphView *)graphView;
- (NSArray *)BPGraphViewInfos:(WCBPSysDiaGraphView *)graphView;
- (NSInteger)BPGraphViewMaxSystolic:(WCBPSysDiaGraphView *)graphView;
- (NSInteger)BPGraphViewMinSystolic:(WCBPSysDiaGraphView *)graphView;
- (NSInteger)BPGraphViewMaxDiastolic:(WCBPSysDiaGraphView *)graphView;
- (NSInteger)BPGraphViewMinDiastolic:(WCBPSysDiaGraphView *)graphView;

@end
@interface WCBPSysDiaGraphView : UIView

@property (nonatomic, weak) IBOutlet id<WCBPSysDiaViewDataSource> dataSource;


@end
