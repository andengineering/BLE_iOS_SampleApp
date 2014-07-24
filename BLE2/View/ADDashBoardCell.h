//
//  ADDashBoardCell.h
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ADDashBoardCellStyle) {
  Activity,
  BloodPressure,
  WeightSacle
};

@interface ADDashBoardCell : UITableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UIView *info;
@property (strong, nonatomic) UILabel *timeStamp;
@property (nonatomic, strong) UIView* cellView;

- (id)initWithType:(ADDashBoardCellStyle)style withView: (UIView *)view;

@end
