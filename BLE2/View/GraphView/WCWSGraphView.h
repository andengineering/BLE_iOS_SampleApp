//
//  WCWSGraphView.h
//  Wellness
//
//  Created by Chenchen Zheng on 10/27/13.
//  Copyright (c) 2013 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCWSGraphView;

@protocol WCWSDataSource <NSObject>

- (NSArray *)WSGraphViewData:(WCWSGraphView *)graphView;
- (NSInteger)WSGraphViewMaxWeight:(WCWSGraphView *)graphView;
- (NSInteger)WSGraphViewMinWeight:(WCWSGraphView *)graphView;
- (NSInteger)WSGraphViewMaxBMI:(WCWSGraphView *)graphView;
- (NSInteger)WSGraphViewMinBMI:(WCWSGraphView *)graphView;

@end


@interface WCWSGraphView : UIView

@property (nonatomic, weak) id<WCWSDataSource> dataSource;
@property dataType dataType;

@end
